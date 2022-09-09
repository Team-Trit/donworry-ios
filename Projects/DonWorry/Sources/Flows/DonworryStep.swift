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
    
    // TODO: 삭제하기
    case home
    
    // Login Flow
    case loginIsRequired
    case userInfoIsRequired(provider: LoginProvider, token: String)
    case bankSelectIsRequired(delegate: EnterUserInfoViewDelegate)
    case bankSelectIsComplete
    case agreeTermIsRequired(newUser: SignUpUserModel)
    case confirmTermIsRequired(checkedTerms: [String], newUser: SignUpUserModel)
}
