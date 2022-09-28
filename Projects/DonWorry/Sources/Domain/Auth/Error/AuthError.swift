//
//  AuthError.swift
//  DonWorry
//
//  Created by Woody on 2022/09/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum AuthError: Error {
    case nouser(String)
    case kakaoLogin // 카카오쪽에서 로그인 실패
    case parsing
    case duplicatedNickname
    case appleLogin // 애플로그인 실패

    var message: String {
        switch self {
        case .nouser:
            return ""
        case .kakaoLogin:
            return "카카오 로그인 실패"
        case .parsing:
            return "알 수 없는 오류... 다시 시도해주세요."
        case .duplicatedNickname:
            return "현재 사용 중인 닉네임입니다."
        case .appleLogin:
            return "애플 로그인 실패"
        }
    }
}

extension Error {
    func toAuthError() -> AuthError? {
        guard let error = self as? AuthError else {
            return nil
        }
        return error
    }
}
