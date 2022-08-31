//
//  AccessTokenRepository.swift
//  DonWorry
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import DonWorryLocalStorage

protocol AccessTokenRepository {
    func fetchAccessToken() -> AccessToken?
    func saveAccessToken(_ accessToken: AccessToken) -> Bool
    func deleteAccessToken() -> Bool
}

final class AccessTokenRepositoryImpl: AccessTokenRepository {
    private let localStorage: LocalStorage
    
    init(localStorage: LocalStorage = UserDefaults.standard) {
        self.localStorage = localStorage
    }

    func fetchAccessToken() -> AccessToken? {
        localStorage.read(key: .accessToken, type: AccessToken.self)
    }

    func saveAccessToken(_ accessToken: AccessToken) -> Bool {
        localStorage.write(accessToken, key: .accessToken)
        return true
    }

    func deleteAccessToken() -> Bool {
        localStorage.remove(key: .accessToken)
        return true
    }
}

typealias AccessToken = String
