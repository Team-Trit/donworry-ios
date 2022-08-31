//
//  LocalBank.swift
//  DonWorry
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

struct LocalBankAccount: Codable {
    var bank: String
    var accountHolderName: String
    var accountNumber: String

    init(bank: String,
         accountHolderName: String,
         accountNumber: String) {
        self.bank = bank
        self.accountHolderName = accountHolderName
        self.accountNumber = accountNumber
    }
}
