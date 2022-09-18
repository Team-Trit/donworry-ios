//
//  FCMDeviceTokenRepository.swift
//  DonWorry
//
//  Created by Woody on 2022/09/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import DonWorryLocalStorage

protocol FCMDeviceTokenRepository {
    func fetchFCMToken() -> String?
}

final class FCMDeviceTokenRepositoryImpl: FCMDeviceTokenRepository {
    private let localStorage: LocalStorage

    init(localStorage: LocalStorage = UserDefaults.standard) {
        self.localStorage = localStorage
    }

    func fetchFCMToken() -> String? {
        localStorage.read(key: .fcmDeviceToken, type: String.self)
    }
}
