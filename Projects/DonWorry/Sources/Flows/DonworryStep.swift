//
//  DonworryStep.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import RxFlow

enum DonworryStep: Step {
    // Global
    case none
    case popViewController
    
    // Temporary
    case home
    
    // Login Flow
    case loginIsRequired
    case userInfoIsRequired(provider: LoginProvider, accessToken: String)
    case bankSelectIsRequired(delegate: EnterUserInfoViewDelegate)
    case bankSelectIsComplete
    case agreeTermIsRequired(newUser: SignUpUserModel)
    case confirmTermIsRequired(checkedTerms: [String], newUser: SignUpUserModel)
}
