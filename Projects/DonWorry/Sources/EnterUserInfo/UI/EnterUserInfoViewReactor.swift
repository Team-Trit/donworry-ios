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
        case nextButtonPressed
    }
    
    enum Mutation {
        case showBankSelectSheet
        case navigateToNextVC
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
            
        case .nextButtonPressed:
            self.steps.accept(DonworryStep.agreeTermIsRequired)
            return .just(Mutation.navigateToNextVC)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .showBankSelectSheet:
            break
            
        case .navigateToNextVC:
            break
        }
        
        return state
    }
}
