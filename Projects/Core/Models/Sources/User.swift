//
//  User.swift
//  Models
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public struct User {
    public typealias ID = Int

    public var id: ID
    public var nickName: String
    public var bankAccount: BankAccount
    public var image: String

    public init(id: Int,
                nickName: String,
                bankAccount: BankAccount,
                image: String) {
        self.id = id
        self.nickName = nickName
        self.bankAccount = bankAccount
        self.image = image
    }
}
