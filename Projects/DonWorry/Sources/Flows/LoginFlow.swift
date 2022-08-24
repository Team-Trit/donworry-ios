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
    
    //    private let services: AppServices
    //
    //    init(withServices services: AppServices) {
    //        self.services = services
    //    }
    
    private lazy var rootViewController: UINavigationController = {
        let v = UINavigationController()
        
        return v
    }()
    
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? DonworryStep else { return .none }
        
        switch step {
        case .loginIsRequired:
            return self.navigateToLoginView()
            
        case .userInfoIsRequired:
            return self.navigateToEnterUserInfoView()
            
        case .bankSelectIsRequired:
            return self.presentBankSelectView()
            
        case .bankSelectIsComplete:
            self.dismissBankSelectView()
            return .none
            //
            //        case .agreeTermIsRequired:
            //            return self.navigateToAgreeTermView()
            //
            //        case .confirmTermIsRequired:
            //            return self.presentConfirmTermView()
            //
            //        case .confirmTermIsComplete:
            //            self.dismissConfirmTermView()
            //            return .none
            //        }
        default:
            return .none
        }
    }
}

// MARK: - Navigate Methods
extension LoginFlow {
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
    
    private func dismissBankSelectView() {
        self.rootViewController.dismiss(animated: true)
    }
    
    //    private func navigateToAgreeTermView() -> FlowContributors {
    //
    //    }
    //
    //    private func presentConfirmTermView() -> FlowContributors {
    //
    //    }
    //
    //    private func dismissConfirmTermView() {
    //
    //    }
}
