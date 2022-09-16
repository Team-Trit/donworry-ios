//
//  UserRepository.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import DonWorryNetworking
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Models
import RxSwift
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser


protocol UserRepository {

    // 유저 정보 수정 API 호출
    func patchUser(nickname: String?,
                   imgURL: String?,
                   bank: String?,
                   holder: String?,
                   accountNumber: String?,
                   isAgreeMarketing: Bool?) -> Observable<Models.User>
}

final class UserRepositoryImpl: UserRepository {
    private let network: NetworkServable
    private let disposeBag = DisposeBag()
    
    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    // 유저 정보 수정 API 호출
    func patchUser(nickname: String?,
                   imgURL: String?,
                   bank: String?,
                   holder: String?,
                   accountNumber: String?,
                   isAgreeMarketing: Bool?) -> Observable<Models.User> {
        let api = PatchUserAPI(
            request: patchUserRequest(
                nickname: nickname,
                imgURL: imgURL,
                bank: bank,
                holder: holder,
                accountNumber: accountNumber,
                isAgreeMarketing: isAgreeMarketing
            )
        )

//        PatchUserAPI(request: .init(bank: <#T##String#>, number: <#T##String#>, holder: <#T##String#>))
//        let api = PatchUserAPI(request: patchUserRequest(nickname: nickname,
//                                                         imgURL: imgURL,
//                                                         bank: bank,
//                                                         holder: holder,
//                                                         accountNumber: accountNumber,
//                                                         isAgreeMarketing: isAgreeMarketing))

        return network.request(api)
            .compactMap { [weak self] response in
                return self?.convertToUser(patchUserDTO: response) as? Models.User
            }.asObservable()
    }
}

// MARK: - Helper

extension UserRepository {
  
    
    fileprivate func convertToUser(userDTO dto: DTO.PostUser) -> Models.User {
        return .init(id: dto.id, nickName: dto.nickname, bankAccount: .init(bank: dto.account.bank, accountHolderName: dto.account.holder, accountNumber: dto.account.number), image: dto.imgUrl ?? "")
    }
    
    fileprivate func convertToUser(patchUserDTO dto: DTO.PatchUser) -> Models.User {
        let bankAccount = BankAccount(bank: dto.account.bank,
                                      accountHolderName: dto.account.holder,
                                      accountNumber: dto.account.number)
        return .init(id: dto.id, nickName: dto.nickname, bankAccount: bankAccount, image: dto.imgUrl ?? "")
    }

    fileprivate func patchUserRequest(
        nickname: String?,
        imgURL: String?,
        bank: String?,
        holder: String?,
        accountNumber: String?,
        isAgreeMarketing: Bool?
    ) -> PatchUserAPI.Request {
        if let nickname = nickname {
            return .init(nickname: nickname)
        } else if let imgURL = imgURL {
            return .init(imgUrl: imgURL)
        } else if let bank = bank, let accountNumber = accountNumber, let holder = holder {
            return .init(bank: bank, number: accountNumber, holder: holder)
        } else if let isAgreeMarketing = isAgreeMarketing {
            return .init(isAgreeMarketing: isAgreeMarketing)
        } else {
            return .init()
        }
    }
}
