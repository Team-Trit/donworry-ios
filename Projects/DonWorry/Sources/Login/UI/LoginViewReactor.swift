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

final class LoginViewReactor: Reactor, Stepper {
    let steps = PublishRelay<Step>()
    
    //    let appServices: AppServices
    enum Action {
        case appleLoginButtonPressed
        case googleLoginButtonPressed
        case kakaoLoginButtonPressed
    }
    
    enum Mutation {
        case updateLoading(Bool)
        case appleLogin
        case googleLogin
        case kakaoLogin
    }
    
    struct State {
        var isLoading: Bool = false
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .appleLoginButtonPressed:
            print("apple")
            // TODO: Social login
            return Observable.concat(
                [.just(Mutation.updateLoading(true)),
                 .just(Mutation.appleLogin),
                 .just(Mutation.updateLoading(false))
                ])
            
        case .googleLoginButtonPressed:
            print("google")
            // TODO: Social login
            return Observable.concat(
                [.just(Mutation.updateLoading(true)),
                 .just(Mutation.googleLogin),
                 .just(Mutation.updateLoading(false))
                ])
            
        case .kakaoLoginButtonPressed:
            print("kakao")
            // TODO: Social login
            return Observable.concat(
                [.just(Mutation.updateLoading(true)),
                 .just(Mutation.kakaoLogin),
                 .just(Mutation.updateLoading(false))
                ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .updateLoading(let isLoading):
            state.isLoading = isLoading
            
        case .appleLogin:
            self.steps.accept(DonworryStep.userInfoIsRequired)
        case .googleLogin:
            self.steps.accept(DonworryStep.userInfoIsRequired)
        case .kakaoLogin:
            self.steps.accept(DonworryStep.userInfoIsRequired)
        }
        
        return state
    }
}
