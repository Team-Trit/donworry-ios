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

final class AuthRepositoryImpl: AuthRepository {

    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    func fetchTestUser(_ userID: Int) -> Observable<(User, AuthenticationToken)> {
        network.request(GetTestUserAPI(userID: userID))
            .compactMap { [weak self] in
                (self?.convertToUser($0), self?.convertToToken($0)) as? (User, AuthenticationToken)
            }.asObservable()
    }

    func postTestUser(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool) -> Observable<(User, AuthenticationToken)> {
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
            .compactMap { [weak self] in
                (self?.convertToUser($0), self?.convertToToken($0)) as? (User, AuthenticationToken)
            }.asObservable()
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

    private func convertToToken(_ dto: DTO.TestUser) -> AuthenticationToken {
        return .init(type: dto.tokenType, accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }

    private func convertToUser(_ dto: DTO.TestUser) -> User {
        return .init(id: dto.id, nickName: dto.nickname, bankAccount: .init(bank: dto.account.bank, accountHolderName: dto.account.holder, accountNumber: dto.account.number), image: "")
    }

    private let network: NetworkServable
}
