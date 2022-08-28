//
//  EnterUserInfoViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import DesignSystem
import ReactorKit
import RxCocoa
import RxFlow

final class EnterUserInfoViewReactor: Reactor, Stepper {
    let steps = PublishRelay<Step>()
    
    enum Action {
        case textFieldUpdated(type: LimitTextFieldType, length: Int)
        case bankSelectButtonPressed
        case nextButtonPressed
    }
    
    enum Mutation {
        case updateValidation(_ flag: Bool, _ index: Int)
        case showBankSelectSheet
        case navigateToNextVC
    }
    
    struct State {
        var isNextButtonAvailable: [Bool]
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(
            isNextButtonAvailable: [false, false, false]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .textFieldUpdated(type, length):
            let flag = length == 0 ? false : true
            var index = 0
            switch type {
            case .nickName:
                index = 0
            case .holder:
                index = 1
            case .account:
                index = 2
            default:
                break
            }
            return .just(Mutation.updateValidation(flag, index))
            
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
        case let .updateValidation(flag, index):
            state.isNextButtonAvailable[index] = flag
            
        case .showBankSelectSheet:
            break
            
        case .navigateToNextVC:
            break
        }
        
        return state
    }
}
