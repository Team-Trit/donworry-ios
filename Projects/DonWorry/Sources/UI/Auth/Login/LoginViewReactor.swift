//
//  LoginViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxFlow
import Models

enum LoginStep {
    case home
}

final class LoginViewReactor: Reactor, Stepper {
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
            // MARK: 카카오 로그인 연결을 끊기위한 임시 코드
//            self.steps.accept(DonworryStep.userInfoIsRequired)
            userService.unlinkKakao()
            return .empty()
            
        case .googleLoginButtonPressed:
            // MARK: 1차 배포에서는 구글 로그인 빼고 구현 예정
//            self.steps.accept(DonworryStep.userInfoIsRequired(accessToken: AccessToken))
            return .empty()
            
        case .kakaoLoginButtonPressed:
            userService.loginWithKakao()
                .subscribe(onNext: { [unowned self] oauthToken in
                    self.steps.accept(DonworryStep.userInfoIsRequired(accessToken: oauthToken.accessToken))
                }) { error in
                    print(error)
                }
                .disposed(by: disposeBag)
            return .empty()
            
        case .didTapTestUserButton:
            // TODO: 유저ID를 아실경우, signIn 메소드를 사용해주세요.
            return testUserService.signIn(1)
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
