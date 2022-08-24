//
//  ConfirmTermViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/24.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxFlow

final class ConfirmTermViewReactor: Reactor, Stepper {
    let steps = PublishRelay<Step>()
    enum Action {
        case confirmButtonPressed
    }
    
    enum Mutation {
        case dismissConfirmTermSheet
    }
    
    struct State {
        
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .confirmButtonPressed:
            self.steps.accept(DonworryStep.confirmTermIsComplete)
            return .just(Mutation.dismissConfirmTermSheet)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .dismissConfirmTermSheet:
            break
        }
        
        return state
    }
}
