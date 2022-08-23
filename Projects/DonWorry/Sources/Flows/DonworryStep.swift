//
//  DonworryStep.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import RxFlow

enum DonworryStep: Step {
    // Login Flow
    case loginIsRequired
    case userInfoIsRequired
    case bankSelectIsRequired
    case bankSelectIsComplete
    case agreeTermIsRequired
    case confirmTermIsRequired
    case confirmTermIsComplete
    
}
