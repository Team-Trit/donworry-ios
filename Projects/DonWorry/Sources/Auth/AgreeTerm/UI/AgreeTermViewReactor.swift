//
//  AgreeTermViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/24.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxFlow

final class AgreeTermViewReactor: Reactor, Stepper {
    let steps = PublishRelay<Step>()
    private let termUseCase: TermUseCase
    
    enum Action {
        case doneButtonPressed
    }
    
    enum Mutation {
        case presentConfirmTermSheet
    }
    
    struct State {
        
    }
    
    let initialState: State
    
    init(_ termUseCase: TermUseCase = TermUseCaseImpl()) {
        self.initialState = State()
        self.termUseCase = termUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .doneButtonPressed:
            self.steps.accept(DonworryStep.confirmTermIsRequired)
            return .just(Mutation.presentConfirmTermSheet)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .presentConfirmTermSheet:
            break
        }
        
        return state
    }
}
