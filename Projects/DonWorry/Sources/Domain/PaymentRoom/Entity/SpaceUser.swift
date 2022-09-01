//
//  PaymentRoomUser.swift
//  DonWorryTests
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension Entity {
    struct SpaceUser {
        let id: Int
        let nickname: String
        let imgURL: String

        init(
            id: Int,
            nickname: String,
            imgURL: String
        ) {
            self.id = id
            self.nickname = nickname
            self.imgURL = imgURL
        }
    }
}
