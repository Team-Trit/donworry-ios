//
//  DeRegisterUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/09/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol DeRegisterUseCase {
    func deregister() -> Observable<AuthModels.Empty.Response>
}

final class DeRegisterUseCaseImpl: DeRegisterUseCase {
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

    func deregister() -> Observable<AuthModels.Empty.Response> {
        authRepository.deregister()
            .do(onNext: { [weak self] _ in
                _ = self?.accessTokenRepository.deleteAccessToken()
                _ = self?.userAccountRepository.deleteLocalUserAccount()
            }
            )
                }
}

