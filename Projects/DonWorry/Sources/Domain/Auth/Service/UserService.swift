//
//  UserService.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Models
import RxSwift
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser

protocol UserService {
    func signUp(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool, accessToken: String) -> Observable<Models.User>
    func loginWithKakao() -> Observable<OAuthToken>
    
    func fetchLocalToken() -> AccessToken?
    func deleteLocalUser()
    
    func logout()
    func unlink()
}

final class UserServiceImpl: UserService {
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepository
    private let userAccountRepository: UserAccountRepository
    private let accessTokenRepository: AccessTokenRepository
    
    init(
        userRepository: UserRepository = UserRepositoryImpl(),
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl(),
        accessTokenRepository: AccessTokenRepository = AccessTokenRepositoryImpl()
    ) {
        self.userRepository = userRepository
        self.userAccountRepository = userAccountRepository
        self.accessTokenRepository = accessTokenRepository
    }
    
    func signInWithoutUserID() -> Observable<Models.User> {
        guard let user = self.userAccountRepository.fetchLocalUserAccount() else { return .empty() }
        return .just(user)
    }
    
    func signUp(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool, accessToken: String) -> Observable<Models.User> {
        userRepository.postUser(provider: provider, nickname: nickname, email: email, bank: bank, bankNumber: bankNumber, bankHolder: bankHolder, isAgreeMarketing: isAgreeMarketing, accessToken: accessToken)
            .map { [weak self] (user, authentication) -> Models.User in
                _ = self?.userAccountRepository.saveLocalUserAccount(user)
                _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
                
                return user
            }
    }
    
    func loginWithKakao() -> Observable<OAuthToken> {
        return Observable.create { result in
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe(onNext: { oauthToken in
                        result.onNext(oauthToken)
                    }, onError: { error in
                        print(error)
                    })
                    .disposed(by: self.disposeBag)
            } else {
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe(onNext: { oauthToken in
                        result.onNext(oauthToken)
                    }, onError: { error in
                        print(error)
                    })
                    .disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
    }
    
    func fetchLocalToken() -> AccessToken? {
        return accessTokenRepository.fetchAccessToken()
    }
    
    func deleteLocalUser() {
        userAccountRepository.deleteLocalUserAccount()
        accessTokenRepository.deleteAccessToken()
        print("🔥지워")
    }
    
    private func convertToUser(id: Int, nickname: String, bankAccount: BankAccount, image: String) -> Models.User {
        return Models.User(id: id, nickName: nickname, bankAccount: bankAccount, image: image)
        
    }
}

// MARK: - 테스트를 위한 임시 메소드
extension UserServiceImpl {
    func logout() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted:{
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    func unlink() {
        UserApi.shared.rx.unlink()
            .subscribe(onCompleted:{
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
