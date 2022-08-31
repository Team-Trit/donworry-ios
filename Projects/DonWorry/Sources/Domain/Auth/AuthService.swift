//
//  AuthService.swift
//  DonWorry
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import DonWorryNetworking
import Models
import RxSwift

protocol AuthService {
    func fetchTestUser(_ userID: Int) -> Observable<User>
    func postTestUser(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool) -> Observable<User>
}

final class AuthServiceImpl: AuthService {

    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    func fetchTestUser(_ userID: Int) -> Observable<User> {
        network.request(GetTestUserAPI(userID: userID))
            .compactMap { [weak self] in self?.convertToUser($0) }.asObservable()
    }

    func postTestUser(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool) -> Observable<User> {
        let api = PostTestUserAPI(
            request: createTestUserRequest(
                provider: provider,
                nickname: nickname,
                email: email,
                bank: bank,
                bankNumber: bankNumber,
                bankHolder: bankHolder,
                isAgreeMarketing: isAgreeMarketing
            )
        )

        return network.request(api)
            .compactMap { [weak self] in self?.convertToUser($0) }.asObservable()
    }

    private func createTestUserRequest(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool) -> PostTestUserAPI.Request {
        return .init(
            provider: provider,
            nickname: nickname,
            email: email,
            bank: bank,
            bankNumber: bankNumber,
            bankHolder: bankHolder,
            isAgreeMarketing: isAgreeMarketing
        )

    }

    private func convertToUser(_ dto: DTO.TestUser) -> User {
        return .init(id: dto.id, nickName: dto.nickname, bankAccount: .init(bank: dto.account.bank, accountHolderName: dto.account.holder, accountNumber: dto.account.number), image: "")
    }

    private let network: NetworkServable
}
