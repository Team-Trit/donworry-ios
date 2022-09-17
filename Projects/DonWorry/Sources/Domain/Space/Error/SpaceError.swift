//
//  SpaceError.swift
//  DonWorry
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum SpaceError: Error {
    case shareIDIsNotInvalid // 정산방 코드가 잘못된 경우
    case alreadyJoined // 정산방에 이미 참석해있는 경우
    case alreadyStarted
    case undefined

    var message: String? {
        switch self {
        case .shareIDIsNotInvalid:
            return "없는 정산방이에요." // 400
        case .alreadyJoined:
            return "이미 정산방에 참가하섰어요!" // 403
        case .alreadyStarted:
            return "정산이 이미 시작된 방이라 참석할 수 없어요!" // 409
        case .undefined:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

extension Error {
    func toSpaceError() -> SpaceError? {
        guard let error = self as? SpaceError else {
            return nil
        }
        return error
    }
}
