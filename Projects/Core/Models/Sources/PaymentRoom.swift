//
//  PaymentRoom.swift
//  Models
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public struct PaymentRoom {
    public var paymentCardList: [PaymentCard]
    public var transferList: [Transfer]

    public init(paymentCardList: [PaymentCard],
                transferList: [Transfer]) {
        self.paymentCardList = paymentCardList
        self.transferList = transferList
    }
}
