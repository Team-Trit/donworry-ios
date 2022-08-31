//
//  BankAccount.swift
//  Models
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public struct BankAccount {
    public var bank: String
    public var accountHolderName: String
    public var accountNumber: String

    public init(bank: String,
                accountHolderName: String,
                accountNumber: String) {
        self.bank = bank
        self.accountHolderName = accountHolderName
        self.accountNumber = accountNumber
    }
}

extension BankAccount {
    public static let empty: BankAccount = .init(bank: "", accountHolderName: "", accountNumber: "") 
}
