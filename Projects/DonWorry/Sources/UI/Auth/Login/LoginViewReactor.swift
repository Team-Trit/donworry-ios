//
//  LoginViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Models
import ReactorKit

enum LoginStep {
    // TODO: 삭제하기
    case home
    
    case none
    case enterUserInfo(provider: LoginProvider, token: String)
}

final class LoginViewReactor: Reactor {
    // TODO: 삭제하기
    private let testUserService: TestUserService
    private let userService: UserService
    
    enum Action {
        case appleLoginButtonPressed
//        case googleLoginButtonPressed
        case proceedWithAppleToken(identityToken: String)
        case kakaoLoginButtonPressed
        case login(String, LoginProvider)
        // TODO: 삭제하기
        case didTapTestUserButton
    }
    
    enum Mutation {
        case login
        case loginError
        case performAppleLogin
        case routeTo(LoginStep)
    }
    
    struct State {
        @Pulse var appleLoginTrigger: Void?
        @Pulse var step: LoginStep?
    }
    
    let initialState: State
    
    init(
        testUserService: TestUserService = TestUserServiceImpl(),
        userService: UserService = UserServiceImpl()
    ) {
        self.testUserService = testUserService
        self.userService = userService
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .appleLoginButtonPressed:
            return .just(Mutation.performAppleLogin)
            
        case .proceedWithAppleToken(let identityToken):
            return .just(.routeTo(.enterUserInfo(provider: .APPLE, token: identityToken)))
            
        /*
        case .googleLoginButtonPressed:
            // MARK: 1차 배포에서는 구글 로그인 빼고 구현 예정
            return .empty()
        */
            
        case .kakaoLoginButtonPressed:
            return userService.kakaoLogin()
                .map { oauthToken in
                    self.action.onNext(.login(oauthToken.accessToken, .KAKAO))
                    return .login
//                    return .routeTo(.enterUserInfo(provider: .KAKAO, token: oauthToken.accessToken))
                }
            
        case let .login(token, provider):
            switch provider {
            case .APPLE:
//                userService.login
                break
                
//            case .GOOGLE:
                
                
            case .KAKAO:
                let loginWithKakao = loginWithKakao()
                userService.loginWithKakao(accessToken: token)
                    .catch { error in
                        // 401에러이면 회원가입으로
                        return .just()
                    }
            default:
                break
            }
            
            // TODO: 삭제하기
        case .didTapTestUserButton:
            // TODO: 유저ID를 아실경우, signIn 메소드를 사용해주세요.
            return testUserService.signIn(1)
                .map { _ in .routeTo(.home) }
        }
    }
    
    func loginWithKakao() {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .login:
            break
            
        case .loginError:
            break
            
        case .performAppleLogin:
            newState.appleLoginTrigger = ()
            
        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}
