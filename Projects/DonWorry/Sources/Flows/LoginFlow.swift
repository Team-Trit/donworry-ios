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
            // MARK: - Temporary
        case .home:
            return .none
            
        case .none:
            return .none
            
        case .popViewController:
            return self.popViewController()
            
        case .loginIsRequired:
            return self.navigateToLoginView()
            
        case let .userInfoIsRequired(provider, accessToken):
            return self.navigateToEnterUserInfoView(provider: provider, accessToken: accessToken)
            
        case .bankSelectIsRequired(let delegate):
            return self.presentBankSelectView(delegate)
            
        case .bankSelectIsComplete:
            self.dismissBankSelectView()
            return .none
            
        case .agreeTermIsRequired(let newUser):
            return self.navigateToAgreeTermView(newUser: newUser)
            
        case let .confirmTermIsRequired(checkedTerms, newUser):
            return self.presentConfirmTermView(checkedTerms: checkedTerms, newUser: newUser)
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
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func navigateToEnterUserInfoView(provider: LoginProvider, accessToken: String) -> FlowContributors {
        let vc = EnterUserInfoViewController()
        let reactor = EnterUserInfoViewReactor(provider: provider, accessToken: accessToken)
        vc.reactor = reactor
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func presentBankSelectView(_ delegate: EnterUserInfoViewDelegate) -> FlowContributors {
        let vc = SelectBankViewController()
        let reactor = SelectBankViewReactor(userInfoViewDelegate: delegate, parentView: .enterUserInfo)
        vc.reactor = reactor
        self.rootViewController.present(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    
    private func dismissBankSelectView() {
        self.rootViewController.dismiss(animated: true)
    }
    
    private func navigateToAgreeTermView(newUser: SignUpUserModel) ->FlowContributors {
        let vc = AgreeTermViewController()
        let reactor = AgreeTermViewReactor(newUser: newUser)
        vc.reactor = reactor
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func presentConfirmTermView(checkedTerms: [String], newUser: SignUpUserModel) -> FlowContributors {
        let vc = ConfirmTermViewController()
        let reactor = ConfirmTermViewReactor(checkedTerms: checkedTerms, newUser: newUser, userService: UserServiceImpl())
        vc.reactor = reactor
        vc.modalPresentationStyle = .overCurrentContext
        self.rootViewController.present(vc, animated: false)
        return .one(flowContributor: .contribute(withNext: vc))
    }
}
