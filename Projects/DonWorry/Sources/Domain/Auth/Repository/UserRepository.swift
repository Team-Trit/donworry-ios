//
//  UserRepository.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import DonWorryNetworking
import Models
import RxSwift

protocol UserRepository {
    func postUser(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool, accessToken: String) -> Observable<(User, AuthenticationToken)>
}

final class UserRepositoryImpl: UserRepository {
    private let network: NetworkServable
    
    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }
    
    func postUser(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool, accessToken: String) -> Observable<(User, AuthenticationToken)> {
        let api = PostUserAPI(request: createUserRequest(
            provider: provider,
            nickname: nickname,
            email: email,
            bank: bank,
            bankNumber: bankNumber,
            bankHolder: bankHolder,
            isAgreeMarketing: isAgreeMarketing
        ),accessToken: accessToken)
        
//        print("🔥🔥🔥🔥🔥🔥🔥")
//        print("provider: \(provider) \n nickname: \(nickname) \n email : \(email) \n bank : \(bank) \n bankNumber : \(bankNumber) \n bankHolder: \(bankHolder) \n isAgreeMarketing: \(isAgreeMarketing) \n accessToken : \(accessToken)")
        
        return network.request(api)
            .compactMap { [ weak self] in
                (self?.convertToUser($0), self?.convertToToken($0)) as? (User, AuthenticationToken)
            }.asObservable()
    }
    
    private func createUserRequest(provider: String, nickname: String, email: String, bank: String, bankNumber: String, bankHolder: String, isAgreeMarketing: Bool) -> PostUserAPI.Request {
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
    
    private func convertToToken(_ dto: DTO.User) -> AuthenticationToken {
        return .init(type: dto.tokenType, accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }
    
    private func convertToUser(_ dto: DTO.User) -> User {
        return .init(id: dto.id, nickName: dto.nickname, bankAccount: .init(bank: dto.account.bank, accountHolderName: dto.account.holder, accountNumber: dto.account.number), image: "")
    }
}


