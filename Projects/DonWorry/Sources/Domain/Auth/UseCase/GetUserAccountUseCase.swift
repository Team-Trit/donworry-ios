//
//  GetUserAccountUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models
import RxSwift

protocol GetUserAccountUseCase {
    func getUserAccount() -> Observable<User?>
}

final class GetUserAccountUseCaseImpl: GetUserAccountUseCase {
    private let userAccountRepository: UserAccountRepository

    init(
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl()
    ) {
        self.userAccountRepository = userAccountRepository
    }
    func getUserAccount() -> Observable<User?> {
        .just(userAccountRepository.fetchLocalUserAccount())
    }
}
