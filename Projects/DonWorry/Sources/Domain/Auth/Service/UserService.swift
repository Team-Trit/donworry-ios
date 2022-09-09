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

protocol UserRepository {
    // 카카오 기반 회원가입 API 호출
    func postUser(provider: String,
                  nickname: String,
                  email: String,
                  bank: String,
                  bankNumber: String,
                  bankHolder: String,
                  isAgreeMarketing: Bool,
                  accessToken: String) -> Observable<(Models.User, AuthenticationToken)>
    
    // 유저 정보 수정 API 호출
    func patchUser(nickname: String?,
                   imgURL: String?,
                   bank: String?,
                   holder: String?,
                   accountNumber: String?,
                   isAgreeMarketing: Bool?) -> Observable<Models.User>
    
    
    func kakaoLogin() -> Observable<OAuthToken>
    func kakaoLogout()
    func kakaoUnlink()
}

protocol UserAccountRepository {
    func fetchLocalUserAccount() -> Models.User?                // 로컬 유저 정보 가져오기
    func saveLocalUserAccount(_ user: Models.User) -> Bool      // 로컬에 유저 저장하기
    func deleteLocalUserAccount() -> Bool                       // 로컬 유저 정보 삭제
}

protocol AccessTokenRepository {
    func fetchAccessToken() -> AccessToken?                     // 로컬 토큰 정보 가져오기
    func saveAccessToken(_ accessToken: AccessToken) -> Bool    // 로컬에 토큰 저장하기
    func deleteAccessToken() -> Bool                            // 로컬 토큰 정보 삭제
}

protocol UserService {
    func signUp(provider: String,
                nickname: String,
                email: String,
                bank: String,
                bankNumber: String,
                bankHolder: String,
                isAgreeMarketing: Bool,
                accessToken: String) -> Observable<Models.User>     // 카카오 기반 회원가입 유즈케이스
    
    /*
     유저 정보 수정 유즈케이스입니다.
     앱에서 수정 가능한 6개에 대하여 인자로 받을 수 있게 작성해 놓았습니다.
     수정하려는 값은 인자로 전달하고, 수정하지 않는 값들은 nil을 전달하면 됩니다.
     
     주의할 점으로는 일단 2022년 09월 09일 기준으로 유저 정보 수정이 닉네임, 프로필 사진, 계좌정보, 이용약관 이렇게 4개가 있어서
     이 4개에 대한 init 함수만 만들어 놓았습니다.
     추후에 업데이트 하는 값들이 많아지거나 변경된다면 init 함수를 추가로 만들어야 합니다. (Charlie에게 문의해주세요 ^^)
     */
    func updateUser(nickname: String?,
                    imgURL: String?,
                    bank: String?,
                    holder: String?,
                    accountNumber: String?,
                    isAgreeMarketing: Bool?) -> Observable<Models.User>     // 유저 정보 수정 유즈케이스
    
    func saveLocalUser(user: Models.User) -> Bool       // 로컬에 유저 정보 저장 유즈케이스
    func fetchLocalUser() -> Models.User?               // 로컬 유저 fetch 유즈케이스
    func fetchLocalToken() -> AccessToken?              // 로컬 토큰 fetch 유즈케이스
    func deleteLocalUser()                              // 로컬 유저, 토큰 삭제 유즈케이스
    
    func loginWithKakao() -> Observable<OAuthToken>
    func unlinkKakao()
}

final class UserServiceImpl: UserService {
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
    
    func signInWithoutUserID() -> Observable<Models.User> {
        guard let user = self.userAccountRepository.fetchLocalUserAccount() else { return .empty() }
        return .just(user)
    }
    
    func signUp(provider: String,
                nickname: String,
                email: String,
                bank: String,
                bankNumber: String,
                bankHolder: String,
                isAgreeMarketing: Bool,
                accessToken: String) -> Observable<Models.User> {
        userRepository.postUser(provider: provider,
                                nickname: nickname,
                                email: email,
                                bank: bank,
                                bankNumber: bankNumber,
                                bankHolder: bankHolder,
                                isAgreeMarketing: isAgreeMarketing,
                                accessToken: accessToken)
        .map { [weak self] (user, authentication) -> Models.User in
            _ = self?.userAccountRepository.saveLocalUserAccount(user)
            _ = self?.accessTokenRepository.saveAccessToken(authentication.accessToken)
            return user
        }
    }
    
    func updateUser(nickname: String?,
                    imgURL: String?,
                    bank: String?,
                    holder: String?,
                    accountNumber: String?,
                    isAgreeMarketing: Bool?) -> Observable<Models.User> {
        userRepository.patchUser(nickname: nickname,
                                        imgURL: imgURL,
                                        bank: bank,
                                        holder: holder,
                                        accountNumber: accountNumber,
                                        isAgreeMarketing: isAgreeMarketing)
        .map { [weak self] user -> Models.User in
            _ = self?.userAccountRepository.saveLocalUserAccount(user)
            return user
        }
    }
    
    func loginWithKakao() -> Observable<OAuthToken> {
        return userRepository.kakaoLogin()
    }
    
    func unlinkKakao() {
        userRepository.kakaoLogout()
        userRepository.kakaoUnlink()
    }
    
    func saveLocalUser(user: Models.User) -> Bool {
        return userAccountRepository.saveLocalUserAccount(user)
    }
    
    func fetchLocalToken() -> AccessToken? {
        return accessTokenRepository.fetchAccessToken()
    }
    
    func fetchLocalUser() -> Models.User? {
        return userAccountRepository.fetchLocalUserAccount()
    }
    
    func deleteLocalUser() {
        _ = userAccountRepository.deleteLocalUserAccount()
        _ = accessTokenRepository.deleteAccessToken()
    }
}

// MARK: - Convert Methods
extension UserService {
    private func convertToUser(id: Int,
                               nickname: String,
                               bankAccount: BankAccount,
                               image: String) -> Models.User {
        return Models.User(id: id, nickName: nickname, bankAccount: bankAccount, image: image)
    }
}
