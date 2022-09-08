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
    func signUp(provider: String,
                nickname: String,
                email: String,
                bank: String,
                bankNumber: String,
                bankHolder: String,
                isAgreeMarketing: Bool,
                accessToken: String) -> Observable<Models.User>
    func updateUser(nickname: String?, imgURL: String?, bank: String?, holder: String?, accountNumber: String?, isAgreeMarketing: Bool?) -> Observable<Models.User>
    func loginWithKakao() -> Observable<OAuthToken>
    
    func saveLocalUser(user: Models.User) -> Bool
    func fetchLocalToken() -> AccessToken?
    func fetchLocalUser() -> Models.User?
    func deleteLocalUser()
    func unlinkKakao()
}

final class UserServiceImpl: UserService {
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
    
    func signUp(provider: String,
                nickname: String,
                email: String,
                bank: String,
                bankNumber: String,
                bankHolder: String,
                isAgreeMarketing: Bool,
                accessToken: String) -> Observable<Models.User> {
        userRepository.postUser(provider: provider,
                                nickname: nickname,
                                email: email,
                                bank: bank,
                                bankNumber: bankNumber,
                                bankHolder: bankHolder,
                                isAgreeMarketing: isAgreeMarketing,
                                accessToken: accessToken)
        .map { [weak self] (user, authentication) -> Models.User in
            _ = self?.userAccountRepository.saveLocalUserAccount(user)
            _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
            return user
        }
    }
    
    func updateUser(nickname: String?,
                    imgURL: String?,
                    bank: String?,
                    holder: String?,
                    accountNumber: String?,
                    isAgreeMarketing: Bool?) -> Observable<Models.User> {
        userRepository.patchUser(nickname: nickname,
                                        imgURL: imgURL,
                                        bank: bank,
                                        holder: holder,
                                        accountNumber: accountNumber,
                                        isAgreeMarketing: isAgreeMarketing)
        .map { [weak self] user -> Models.User in
            _ = self?.userAccountRepository.saveLocalUserAccount(user)
            return user
        }
    }
    
    func loginWithKakao() -> Observable<OAuthToken> {
        return userRepository.kakaoLogin()
    }
    
    func unlinkKakao() {
        userRepository.kakaoLogout()
        userRepository.kakaoUnlink()
    }
    
    func saveLocalUser(user: Models.User) -> Bool {
        return userAccountRepository.saveLocalUserAccount(user)
    }
    
    func fetchLocalToken() -> AccessToken? {
        return accessTokenRepository.fetchAccessToken()
    }
    
    func fetchLocalUser() -> Models.User? {
        return userAccountRepository.fetchLocalUserAccount()
    }
    
    func deleteLocalUser() {
        _ = userAccountRepository.deleteLocalUserAccount()
        _ = accessTokenRepository.deleteAccessToken()
    }
}

// MARK: - Convert Methods
extension UserService {
    private func convertToUser(id: Int,
                               nickname: String,
                               bankAccount: BankAccount,
                               image: String) -> Models.User {
        return Models.User(id: id, nickName: nickname, bankAccount: bankAccount, image: image)
    }
}
