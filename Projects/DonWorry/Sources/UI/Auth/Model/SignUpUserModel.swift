//
//  SignUpUserModel.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum LoginProvider: String {
    case none
    case APPLE
    case GOOGLE
    case KAKAO
}

struct SignUpUserModel {
    var provider: LoginProvider
    var nickname: String
    var email: String
    var bank: String
    var bankNumber: String
    var bankHolder: String
    var isAgreeMarketing: Bool
    var accessToken: String
}
