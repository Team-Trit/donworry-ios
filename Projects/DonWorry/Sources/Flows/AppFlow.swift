//
//  AppFlow.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import RxCocoa
import RxFlow

final class AppFlow: Flow {
    var root: Presentable {
        return self.rootWindow
    }
    private var rootWindow: UIWindow
    
    init(with window: UIWindow) {
        self.rootWindow = window
    }
    
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? DonworryStep else { return .none }
        
        switch step {
        case .loginIsRequired:
            return navigateToLoginScreen()
        case .homeIsRequired:
            return navigateToHomeScreen()
        default:
            return .none
        }
    }
}

// MARK: - Navigate Methods
extension AppFlow {
    private func navigateToLoginScreen() -> FlowContributors {
        let loginFlow = LoginFlow()
        Flows.use(loginFlow, when: .created) { [unowned self] root in
            self.rootWindow.rootViewController = root
        }
        let nextStep = OneStepper(withSingleStep: DonworryStep.loginIsRequired)
        return .one(flowContributor: .contribute(withNextPresentable: loginFlow, withNextStepper: nextStep))
    }
    
    private func navigateToHomeScreen() -> FlowContributors {
        // MARK: HomeFlow부터는 RxFlow 사용 안함
        let homeViewController = HomeViewController()
        let homeReactor = HomeReactor()
        homeViewController.reactor = homeReactor
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        self.rootWindow.rootViewController = navigationController
        return .none
    }
}

// MARK: - AppStepper
final class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    var initialStep: Step {
        return DonworryStep.loginIsRequired
    }
    
    init() {
        
    }
}
