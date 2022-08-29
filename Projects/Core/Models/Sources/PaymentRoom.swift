//
//  PaymentRoom.swift
//  Models
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public struct PaymentRoom {
    public var id: Int
    public var code: String
    public var name: String
    public var admin: User
    public var paymentCardList: [PaymentCard]
    public var transferList: [Transfer]?

    public init(id: Int,
                code: String,
                name: String,
                admin: User,
                paymentCardList: [PaymentCard],
                transferList: [Transfer]?) {
        self.id = id
        self.code = code
        self.name = name
        self.admin = admin
        self.paymentCardList = paymentCardList
        self.transferList = transferList
    }
}
