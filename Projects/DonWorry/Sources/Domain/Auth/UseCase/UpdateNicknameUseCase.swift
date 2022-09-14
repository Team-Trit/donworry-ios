//
//  UpdateNicknameUseCase.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import RxSwift
import Models

protocol UpdateNicknameUseCase {
    func updateNickname(nickname: String) -> Observable<Models.User>
}

final class UpdateNicknameUseCaseImpl: UpdateNicknameUseCase {
    private let userRepository: UserRepository
    private let userAccountRepository: UserAccountRepository
    
    init(
        userRepository: UserRepository = UserRepositoryImpl(),
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl()
    ) {
        self.userRepository = userRepository
        self.userAccountRepository = userAccountRepository
    }
    
    func updateNickname(nickname: String) -> Observable<User> {
        userRepository.patchUser(nickname: nickname, imgURL: nil, bank: nil, holder: nil, accountNumber: nil, isAgreeMarketing: nil)
            .map { [weak self] user -> Models.User in
                _ = self?.userAccountRepository.saveLocalUserAccount(user)
                return user
            }
    }
}
