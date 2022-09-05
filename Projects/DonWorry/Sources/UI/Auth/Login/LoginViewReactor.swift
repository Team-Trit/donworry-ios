//
//  LoginViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

//import KakaoSDKAuth
//import KakaoSDKCommon
//import KakaoSDKUser
import ReactorKit
import RxCocoa
import RxFlow
//import RxKakaoSDKAuth
//import RxKakaoSDKCommon
//import RxKakaoSDKUser
import Models

enum LoginStep {
    case home
}

final class LoginViewReactor: Reactor, Stepper {
//    private let authViewModel = AuthViewModel.shared
//    private let authViewModel: AuthViewModel
    let steps = PublishRelay<Step>()
    private let testUserService: TestUserService
    private let userService: UserService
    private let disposeBag = DisposeBag()
    enum Action {
        case appleLoginButtonPressed
        case googleLoginButtonPressed
        case kakaoLoginButtonPressed
        case didTapTestUserButton
    }
    
    enum Mutation {
        case routeTo(LoginStep)
    }
    
    struct State {
        @Pulse var step: LoginStep?
    }
    
    let initialState: State
    
    init(
//        authViewModel: AuthViewModel = AuthViewModel.shared,
        testUserService: TestUserService = TestUserServiceImpl(),
        userService: UserService = UserServiceImpl()
    ) {
//        self.authViewModel = authViewModel
        self.testUserService = testUserService
        self.userService = userService
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .appleLoginButtonPressed:
//            self.steps.accept(DonworryStep.userInfoIsRequired)
            userService.unlink()
            userService.logout()
            return .empty()
            
        case .googleLoginButtonPressed:
            self.steps.accept(DonworryStep.userInfoIsRequired)
            return .empty()
            
        case .kakaoLoginButtonPressed:
            userService.loginWithKakao()
                .subscribe(onNext: { [unowned self] oauthToken in
                    // TODO: oauthToken driving하기
//                    authViewModel.setAccessToken(oauthToken.accessToken)
                    
                    self.steps.accept(DonworryStep.userInfoIsRequired)
                }) { error in
                    print(error)
                }
                .disposed(by: disposeBag)
            return .empty()
            
        case .didTapTestUserButton:
            // TODO: 유저ID를 아실경우, signIn 메소드를 사용해주세요.
            return testUserService.signInWithoutUserID()
                .map { _ in .routeTo(.home) }

        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .routeTo(let step):
            state.step = step
        }
        
        return state
    }
}
