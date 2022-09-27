//
//  FCMDeviceTokenRepository.swift
//  DonWorry
//
//  Created by Woody on 2022/09/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import DonWorryLocalStorage

protocol DeviceTokenRepository {
    func fetchDeviceToken() -> String?
}

final class DeviceTokenRepositoryImpl: DeviceTokenRepository {
    private let localStorage: LocalStorage

    init(localStorage: LocalStorage = UserDefaults.standard) {
        self.localStorage = localStorage
    }

    func fetchDeviceToken() -> String? {
        localStorage.read(key: .deviceToken, type: String.self)
    }
}
