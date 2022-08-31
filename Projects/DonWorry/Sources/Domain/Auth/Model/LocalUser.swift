//
//  LocalUser.swift
//  DonWorry
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

struct LocalUser: Codable {
    typealias ID = Int

    var id: ID
    var nickName: String
    var bankAccount: LocalBankAccount
    var image: String

    init(id: Int,
         nickName: String,
         bankAccount: LocalBankAccount,
         image: String) {
        self.id = id
        self.nickName = nickName
        self.bankAccount = bankAccount
        self.image = image
    }
}
