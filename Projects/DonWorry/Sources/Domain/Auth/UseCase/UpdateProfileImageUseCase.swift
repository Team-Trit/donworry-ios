//
//  UpdateProfileImageUseCase.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import RxSwift
import Models

protocol UpdateProfileImageUseCase {
    func updateProfileImage(imgURL: String) -> Observable<Models.User>
}

final class UpdateProfileImageUseCaseImpl: UpdateProfileImageUseCase {
    private let userRepository: UserRepository
    private let userAccountRepository: UserAccountRepository
    
    init(
        userRepository: UserRepository = UserRepositoryImpl(),
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl()
    ) {
        self.userRepository = userRepository
        self.userAccountRepository = userAccountRepository
    }
    
    func updateProfileImage(imgURL: String) -> Observable<Models.User> {
        userRepository.patchUser(nickname: nil, imgURL: imgURL, bank: nil, holder: nil, accountNumber: nil, isAgreeMarketing: nil)
            .map { [weak self] user -> Models.User in
                _ = self?.userAccountRepository.saveLocalUserAccount(user)
                return user
            }
    }
}