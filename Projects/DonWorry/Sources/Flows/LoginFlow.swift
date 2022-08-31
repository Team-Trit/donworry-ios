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
            
        case .userInfoIsRequired:
            return self.navigateToEnterUserInfoView()
            
        case .bankSelectIsRequired:
            return self.presentBankSelectView()
            
        case let .bankSelectIsComplete(selectedBank):
            self.dismissBankSelectView(with: selectedBank)
            return .none
            
        case .agreeTermIsRequired:
            return self.navigateToAgreeTermView()
            
        case .confirmTermIsRequired:
            return self.presentConfirmTermView()
            
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
    
    private func navigateToEnterUserInfoView() -> FlowContributors {
        let vc = EnterUserInfoViewController()
        let reactor = EnterUserInfoViewReactor()
        vc.reactor = reactor
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func presentBankSelectView() -> FlowContributors {
        let vc = SelectBankViewController()
        let reactor = SelectBankViewReactor()
        vc.reactor = reactor
        self.rootViewController.present(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func dismissBankSelectView(with selectedBank: String?) {
        // MARK: Business logic here is awkward...maybe?
        if let selectedBank = selectedBank, let vc = self.rootViewController.topViewController as? EnterUserInfoViewController {
            vc.accountStackView.accountInputField.chooseBankButton.setTitle(selectedBank, for: .normal)
        }
        self.rootViewController.dismiss(animated: true)
    }
    
    private func navigateToAgreeTermView() -> FlowContributors {
        let vc = AgreeTermViewController()
        let reactor = AgreeTermViewReactor()
        vc.reactor = reactor
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
    
    private func presentConfirmTermView() -> FlowContributors {
        let vc = ConfirmTermViewController()
        let reactor = ConfirmTermViewReactor()
        vc.reactor = reactor
        vc.modalPresentationStyle = .overCurrentContext
        self.rootViewController.present(vc, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
}
