//
//  UserUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models
import RxSwift

protocol UserUseCase {
    func fetchUser() -> Observable<User>
}

final class UserUseCaseImpl: UserUseCase {

    init(
        localStorage: LocalStorage = UserDefaults.standard
    ) {
        self.localStorage = localStorage
    }

    func fetchUser() -> Observable<User> {
        localStorage.readCodable(key: .user).compactMap { (user) in user.map { $0 } }
    }

    private let localStorage: LocalStorage
}
