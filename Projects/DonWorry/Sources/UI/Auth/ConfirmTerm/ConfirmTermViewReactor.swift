//
//  ConfirmTermViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/24.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit
import RxCocoa

final class ConfirmTermViewReactor: Reactor {
    let checkedTerms: [String]
    private var user: SignUpUserModel
    private let userService: UserService
    
    enum Action {
        case confirmButtonPressed
    }
    
    enum Mutation {
        case routeTo(step: DonworryStep)
    }
    
    struct State {
        @Pulse var step: DonworryStep?
    }
    
    let initialState: State
    
    init(checkedTerms: [String], newUser: SignUpUserModel, userService: UserService) {
        self.checkedTerms = checkedTerms
        self.user = newUser
        self.userService = userService
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .confirmButtonPressed:
            
            return userService.signUp(provider: user.provider,
                                      nickname: user.nickname,
                                      email: user.email,
                                      bank: user.bank,
                                      bankNumber: user.bankNumber,
                                      bankHolder: user.bankHolder,
                                      isAgreeMarketing: user.isAgreeMarketing,
                                      accessToken: user.accessToken)
//            .map { _ in Mutation.signUpComplete}
            .map { _ in Mutation.routeTo(step: .homeIsRequired)}
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .routeTo(let step):
            newState.step = step
//        case .signUpComplete:
//            self.steps.accept(DonworryStep.homeIsRequired)
        }
        
        return newState
    }
}
