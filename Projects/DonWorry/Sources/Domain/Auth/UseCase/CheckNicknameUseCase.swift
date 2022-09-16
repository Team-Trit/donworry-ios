//
//  CheckNicknameUseCase.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

import RxSwift

protocol CheckNicknameUseCase {
    func checkNickname(nickname: String) -> Observable<AuthModels.Empty.Response>
}

final class CheckNicknameUseCaseImpl: CheckNicknameUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository = AuthRepositoryImpl()) {
        self.authRepository = authRepository
    }
    func checkNickname(nickname: String) -> Observable<AuthModels.Empty.Response> {
        authRepository.checkNickname(nickname: nickname)
    }
}
