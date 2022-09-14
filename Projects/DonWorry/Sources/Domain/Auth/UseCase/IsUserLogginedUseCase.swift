//
//  IsUserLogginedUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/09/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

protocol IsUserLogginedUseCase {
    func isUserLoggined() -> Bool
}

final class IsUserLogginedUseCaseImpl: IsUserLogginedUseCase {
    private let userAccountRepository: UserAccountRepository
    private let accessTokenRepository: AccessTokenRepository
    init(
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl(),
        accessTokenRepository: AccessTokenRepository = AccessTokenRepositoryImpl()
    ) {
        self.userAccountRepository = userAccountRepository
        self.accessTokenRepository = accessTokenRepository
    }

    func isUserLoggined() -> Bool {
        if let _ = accessTokenRepository.fetchAccessToken(),
           let _ = userAccountRepository.fetchLocalUserAccount() {
            return true
        }
        return false
    }
}
