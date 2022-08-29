//
//  AuthUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/08/29.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift
import Models

protocol TestAuthRepository {
    func fetchTestUser(_ userID: Int) -> Observable<User>
}

protocol AuthRepository {
    func fetchTestUser(_ userID: Int) -> Observable<User>
}

protocol AuthUseCase {
    func fetchTestUser(_ userID: Int) -> Observable<User>
}

final class AuthUseCaseImpl: AuthUseCase {

    init(_ authRepository: AuthRepository = TestAuthRepositoryImpl()) {
        self.authRepository = authRepository
    }
    
    func fetchTestUser(_ userID: Int) -> Observable<User> {
        authRepository.fetchTestUser(userID)
    }

    private let authRepository: AuthRepository
}
