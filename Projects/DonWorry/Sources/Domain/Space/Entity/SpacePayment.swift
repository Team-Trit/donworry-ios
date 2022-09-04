//
//  Payment.swift
//  DonWorryTests
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension Entity {
    struct SpacePayment {
        let id: Int
        let amount: Int
        let isCompleted: Bool
        let user: SpaceUser

        init(
            id: Int,
            amount: Int,
            isCompleted: Bool,
            user: SpaceUser
        ) {
            self.id = id
            self.amount = amount
            self.isCompleted = isCompleted
            self.user = user
        }
    }
}
