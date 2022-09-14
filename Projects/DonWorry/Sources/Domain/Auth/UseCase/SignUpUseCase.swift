//
//  SignUpUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/09/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol SignUpUseCase {
    func signUp(request: AuthModels.SignUp.Request) -> Observable<AuthModels.Empty.Response>
}

final class SignUpUseCaseImpl: SignUpUseCase {
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

    func signUp(request: AuthModels.SignUp.Request) -> Observable<AuthModels.Empty.Response> {
        switch request.oauthType {
        case .apple:
            return authRepository.signupWithApple(requeset: request)
                .map { [weak self] (user, authentication) -> AuthModels.Empty.Response in
                    _ = self?.userAccountRepository.saveLocalUserAccount(user.user)
                    _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
                    return .init()
                }
        case .kakao:
            return authRepository.signupWithKakao(request: request)
                .map { [weak self] (user, authentication) -> AuthModels.Empty.Response in
                    _ = self?.userAccountRepository.saveLocalUserAccount(user.user)
                    _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
                    return .init()
                }
        }
    }
}
