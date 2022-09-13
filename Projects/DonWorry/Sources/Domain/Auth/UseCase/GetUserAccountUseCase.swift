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
    func compareIsUser(id: Int) -> Observable<Void>
    func compareIsUserList(ids: [Int]) -> Observable<Void>
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

    func compareIsUser(id: Int) -> Observable<Void> {
        guard let userID = userAccountRepository.fetchLocalUserAccount()?.id else {
            return .error(UserError.isNotMe)
        }
        if userID != id {
            return .just(())
        }
        return .error(UserError.isNotMe)
    }

    func compareIsUserList(ids: [Int]) -> Observable<Void> {
        guard let userID = userAccountRepository.fetchLocalUserAccount()?.id else {
            return .error(UserError.isNotMe)
        }
        if ids.contains(userID) == false {
            return .just(())
        }
        return .error(UserError.isNotMe)
    }
}
