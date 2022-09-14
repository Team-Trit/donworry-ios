//
//  UserError.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/12.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum UserError: Error {
    case isNotMe

    var message: String {
        switch self {
        case .isNotMe:
            return "정산내역 카드를 만드셔서 참석을 해제할 수 없어요!"
        }
    }
}

extension Error {
    func toUserError() -> UserError? {
        guard let error =  self as? UserError else {
            return nil
        }
        return error
    }
}
