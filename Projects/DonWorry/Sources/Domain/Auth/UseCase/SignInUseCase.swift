//
//  SignInUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/09/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol SignInUseCase {
    func kakaoLogin() -> Observable<AuthModels.Kakao.Response>
    func signInWithApple(request: AuthModels.SignIn.Reqeust, authorizationCode: String) -> Observable<AuthModels.Empty.Response>
    func signInWithKakao(request: AuthModels.SignIn.Reqeust) -> Observable<AuthModels.Empty.Response>
}

final class SignInUseCaseImpl: SignInUseCase {
    private let authRepository: AuthRepository
    private let accessTokenRepository: AccessTokenRepository
    private let userAccountRepository: UserAccountRepository
    private let tokenRepository: DeviceTokenRepository

    let kakaoLoginToken: PublishSubject<AuthModels.Kakao.Response>
    var completeKakaoLogin: PublishSubject<AuthModels.Empty.Response>
    var disposeBag: DisposeBag

    init(
        authRepository: AuthRepository = AuthRepositoryImpl(),
        accessTokenRepository: AccessTokenRepository = AccessTokenRepositoryImpl(),
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl(),
        tokenRepository: DeviceTokenRepository = DeviceTokenRepositoryImpl()
    ) {
        self.kakaoLoginToken = .init()
        self.completeKakaoLogin = .init()
        self.disposeBag = .init()
        self.authRepository = authRepository
        self.accessTokenRepository = accessTokenRepository
        self.userAccountRepository = userAccountRepository
        self.tokenRepository = tokenRepository
    }

    func kakaoLogin() -> Observable<AuthModels.Kakao.Response> {
        authRepository.kakaoLogin()
    }

    func signInWithKakao(request: AuthModels.SignIn.Reqeust) -> Observable<AuthModels.Empty.Response> {
        guard let deviceToken = tokenRepository.fetchDeviceToken() else { return .error(AuthError.kakaoLogin) }

        return authRepository.loginWithKakao(accessToken: request.token, deviceToken: deviceToken)
            .map { [weak self] (user, authentication) -> AuthModels.Empty.Response in
                _ = self?.userAccountRepository.saveLocalUserAccount(user.user)
                _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
                return .init()
            }
    }

    func signInWithApple(request: AuthModels.SignIn.Reqeust, authorizationCode: String) -> Observable<AuthModels.Empty.Response> {
        guard let deviceToken = tokenRepository.fetchDeviceToken() else { return .error(AuthError.appleLogin) }
        return authRepository.loginWithApple(identityToken: request.token, deviceToken: deviceToken, authorizationCode:  authorizationCode)
            .map { [weak self] (user, authentication) -> AuthModels.Empty.Response in
                _ = self?.userAccountRepository.saveLocalUserAccount(user.user)
                _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
                return .init()
            }
    }

}
