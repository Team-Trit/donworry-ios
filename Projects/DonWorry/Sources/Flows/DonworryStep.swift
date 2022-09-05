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
    case popViewController
    
    // Login Flow
    case loginIsRequired
    case userInfoIsRequired(accessToken: String)
    case bankSelectIsRequired(delegate: EnterUserInfoViewReactor)
    case bankSelectIsComplete
    case agreeTermIsRequired(accessToken: String, nickname: String, bank: String, holder: String, number: String)
    case confirmTermIsRequired(checkedTerms: [String], accessToken: String, nickname: String, bank: String, holder: String, number: String, isAgreeMarketing: Bool)
    case homeIsRequired
}
