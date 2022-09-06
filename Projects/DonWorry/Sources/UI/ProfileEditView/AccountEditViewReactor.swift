//
//  AccountEditViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/06.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit

enum AccountEditViewStep {
    case none
    case pop
    case presentSelectBankView
}

final class AccountEditViewReactor: Reactor {
//    var bank: String
//    var accountHolder: String
//    var accountNumber: String
    
    enum Action {
        case pressBackButton
        case pressDoneButton
        
        case selectBankButtonPressed
        case updateHolder(holder: String)
        case updateAccountNumber(number: String)
    }
    
    enum Mutation {
        case routeTo(step: AccountEditViewStep)
    }
    
    struct State {
        @Pulse var step: AccountEditViewStep
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(
            step: .none
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .pressBackButton:
            return .just(Mutation.routeTo(step: .pop))
            
        case .pressDoneButton:
            // TODO: User 수정 API Call
            return .just(Mutation.routeTo(step: .pop))
            
        case .selectBankButtonPressed:
            return .just(Mutation.routeTo(step: .presentSelectBankView))
            
        case .updateHolder(let holder):
            return .empty()
            
        case .updateAccountNumber(let number):
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}
