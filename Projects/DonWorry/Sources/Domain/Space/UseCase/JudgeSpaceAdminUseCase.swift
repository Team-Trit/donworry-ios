//
//  JudgeSpaceAdminUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol JudgeSpaceAdminUseCase {
    func judgeUserIsSpaceAdmin(spaceAdminID: Int) -> Observable<Bool>
}

final class JudgeSpaceAdminUseCaseImpl: JudgeSpaceAdminUseCase {
    private let userAccountRepository: UserAccountRepository

    init(
        _ userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl())
    {
        self.userAccountRepository = userAccountRepository
    }

    // 현재 정산방의 방장이 유저인지 확인해줍니다.
    func judgeUserIsSpaceAdmin(spaceAdminID: Int) -> Observable<Bool> {
        guard let userAccount = userAccountRepository.fetchLocalUserAccount() else {
            return .just(false)
        }
        return .just(userAccount.id == spaceAdminID)
    }
}
