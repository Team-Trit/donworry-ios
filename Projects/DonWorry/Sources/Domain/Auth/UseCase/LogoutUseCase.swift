//
//  LogoutUseCase.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol LogoutUseCase {
    func logout() -> Observable<AuthModels.Empty.Response>
}

final class LogoutUseCaseImpl: LogoutUseCase {
    private let authRepository: AuthRepository
    private let accessTokenRepository: AccessTokenRepository
    private let userAccountRepository: UserAccountRepository
    init(
        authRepository: AuthRepository = AuthRepositoryImpl(),
        accessTokenRepository: AccessTokenRepository = AccessTokenRepositoryImpl(),
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl()
    ) {
        self.authRepository = authRepository
        self.accessTokenRepository = accessTokenRepository
        self.userAccountRepository = userAccountRepository
    }
    
    func logout() -> Observable<AuthModels.Empty.Response> {
        authRepository.logout()
            .do { [weak self] _ in
                _ = self?.accessTokenRepository.deleteAccessToken()
                _ = self?.userAccountRepository.deleteLocalUserAccount()
            }
    }
}
