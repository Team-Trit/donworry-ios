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
    case none
    case enterUserInfo(provider: LoginProvider, token: String)
    case home
}

final class LoginViewReactor: Reactor {
    // TODO: 삭제하기
    private let testUserService: TestUserService
    private let userService: UserService
    private let disposeBag = DisposeBag()
    
    enum Action {
        case appleLoginButtonPressed
        //        case googleLoginButtonPressed
        case proceedWithAppleToken(identityToken: String)
        case kakaoLoginButtonPressed
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
            var nextMutation: Observable<Mutation> = .empty()
            userService.loginWithApple(identityToken: identityToken)
                .subscribe(onNext: { user in
                    print("✨애플 로그인 성공, 홈뷰로 이동")
                    nextMutation = .just(.routeTo(.home))
                }, onError: { error in
                    guard let error = error as? UserError else { return }
                    switch error {
                    case .notUserInServer:
                        print("🔥서버에 유저 없음 에러")
                        nextMutation = .just(.routeTo(.enterUserInfo(provider: .APPLE, token: identityToken)))
                        
                    default:
                        print("🔥다른 에러")
                        break
                    }
                })
                .disposed(by: disposeBag)
            return nextMutation
            
            /*
             case .googleLoginButtonPressed:
             // MARK: 1차 배포에서는 구글 로그인 빼고 구현 예정
             */
            
        case .kakaoLoginButtonPressed:
            var nextMutation: Observable<Mutation> = .empty()
            userService.kakaoLogin()
                .subscribe(onNext: { [weak self] oauthToken in
                    let accessToken = oauthToken.accessToken
                    print("✨카카오 로그인 실행")
                    print("🔥카카오 토큰 : \(accessToken)")
                    self?.userService.loginWithKakao(accessToken: accessToken)
                        .subscribe(onNext: { user in
                            print("✨카카오 로그인 성공, 홈뷰로 이동")
                            nextMutation = .just(.routeTo(.home))
                        }, onError: { error in
                            guard let error = error as? UserError else { return }
                            switch error {
                            case .notUserInServer:
                                print("🔥서버에 유저 없음 에러")
                                nextMutation = .just(.routeTo(.enterUserInfo(provider: .KAKAO, token: accessToken)))
                                
                            default:
                                print("🔥다른 에러")
                                break
                            }
                        })
                        .disposed(by: self!.disposeBag)
                })
                .disposed(by: disposeBag)
            return nextMutation
            
            // TODO: 삭제하기
        case .didTapTestUserButton:
            // TODO: 유저ID를 아실경우, signIn 메소드를 사용해주세요.
            return testUserService.signIn(1)
                .map { _ in .routeTo(.home) }
        }
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

// MARK: - Helper
extension LoginViewReactor {
    private func login(_ token: String, _ provider: LoginProvider) -> Observable<LoginViewReactor.Mutation> {
        switch provider {
        case .APPLE:
            return userService.loginWithApple(identityToken: token)
                .map { _ in
                    print("✨애플 로그인 됨")
                    return .routeTo(.home)
                }
                .catch { error in
                    guard let error = error as? UserError else { return .empty() }
                    switch error {
                    case .notUserInServer:
                        print("✨애플 로그인 안되고 회원가입 해야함")
                        return .just(.routeTo(.enterUserInfo(provider: .APPLE, token: token)))
                        
                    default:
                        print("✨다른 에러임")
                        
                        return .empty()
                    }
                }
            
            /*
             case .GOOGLE:
             */
            
        case .KAKAO:
            return userService.loginWithKakao(accessToken: token)
                .map { _ in
                    print("✨카카오 로그인 됨")
                    return .routeTo(.home)
                }
                .catch { error in
                    guard let error = error as? UserError else { return .empty()}
                    switch error {
                    case .notUserInServer:
                        print("✨카카오 로그인 안되고 회원가입 해야함")
                        return .just(.routeTo(.enterUserInfo(provider: .KAKAO, token: token)))
                        
                    default:
                        print("✨다른 에러임")
                        return .empty()
                    }
                }
            
        default:
            return .empty()
        }
    }
}
