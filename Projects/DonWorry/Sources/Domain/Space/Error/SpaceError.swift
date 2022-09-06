//
//  SpaceError.swift
//  DonWorry
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum SpaceError: Error {
    case alreadyJoined // 정산방에 이미 참석해있는 경우
    case deletedSpace // 나가려는 정산방이 삭제가 된 경우
    case undefined
}
