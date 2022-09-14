//
//  UserService.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Models
import RxSwift
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser

protocol UserService {

    /*
     유저 정보 수정 유즈케이스입니다.
     앱에서 수정 가능한 6개에 대하여 인자로 받을 수 있게 작성해 놓았습니다.
     수정하려는 값은 인자로 전달하고, 수정하지 않는 값들은 nil을 전달하면 됩니다.
     
     주의할 점으로는 일단 2022년 09월 09일 기준으로 유저 정보 수정이 닉네임, 프로필 사진, 계좌정보, 이용약관 이렇게 4개가 있어서
     이 4개에 대한 init 함수만 만들어 놓았습니다.
     추후에 업데이트 하는 값들이 많아지거나 변경된다면 init 함수를 추가로 만들어야 합니다. (Charlie에게 문의해주세요 ^^)
     */
    func updateUser(
        nickname: String?,
        imgURL: String?,
        bank: String?,
        holder: String?,
        accountNumber: String?,
        isAgreeMarketing: Bool?
    ) -> Observable<Models.User>     // 유저 정보 수정 유즈케이스

}

final class UserServiceImpl: UserService {
    enum UserError: Error {
        case undefined
        case noUserInServer
    }
    private let userRepository: UserRepository
    private let userAccountRepository: UserAccountRepository
    private let accessTokenRepository: AccessTokenRepository
    
    init(
        userRepository: UserRepository = UserRepositoryImpl(),
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl(),
        accessTokenRepository: AccessTokenRepository = AccessTokenRepositoryImpl()
    ) {
        self.userRepository = userRepository
        self.userAccountRepository = userAccountRepository
        self.accessTokenRepository = accessTokenRepository
    }

    func updateUser(
        nickname: String?,
        imgURL: String?,
        bank: String?,
        holder: String?,
        accountNumber: String?,
        isAgreeMarketing: Bool?
    ) -> Observable<Models.User> {
        userRepository.patchUser(
            nickname: nickname,
            imgURL: imgURL,
            bank: bank,
            holder: holder,
            accountNumber: accountNumber,
            isAgreeMarketing: isAgreeMarketing
        ).map { [weak self] user -> Models.User in
            _ = self?.userAccountRepository.saveLocalUserAccount(user)
            return user
        }
    }
}
