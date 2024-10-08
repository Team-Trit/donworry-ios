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
    func signupWithKakao(request: AuthModels.SignUp.Request, fcmToken: String) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)>

    // 애플 기반 회원가입 API 호출
    func signupWithApple(requeset: AuthModels.SignUp.Request, fcmToken: String, authorizationCode: String) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)>

    func kakaoLogin() -> Observable<AuthModels.Kakao.Response>
    func loginWithApple(identityToken: String, deviceToken: String, authorizationCode: String) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)>
    func loginWithKakao(accessToken: String, deviceToken: String) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)>
    func logout() -> Observable<AuthModels.Empty.Response>
    func deregister() -> Observable<AuthModels.Empty.Response>
    func checkNickname(nickname: String) -> Observable<AuthModels.Empty.Response>
}

final class AuthRepositoryImpl: AuthRepository {

    private let network: NetworkServable

    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    func signupWithKakao(request: AuthModels.SignUp.Request, fcmToken: String) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)> {
        network.request(createKakaoRegisterAPI(with: request, fcmToken: fcmToken))
            .compactMap { [weak self] response in
                (self?.convertToUser(with: response), self?.convertToToken(with: response)) as? (AuthModels.SignUp.Response, AuthenticationToken)
            }.asObservable()
    }


    func signupWithApple(requeset: AuthModels.SignUp.Request, fcmToken: String, authorizationCode: String) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)> {
        network.request(createAppleRegisterAPI(with: requeset, fcmToken: fcmToken, authorizationCode: authorizationCode))
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

    func loginWithApple(identityToken: String, deviceToken: String, authorizationCode: String) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)> {
        network.request(AppleLoginAPI(identityToken: identityToken, fcmToken: deviceToken, authorizationCode: authorizationCode))
            .compactMap { [weak self] response in
                (self?.convertToUser(with: response), self?.convertToToken(with: response)) as? (AuthModels.SignUp.Response, AuthenticationToken)
            }.catch { [weak self] error in
                return .error(self?.judgeSignInError(error, identityToken) ?? .parsing)
            }.asObservable()
    }

    func loginWithKakao(accessToken: String, deviceToken: String) -> Observable<(AuthModels.SignUp.Response, AuthenticationToken)> {
        network.request(KakaoLoginAPI(accessToken: accessToken, fcmToken: deviceToken))
            .compactMap { [weak self] response in
                (self?.convertToUser(with: response), self?.convertToToken(with: response)) as? (AuthModels.SignUp.Response, AuthenticationToken)
            }.catch { [weak self] error in
                return .error(self?.judgeSignInError(error, accessToken) ?? .parsing)
            }.asObservable()
    }
    
    func logout() -> Observable<AuthModels.Empty.Response> {
        network.request(LogoutAPI())
            .compactMap { _ in return .init() }
            .asObservable()
    }
    
    func checkNickname(nickname: String) -> Observable<AuthModels.Empty.Response> {
        network.request(CheckNicknameAPI(nickname: nickname))
            .compactMap { _ in return .init() }
            .catch { [weak self] error in
                return .error(self?.judgeNicknameError(error) ?? .parsing)
            }
            .asObservable()
    }

    func deregister() -> Observable<AuthModels.Empty.Response> {
        network.request(DeregisterAPI(authorizationCode: ""))
            .compactMap { _ in return .init() }
            .asObservable()
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
    
    private func judgeNicknameError(_ error: Error) -> AuthError {
        guard let error = error as? NetworkError else { return .parsing }
        switch error {
        case .httpStatus(let status):
            if status == 409 { return .duplicatedNickname }
        default: break
        }
        return .parsing
    }

    // MARK: API

    private func createKakaoRegisterAPI(with request: AuthModels.SignUp.Request, fcmToken: String) -> KakaoRegisterAPI {
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
            accessToken: request.token,
            fcmToken: fcmToken
        )
    }

    private func createAppleRegisterAPI(with request: AuthModels.SignUp.Request, fcmToken: String, authorizationCode: String) -> AppleRegisterAPI {
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
            identityToken: request.token,
            fcmToken: fcmToken,
            authorizationCode: authorizationCode
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
                    bank: dto.account?.bank ?? ErrorText.DeRegister.bank,
                    accountHolderName: dto.account?.holder ?? ErrorText.DeRegister.bankHolder,
                    accountNumber: dto.account?.number ?? ErrorText.DeRegister.bankNumber
                ),
                image: dto.imgUrl ?? ""
            )
        )
    }

    private func convertToToken(with dto: DTO.PostUser) -> AuthenticationToken {
        return .init(type: dto.tokenType, accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }



}
