//
//  BankAccount.swift
//  Models
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public struct BankAccount {
    public var bank: Bank
    public var accountName: String
    public var accountNumber: String

    public init(bank: Bank,
                accountName: String,
                accountNumber: String) {
        self.bank = bank
        self.accountName = accountName
        self.accountNumber = accountNumber
    }
}
