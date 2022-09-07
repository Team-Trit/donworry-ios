//
//  LoginFlow.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import RxFlow

final class LoginFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    private lazy var rootViewController: UINavigationController = {
        let v = UINavigationController()
        v.isNavigationBarHidden = true
        return v
    }()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? DonworryStep else { return .none }
        
        switch step {
        case .popViewController:
            return self.popViewController()
            
        case .loginIsRequired:
            return self.navigateToLoginView()
            
        case .userInfoIsRequired(let accessToken):
            return self.navigateToEnterUserInfoView(accessToken: accessToken)
            
        case .bankSelectIsRequired(let delegate):
            return self.presentBankSelectView(delegate)
            
        case .bankSelectIsComplete:
            self.dismissBankSelectView()
            return .none
            
        case let .agreeTermIsRequired(accessToken, nickname, bank, holder, number):
            return self.navigateToAgreeTermView(accessToken: accessToken,
                                                nickname: nickname,
                                                bank: bank,
                                                holder: holder,
                                                number: number)
            
        case let .confirmTermIsRequired(checkedTerms, accessToken, nickname, bank, holder, number, isAgreeMarketing):
            return self.presentConfirmTermView(checkedTerms: checkedTerms,
                                               accessToken: accessToken,
                                               nickname: nickname,
                                               bank: bank,
                                               holder: holder,
                                               number: number,
                                               isAgreeMarketing: isAgreeMarketing)
            
        case .homeIsRequired:
            return .end(forwardToParentFlowWithStep: DonworryStep.homeIsRequired)
        }
    }
}

// MARK: - Navigate Methods
extension LoginFlow {
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        return .none
    }
    
    private func navigateToLoginView() -> FlowContributors {
        let vc = LoginViewController()
        let reactor = LoginViewReactor()
        vc.reactor = reactor
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func navigateToEnterUserInfoView(accessToken: String) -> FlowContributors {
        let vc = EnterUserInfoViewController()
        let reactor = EnterUserInfoViewReactor(accessToken: accessToken)
        vc.reactor = reactor
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func presentBankSelectView(_ delegate: EnterUserInfoViewDelegate) -> FlowContributors {
        let vc = SelectBankViewController()
        let reactor = SelectBankViewReactor(delegate: delegate, parentView: .enterUserInfo)
        vc.reactor = reactor
        self.rootViewController.present(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func dismissBankSelectView(with selectedBank: String?) {
        // MARK: Business logic here is awkward...maybe?
        print("🚑🚑🚑🚑")
        print(rootViewController.viewControllers)
        print("🚑🚑🚑🚑")
        if let selectedBank = selectedBank, let vc = self.rootViewController.topViewController as? EnterUserInfoViewController {
            vc.accountStackView.accountInputField.chooseBankButton.setTitle(selectedBank, for: .normal)
        }
        self.rootViewController.dismiss(animated: true)
    }
    
    private func navigateToAgreeTermView(accessToken: String, nickname: String, bank: String, holder: String, number: String) -> FlowContributors {
        let vc = AgreeTermViewController()
        let reactor = AgreeTermViewReactor(accessToken: accessToken, nickname: nickname, bank: bank, holder: holder, number: number)
        vc.reactor = reactor
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func presentConfirmTermView(checkedTerms: [String], accessToken: String, nickname: String, bank: String, holder: String, number: String, isAgreeMarketing: Bool) -> FlowContributors {
        let vc = ConfirmTermViewController()
        let reactor = ConfirmTermViewReactor(checkedTerms: checkedTerms, accessToken: accessToken, nickname: nickname, bank: bank, holder: holder, number: number, isAgreeMarketing: isAgreeMarketing)
        vc.reactor = reactor
        vc.modalPresentationStyle = .overCurrentContext
        self.rootViewController.present(vc, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
}
