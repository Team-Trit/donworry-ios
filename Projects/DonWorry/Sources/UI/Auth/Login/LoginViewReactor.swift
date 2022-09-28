//
//  LoginViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Models
import ReactorKit
import RxSwift
import Foundation

enum LoginStep {
    typealias OAuthType = AuthModels.OAuthType
    case none
    case signup(String, String, OAuthType)
    case home
}

final class LoginViewReactor: Reactor {
    typealias Token = String
    // TODO: 삭제하기
    private let testUserService: TestUserService
    private let signInUseCase: SignInUseCase
    
    enum Action {
        case proceedWithAppleToken(identityToken: Token, authorizationCode: Token)
        case kakaoLoginButtonPressed
        case routeToHome
        case errorToast(String)
    }
    
    enum Mutation {
        case routeTo(LoginStep)
        case toast(String)
        case nothing
    }
    
    struct State {
        @Pulse var appleLoginTrigger: Void?
        @Pulse var step: LoginStep?
        @Pulse var toast: String?
    }
    
    let initialState: State
    var disposeBag: DisposeBag
    
    init(
        testUserService: TestUserService = TestUserServiceImpl(),
        signInUseCase: SignInUseCase = SignInUseCaseImpl()
    ) {
        self.testUserService = testUserService
        self.signInUseCase = signInUseCase
        self.initialState = State()
        self.disposeBag = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .proceedWithAppleToken(let identityToken, let authorizationCode):
            let signIn = requestAppleLogin(token: identityToken, authorizationCode: authorizationCode)
            return signIn
        case .kakaoLoginButtonPressed:
            print("카카오 버튼 눌림")
            return requestKakaoLogin()
        case .routeToHome:
            return .just(.routeTo(.home))
        case .errorToast(let message):
            return .just(.toast(message))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .routeTo(let step):
            newState.step = step
        case .toast(let message):
            newState.toast = message
        case .nothing:
            break
        }
        return newState
    }

    private func requestAppleLogin(token: String, authorizationCode: String) -> Observable<Mutation> {
        signInUseCase.signInWithApple(request: .init(oauthType: .apple, token: token, deviceToken: ""), authorizationCode: authorizationCode)
            .map { _ in Mutation.routeTo(.home) }
            .catch { error in
                guard let error = error.toAuthError() else { return .error(error) }
                switch error {
                case .nouser(let token):
                    return .just(.routeTo(.signup(token, authorizationCode, .apple)))
                case .appleLogin:
                    return .just(.toast(error.message))
                default:
                    return .just(.toast(error.message))
                }
            }
    }

    private func requestKakaoLogin() -> Observable<Mutation> {
        signInUseCase.kakaoLogin()
            .flatMap { token in
                return self.signInUseCase.signInWithKakao(request: .init(oauthType: .kakao, token: token.token, deviceToken: ""))
            }.map { _ in
                return .routeTo(.home)}
            .catch { error in
                guard let error = error.toAuthError() else { return .error(error) }
                switch error {
                case .nouser(let token):
                    return .just(.routeTo(.signup(token, "", .kakao)))
                case .kakaoLogin:
                    return .just(.toast(error.message))
                default:
                    return .just(.toast(error.message))
                }
            }
    }
}
