//
//  UpdateAccountUseCase.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import RxSwift
import Models

protocol UpdateAccountUseCase {
    func updateAccount(bank: String, holder: String, accountNumber: String) -> Observable<Models.User>
}

final class UpdateAccountUseCaseImpl: UpdateAccountUseCase {
    private let userRepository: UserRepository
    private let userAccountRepository: UserAccountRepository
    
    init(
        userRepository: UserRepository = UserRepositoryImpl(),
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl()
    ) {
        self.userRepository = userRepository
        self.userAccountRepository = userAccountRepository
    }
    
    func updateAccount(bank: String, holder: String, accountNumber: String) -> Observable<Models.User> {
        userRepository.patchUser(nickname: nil, imgURL: nil, bank: bank, holder: holder, accountNumber: accountNumber, isAgreeMarketing: nil)
            .map { [weak self] user -> Models.User in
                _ = self?.userAccountRepository.saveLocalUserAccount(user)
                return user
            }
    }
}
