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
    func postTestUser(_ userID: Int)
}

final class AuthServiceImpl: AuthService {

    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    func fetchTestUser(_ userID: Int) -> Observable<User> {
        let api = GetTestUserAPI(userID: userID)
        return network.request(api)
            .compactMap { [weak self] in
                self?.convertToUser($0)
            }.asObservable()
    }

    func postTestUser(_ userID: Int) {
        
    }

    private func convertToUser(_ dto: DTO.TestUser) -> User {
        return .init(id: dto.id, nickName: dto.nickname, bankAccount: .init(bank: dto.account.bank, accountHolderName: dto.account.holder, accountNumber: dto.account.number), image: "")
    }

    private let network: NetworkServable
}
