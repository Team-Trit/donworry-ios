//
//  Transfer.swift
//  Models
//
//  Created by Woody on 2022/08/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public struct Transfer {
    public var giver: User
    public var taker: User
    public var amount: Money
    public var isCompleted: Bool

    public init(giver: User,
                taker: User,
                amount: Money,
                isCompleted: Bool) {
        self.giver = giver
        self.taker = taker
        self.amount = amount
        self.isCompleted = isCompleted
    }
}
