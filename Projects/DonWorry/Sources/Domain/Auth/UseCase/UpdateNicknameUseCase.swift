//
//  UpdateNicknameUseCase.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

protocol UpdateNicknameUseCase {
    
}

final class UpdateNicknameUseCaseImpl: UpdateNicknameUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository = UserRepositoryImpl()) {
        self.userRepository = userRepository
    }
}
