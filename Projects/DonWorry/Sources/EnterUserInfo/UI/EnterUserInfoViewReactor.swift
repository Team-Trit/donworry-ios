//
//  EnterUserInfoViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxFlow

final class EnterUserInfoViewReactor: Reactor, Stepper {
    let steps = PublishRelay<Step>()
    
    enum Action {
        case bankSelectButtonPressed
    }
    
    enum Mutation {
        case showBankSelectSheet
    }
    
    struct State {
        
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .bankSelectButtonPressed:
            self.steps.accept(DonworryStep.bankSelectIsRequired)
            return .just(Mutation.showBankSelectSheet)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .showBankSelectSheet:
            break
        }
        
        return state
    }
}
