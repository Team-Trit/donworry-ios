//
//  PaymentCard.swift
//  Models
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

/// 정산 카드
public struct PaymentCard {
    public var id: Int
    public var name: String
    public var cardIcon: PaymentCardIcon
    public var totalAmount: Money
    public var payer: User
    public var backgroundColor: String
    public var date: Date
    public var bankAccount: BankAccount?
    public var images: [String]?
    public var participatedUserList: [User]
    
    public init(id: Int,
                name: String,
                cardIcon: PaymentCardIcon,
                totalAmount: Money,
                payer: User,
                backgroundColor: String,
                date: Date,
                bankAccount: BankAccount?,
                images: [String]?,
                participatedUserList: [User]) {
        self.id = id
        self.name = name
        self.cardIcon = cardIcon
        self.totalAmount = totalAmount
        self.payer = payer
        self.backgroundColor = backgroundColor
        self.date = date
        self.bankAccount = bankAccount
        self.images = images
        self.participatedUserList = participatedUserList
    }
}
