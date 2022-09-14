//
//  AuthModels.swift
//  DonWorry
//
//  Created by Woody on 2022/09/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models

enum AuthModels {

    enum OAuthType: String {
        case kakao = "KAKAO"
        case apple = "APPLE"
    }

    // MARK: 회원가입

    enum SignUp {
        struct Request {
            var nickname: String
            var email: String
            var imgURL: String?
            var bank: String
            var bankNumber: String
            var bankHolder: String
            var isAgreeMarketing: Bool
            var token: String
            var oauthType: OAuthType

            static var initialValue: Request = .init(nickname: "", email: "", imgURL: nil, bank: "은행선택", bankNumber: "", bankHolder: "", isAgreeMarketing: false, token: "", oauthType: .apple)
        }

        struct Response {
            let user: User
        }
    }

    // MARK: 로그인

    enum SignIn {
        struct Reqeust {
            let oauthType: OAuthType
            let token: String
        }

        struct Response {
            let localUser: LocalUser
        }
    }

    enum Kakao {
        struct Response {
            let token: String
        }
    }

    enum Empty {
        struct Response {}
    }
}
