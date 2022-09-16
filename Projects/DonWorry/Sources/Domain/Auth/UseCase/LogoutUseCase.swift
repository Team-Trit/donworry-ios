//
//  LogoutUseCase.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

import RxSwift

protocol LogoutUseCase {
    func logout() -> Observable<AuthModels.Empty.Response>
}

final class LogoutUseCaseImpl: LogoutUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository = AuthRepositoryImpl()) {
        self.authRepository = authRepository
    }
    
    func logout() -> Observable<AuthModels.Empty.Response> {
        authRepository.logout()
    }
}
