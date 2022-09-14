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
    var completeKakaoLogin: PublishSubject<AuthModels.Empty.Response> { get }

    func kakaoLogin() -> Observable<AuthModels.Empty.Response>
    func signInWithApple(request: AuthModels.SignIn.Reqeust) -> Observable<AuthModels.Empty.Response>
}

final class SignInUseCaseImpl: SignInUseCase {
    private let authRepository: AuthRepository
    private let accessTokenRepository: AccessTokenRepository
    private let userAccountRepository: UserAccountRepository

    let kakaoLoginToken: PublishSubject<AuthModels.Kakao.Response>
    var completeKakaoLogin: PublishSubject<AuthModels.Empty.Response>
    var disposeBag: DisposeBag

    init(
        authRepository: AuthRepository = AuthRepositoryImpl(),
        accessTokenRepository: AccessTokenRepository = AccessTokenRepositoryImpl(),
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl()
    ) {
        self.kakaoLoginToken = .init()
        self.completeKakaoLogin = .init()
        self.disposeBag = .init()
        self.authRepository = authRepository
        self.accessTokenRepository = accessTokenRepository
        self.userAccountRepository = userAccountRepository


        kakaoLoginToken.subscribe(onNext: { [weak self] in
            self?.signInWithKakao(token: $0.token)
        }).disposed(by: disposeBag)
    }

    func kakaoLogin() -> Observable<AuthModels.Empty.Response> {
        authRepository.kakaoLogin()
            .map { [weak self] token in
                self?.kakaoLoginToken.onNext(token)
                return .init()
            }
    }

    func signInWithApple(request: AuthModels.SignIn.Reqeust) -> Observable<AuthModels.Empty.Response> {
        authRepository.loginWithApple(identityToken: request.token)
            .map { [weak self] (user, authentication) -> AuthModels.Empty.Response in
                _ = self?.userAccountRepository.saveLocalUserAccount(user.user)
                _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
                return .init()
            }
    }

    private func signInWithKakao(token: String) {
        authRepository.loginWithKakao(accessToken: token)
            .subscribe(onNext: { [weak self] (user, authentication) in
                _ = self?.userAccountRepository.saveLocalUserAccount(user.user)
                _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
                self?.completeKakaoLogin.onNext(.init())
            }, onError: { [weak self] in
                self?.completeKakaoLogin.onError($0)
            }).disposed(by: disposeBag)
    }
}
