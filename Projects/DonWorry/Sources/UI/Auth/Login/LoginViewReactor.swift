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
    enum Action {
        case appleLoginButtonPressed
        case googleLoginButtonPressed
        case kakaoLoginButtonPressed
        case didTapTestUserButton
    }
    
    enum Mutation {
        case updateLoading(Bool)
        case appleLogin
        case googleLogin
        case kakaoLogin
        case routeTo(LoginStep)
    }
    
    struct State {
        var isLoading: Bool

        @Pulse var step: LoginStep?
    }
    
    let initialState: State
    
    init(testUserService: TestUserService = TestUserServiceImpl()) {
        self.testUserService = testUserService
        self.initialState = State(
            isLoading: false
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .appleLoginButtonPressed:
            // TODO: Social login
            return Observable.concat(
                [.just(Mutation.updateLoading(true)),
                 .just(Mutation.appleLogin),
                 .just(Mutation.updateLoading(false))
                ])
            
        case .googleLoginButtonPressed:
            // TODO: Social login
            return Observable.concat(
                [.just(Mutation.updateLoading(true)),
                 .just(Mutation.googleLogin),
                 .just(Mutation.updateLoading(false))
                ])
            
        case .kakaoLoginButtonPressed:
            // TODO: Social login
            return Observable.concat(
                [.just(Mutation.updateLoading(true)),
                 .just(Mutation.kakaoLogin),
                 .just(Mutation.updateLoading(false))
                ])
        case .didTapTestUserButton:
            // TODO: 유저ID를 아실경우, signIn 메소드를 사용해주세요.
            return testUserService.signIn(1)
                .map { _ in .routeTo(.home) }

        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .updateLoading(let isLoading):
            state.isLoading = isLoading
        case .appleLogin:
            state.step = .home
        case .googleLogin:
            self.steps.accept(DonworryStep.userInfoIsRequired)
        case .kakaoLogin:
            self.steps.accept(DonworryStep.userInfoIsRequired)
        case .routeTo(let step):
            state.step = step
        }
        
        return state
    }
}
