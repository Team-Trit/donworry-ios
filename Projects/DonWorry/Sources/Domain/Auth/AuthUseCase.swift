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

protocol AuthRepository {
    func fetchTestUser(_ userID: Int) -> Observable<(User, AuthenticationToken)>
    func postTestUser(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool) -> Observable<(User, AuthenticationToken)>
}

protocol AuthUseCase {
    func fetchTestUser(_ userID: Int) -> Observable<User>
    func postTestUser(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool) -> Observable<User>
}

final class AuthUseCaseImpl: AuthUseCase {

    private let authenticationOb: PublishSubject<AuthenticationToken>
    private let disposeBag: DisposeBag
    init(
        authRepository: AuthRepository = AuthRepositoryImpl(),
        localStorage: LocalStorage = UserDefaults.standard
    ) {
        self.authenticationOb = .init()
        self.disposeBag = .init()
        self.authRepository = authRepository
        self.localStorage = localStorage

        self.authenticationOb.subscribe(onNext: { [weak self] authentication in
            self?.tokenProcess(authentication)
        }).disposed(by: disposeBag)
    }
    
    func fetchTestUser(_ userID: Int) -> Observable<User> {
        authRepository.fetchTestUser(userID)
            .map { [weak self] (user, authentication) -> User in
                self?.authenticationOb.onNext(authentication)
                return user
            }
    }

    func postTestUser(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool) -> Observable<User> {
        authRepository.postTestUser(provider: provider, nickname: nickname, email: email, bank: bank, bankNumber: bankNumber, bankHolder: bankHolder, isAgreeMarketing: isAgreeMarketing)
            .map { [weak self] (user, authentication) -> User in
                self?.authenticationOb.onNext(authentication)
                return user
            }
    }

    private func tokenProcess(_ authentication: AuthenticationToken) {
        _ = localStorage.write(authentication.accessToken, key: .token)
        _ = localStorage.writeCodable(authentication, key: .authentication)
        print("저장된 토큰 : ", localStorage.readToken() ?? "")
    }

    private let authRepository: AuthRepository
    private let localStorage: LocalStorage
}
