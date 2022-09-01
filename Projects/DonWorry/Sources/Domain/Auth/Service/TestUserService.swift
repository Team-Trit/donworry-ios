//
//  AuthUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models
import RxSwift

protocol TestUserService {
    // 유저ID를 모를 때, 방금 가입한 회원으로 로그인하는 API
    // 만일 가입을 안했다면, dummyUser1로 로그인됩니다.
    func signInWithoutUserID() -> Observable<User>
    // 특정 유저ID를 안다면 사용하는 로그인 API
    func signIn(_ userID: Int) -> Observable<User>
    // 테스트 유저 회원가입
    func signUp(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool) -> Observable<User>
}

final class TestUserServiceImpl: TestUserService {
    private let testUserRepository: TestUserRepository
    private let accessTokenRepository: AccessTokenRepository
    private let userAccountRepository: UserAccountRepository

    init(
        testUserRepository: TestUserRepository = TestUserRepositoryImpl(),
        accessTokenRepository: AccessTokenRepository = AccessTokenRepositoryImpl(),
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl()
    ) {
        self.testUserRepository = testUserRepository
        self.accessTokenRepository = accessTokenRepository
        self.userAccountRepository = userAccountRepository
    }

    func signInWithoutUserID() -> Observable<User> {
        guard let user = self.userAccountRepository.fetchLocalUserAccount() else {
            print("현재 로그인된 유저 : ", User.dummyUser1)
            return .just(.dummyUser1)
        }
        print("현재 로그인된 유저 : ", user)
        return .just(user)
    }

    func signIn(_ userID: Int) -> Observable<User> {
        testUserRepository.fetchTestUser(userID)
            .map { [weak self] (user, authentication) -> User in
                _ = self?.userAccountRepository.saveLocalUserAccount(user)
                _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
                return user
            }
    }

    func signUp(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool) -> Observable<User> {
        testUserRepository.postTestUser(provider: provider, nickname: nickname, email: email, bank: bank, bankNumber: bankNumber, bankHolder: bankHolder, isAgreeMarketing: isAgreeMarketing)
            .map { [weak self] (user, authentication) -> User in
                _ = self?.userAccountRepository.saveLocalUserAccount(user)
                _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
                return user
            }
    }
}
