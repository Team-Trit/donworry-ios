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
    private let tokenRepository: DeviceTokenRepository

    init(
        authRepository: AuthRepository = AuthRepositoryImpl(),
        accessTokenRepository: AccessTokenRepository = AccessTokenRepositoryImpl(),
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl(),
        tokenRepository: DeviceTokenRepository = DeviceTokenRepositoryImpl()
    ) {
        self.authRepository = authRepository
        self.accessTokenRepository = accessTokenRepository
        self.userAccountRepository = userAccountRepository
        self.tokenRepository = tokenRepository
    }

    func signUp(request: AuthModels.SignUp.Request) -> Observable<AuthModels.Empty.Response> {
        guard let fcmToken = tokenRepository.fetchDeviceToken() else { return .just(.init()) }
        switch request.oauthType {
        case .apple:
            return authRepository.signupWithApple(requeset: request, fcmToken: fcmToken, authorizationCode: request.authorizationCode ?? "")
                .map { [weak self] (user, authentication) -> AuthModels.Empty.Response in
                    _ = self?.userAccountRepository.saveLocalUserAccount(user.user)
                    _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
                    return .init()
                }
        case .kakao:
            return authRepository.signupWithKakao(request: request, fcmToken: fcmToken)
                .map { [weak self] (user, authentication) -> AuthModels.Empty.Response in
                    _ = self?.userAccountRepository.saveLocalUserAccount(user.user)
                    _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
                    return .init()
                }
        }
    }
}
