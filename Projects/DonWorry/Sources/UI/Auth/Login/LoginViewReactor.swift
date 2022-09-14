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

enum LoginStep {
    typealias OAuthType = AuthModels.OAuthType
    case none
    case signup(String, OAuthType)
    case home
}

final class LoginViewReactor: Reactor {
    typealias Token = String
    // TODO: 삭제하기
    private let testUserService: TestUserService
    private let signInUseCase: SignInUseCase
    
    enum Action {
        case proceedWithAppleToken(identityToken: Token)
        case kakaoLoginButtonPressed
        case routeToHome
        case routeToSignUp(Token)
        case errorToast(String)
        // TODO: 삭제하기
        case didTapTestUserButton
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

        self.signInUseCase.completeKakaoLogin
            .subscribe(onNext: { [weak self] _ in
                self?.action.onNext(.routeToHome)
            }, onError: { [weak self] error in
                guard let error = error.toAuthError() else { return }
                switch error {
                case .nouser(let token):
                    self?.action.onNext(.routeToSignUp(token))
                default:
                    self?.action.onNext(.errorToast(error.message))
                }
            }).disposed(by: disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .proceedWithAppleToken(let identityToken):
            let signIn = requestAppleLogin(token: identityToken)
            return signIn
        case .kakaoLoginButtonPressed:
            return signInUseCase.kakaoLogin().map { _ in .nothing }
        case .routeToHome:
            return .just(.routeTo(.home))
        case .routeToSignUp(let token):
            return .just(.routeTo(.signup(token, .kakao)))
        case .errorToast(let message):
            return .just(.toast(message))
        case .didTapTestUserButton:
            // TODO: 유저ID를 아실경우, signIn 메소드를 사용해주세요.
            return testUserService.signIn(1)
                .map { _ in .routeTo(.home) }
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

    private func requestAppleLogin(token: String) -> Observable<Mutation> {
        signInUseCase.signInWithApple(request: .init(oauthType: .apple, token: token))
            .map { _ in Mutation.routeTo(.home) }
            .catch { error in
                guard let error = error.toAuthError() else { return .error(error) }
                switch error {
                case .nouser(let token):
                    return .just(.routeTo(.signup(token, .apple)))
                default:
                    return .just(.toast(error.message))
                }
            }
    }
}
