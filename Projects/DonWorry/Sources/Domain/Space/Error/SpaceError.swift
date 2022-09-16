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
    case deletedSpace // 나가려는 정산방이 삭제가 된 경우
    case undefined

    var message: String? {
        switch self {
        case .shareIDIsNotInvalid:
            return "정산방 코드를 다시 확인해주세요."
        case .alreadyJoined:
            return "이미 정산방에 참가혀섰어요!"
        case .undefined:
            return "알 수 없는 오류가 발생했어요."
        case .deletedSpace:
            return "이미 삭제된 정산방이에요! 나가주세요!"
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
