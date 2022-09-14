//
//  AuthRepository.swift
//  DonWorry
//
//  Created by Woody on 2022/09/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxKakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxSwift
import DonWorryNetworking

protocol AuthRepository {
    // 카카오 기반 회원가입 API 호출
    func signupWithKakao(request: AuthModels.SignUp.Request) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)>

    // 애플 기반 회원가입 API 호출
    func signupWithApple(requeset: AuthModels.SignUp.Request) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)>

    func kakaoLogin() -> Observable<AuthModels.Kakao.Response>
    func loginWithApple(identityToken: String) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)>
    func loginWithKakao(accessToken: String) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)>
}

final class AuthRepositoryImpl: AuthRepository {

    private let network: NetworkServable

    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    func signupWithKakao(request: AuthModels.SignUp.Request) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)> {
        network.request(createKakaoRegisterAPI(with: request))
            .compactMap { [weak self] response in
                (self?.convertToUser(with: response), self?.convertToToken(with: response)) as? (AuthModels.SignUp.Response, AuthenticationToken)
            }.asObservable()
    }


    func signupWithApple(requeset: AuthModels.SignUp.Request) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)> {
        network.request(createAppleRegisterAPI(with: requeset))
            .compactMap { [weak self] response in
                (self?.convertToUser(with: response), self?.convertToToken(with: response)) as? (AuthModels.SignUp.Response, AuthenticationToken)
            }.asObservable()
    }

    func kakaoLogin() -> Observable<AuthModels.Kakao.Response> {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return loginWithKakaoTalk()
        } else {
            return loginWithWeb()
        }
    }

    func loginWithApple(identityToken: String) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)> {
        network.request(AppleLoginAPI(identityToken: identityToken))
            .compactMap { [weak self] response in
                (self?.convertToUser(with: response), self?.convertToToken(with: response)) as? (AuthModels.SignUp.Response, AuthenticationToken)
            }.catch { [weak self] error in
                return .error(self?.judgeSignInError(error, identityToken) ?? .parsing)
            }.asObservable()
    }

    func loginWithKakao(accessToken: String) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)> {
        network.request(KakaoLoginAPI(accessToken: accessToken))
            .compactMap { [weak self] response in
                (self?.convertToUser(with: response), self?.convertToToken(with: response)) as? (AuthModels.SignUp.Response, AuthenticationToken)
            }.catch { [weak self] error in
                return .error(self?.judgeSignInError(error, accessToken) ?? .parsing)
            }.asObservable()
    }


    private func judgeSignInError(_ error: Error, _ token: String) -> AuthError {
        guard let error = error as? NetworkError else { return .parsing }
        switch error {
        case .httpStatus(let status):
            if status == 401 { return .nouser(token) }
        default: break
        }
        return .parsing
    }

    // MARK: API

    private func createKakaoRegisterAPI(with request: AuthModels.SignUp.Request) -> KakaoRegisterAPI {
        return .init(
            request: .init(
                provider: request.oauthType.rawValue,
                nickname: request.nickname,
                email: request.email,
                bank: request.bank,
                bankNumber: request.bankNumber,
                bankHolder: request.bankHolder,
                isAgreeMarketing: request.isAgreeMarketing
            ),
            accessToken: request.token
        )
    }

    private func createAppleRegisterAPI(with request: AuthModels.SignUp.Request) -> AppleRegisterAPI {
        return .init(
            request: .init(
                provider: request.oauthType.rawValue,
                nickname: request.nickname,
                email: request.email,
                bank: request.bank,
                bankNumber: request.bankNumber,
                bankHolder: request.bankHolder,
                isAgreeMarketing: request.isAgreeMarketing
            ),
            identityToken: request.token
        )
    }

    // MARK: RxKakao

    private func loginWithKakaoTalk() -> Observable<AuthModels.Kakao.Response> {
        UserApi.shared.rx.loginWithKakaoTalk()
            .map { oauthToken -> AuthModels.Kakao.Response in
                return .init(token: oauthToken.accessToken)
            }.catch { _ in .error(AuthError.kakaoLogin) }
    }

    private func loginWithWeb() -> Observable<AuthModels.Kakao.Response> {
        UserApi.shared.rx.loginWithKakaoAccount()
            .map { oauthToken -> AuthModels.Kakao.Response in
                return .init(token: oauthToken.accessToken)
            }.catch { _ in .error(AuthError.kakaoLogin) }
    }

    // MARK: Converting

    private func convertToUser(with dto: DTO.PostUser) -> AuthModels.SignUp.Response {
        return .init(
            user: .init(
                id: dto.id,
                nickName: dto.nickname,
                bankAccount: .init(
                    bank: dto.account.bank,
                    accountHolderName: dto.account.holder,
                    accountNumber: dto.account.number
                ),
                image: dto.imgUrl ?? ""
            )
        )
    }

    private func convertToToken(with dto: DTO.PostUser) -> AuthenticationToken {
        return .init(type: dto.tokenType, accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }



}
