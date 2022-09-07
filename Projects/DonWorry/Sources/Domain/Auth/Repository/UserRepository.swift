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
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser
import RxSwift

protocol UserRepository {
    func postUser(provider: String,
                  nickname: String,
                  email: String,
                  bank: String,
                  bankNumber: String,
                  bankHolder: String,
                  isAgreeMarketing: Bool,
                  accessToken: String) -> Observable<(Models.User, AuthenticationToken)>
    
    func kakaoLogin() -> Observable<OAuthToken>
    func kakaoLogout()
    func kakaoUnlink()
}

final class UserRepositoryImpl: UserRepository {
    private let network: NetworkServable
    private let disposeBag = DisposeBag()
    
    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }
    
    func postUser(provider: String,
                  nickname: String,
                  email: String,
                  bank: String,
                  bankNumber: String,
                  bankHolder: String,
                  isAgreeMarketing: Bool,
                  accessToken: String) -> Observable<(Models.User, AuthenticationToken)> {
        let api = PostUserAPI(request: createUserRequest(
            provider: provider,
            nickname: nickname,
            email: email,
            bank: bank,
            bankNumber: bankNumber,
            bankHolder: bankHolder,
            isAgreeMarketing: isAgreeMarketing
        ),accessToken: accessToken)

        return network.request(api)
            .compactMap { [ weak self] in
                (self?.convertToUser($0), self?.convertToToken($0)) as? (Models.User, AuthenticationToken)
            }.asObservable()
    }
    
    func kakaoLogin() -> Observable<OAuthToken> {
        return Observable.create { result in
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe(onNext: { oauthToken in
                        result.onNext(oauthToken)
                    }, onError: { error in
                        print(error)
                    })
                    .disposed(by: self.disposeBag)
            } else {
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe(onNext: { oauthToken in
                        result.onNext(oauthToken)
                    }, onError: { error in
                        print(error)
                    })
                    .disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
    }
    
    // MARK: - 카카오 로그인 테스트를 위한 임시 메소드 (연결 끊기)
    func kakaoLogout() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted:{
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    func kakaoUnlink() {
        UserApi.shared.rx.unlink()
            .subscribe(onCompleted:{
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
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
}

// MARK: - Helper
extension UserRepository {
    fileprivate func convertToToken(_ dto: DTO.User) -> AuthenticationToken {
        return .init(type: dto.tokenType, accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }
    
    fileprivate func convertToUser(_ dto: DTO.User) -> Models.User {
        return .init(id: dto.id, nickName: dto.nickname, bankAccount: .init(bank: dto.account.bank, accountHolderName: dto.account.holder, accountNumber: dto.account.number), image: "default_profile_image")
    }
}
