//
//  UserAccountRepository.swift
//  DonWorry
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models
import DonWorryLocalStorage

protocol UserAccountRepository {
    func fetchLocalUserAccount() -> User?                // 로컬 유저 정보 가져오기
    func saveLocalUserAccount(_ user: User) -> Bool      // 로컬에 유저 저장하기
    func deleteLocalUserAccount() -> Bool                       // 로컬 유저 정보 삭제
}

final class UserAccountRepositoryImpl: UserAccountRepository {
    private let localStorage: LocalStorage

    init(localStorage: LocalStorage = UserDefaults.standard) {
        self.localStorage = localStorage
    }

    func fetchLocalUserAccount() -> User? {
        let localUser = localStorage.readCodable(key: .userAccount, type: LocalUser.self)
        return convertToUser(localUser: localUser)
    }

    func saveLocalUserAccount(_ user: User) -> Bool {
        localStorage.writeCodable(convertToLocalUser(user: user), key: .userAccount)
    }

    func deleteLocalUserAccount() -> Bool {
        localStorage.remove(key: .userAccount)
        return true
    }
}

extension UserAccountRepositoryImpl {
    private func convertToLocalUser(user: User) -> LocalUser {
        let bankAccount = user.bankAccount
        return .init(id: user.id, nickName: user.nickName, bankAccount: .init(bank: bankAccount.bank, accountHolderName: bankAccount.accountHolderName, accountNumber: bankAccount.accountNumber), image: user.image)
    }

    private func convertToUser(localUser: LocalUser?) -> User? {
        guard let localUser = localUser else { return nil }
        let localBankAccount = localUser.bankAccount
        return .init(
            id: localUser.id,
            nickName: localUser.nickName,
            bankAccount: .init(bank: localBankAccount.bank, accountHolderName: localBankAccount.accountHolderName, accountNumber: localBankAccount.accountNumber),
            image: localUser.image ?? "")
    }
}
