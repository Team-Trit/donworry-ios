//
//  EnterUserInfoViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Models
import ReactorKit

enum EnterUserInfoStep {
    case none
    case pop
    case selectBank(delegate: EnterUserInfoViewDelegate)
    case agreeTerm(newUser: SignUpUserModel)
}

final class EnterUserInfoViewReactor: Reactor {
    enum TextFieldType {
        case nickname
        case accountHolder
        case accountNumber
    }
    private var user = SignUpUserModel(provider: .none,
                                     nickname: "",
                                     email: "",
                                     bank: "",
                                     bankNumber: "",
                                     bankHolder: "",
                                     isAgreeMarketing: false,
                                     token: "")
    
    enum Action {
        case backButtonPressed
        case nicknameFieldUpdated(nickname: String)
        case accountHolderFieldUpdated(holder: String)
        case accountNumberFieldUpdated(number: String)
        case bankSelectButtonPressed
        case bankSelected(_ selectedBank: String)
        case nextButtonPressed
    }
    
    enum Mutation {
        case updateSubject(type: TextFieldType, _ value: String)
        case updateBank(selectedBank: String)
        case routeTo(step: EnterUserInfoStep)
    }
    
    struct State {
        var nickname: String
        var accountHolder: String
        var accountNumber: String
        var bank: String
        @Pulse var isNextButtonAvailable: Bool
        @Pulse var step: EnterUserInfoStep?
    }
    
    let initialState: State
    
    init(provider: LoginProvider, token: String) {
        self.initialState = State(
            nickname: "",
            accountHolder: "",
            accountNumber: "",
            bank: "은행선택",
            isNextButtonAvailable: false
        )
        self.user.provider = provider
        self.user.token = token
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonPressed:
            return .just(.routeTo(step: .pop))
            
        case .nicknameFieldUpdated(let nickname):
            self.user.nickname = nickname
            return .just(Mutation.updateSubject(type: .nickname, nickname))
            
        case .accountHolderFieldUpdated(let holder):
            self.user.bankHolder = holder
            return .just(Mutation.updateSubject(type: .accountHolder, holder))
            
        case .accountNumberFieldUpdated(let number):
            self.user.bankNumber = number
            return .just(Mutation.updateSubject(type: .accountNumber, number))
            
        case .bankSelectButtonPressed:
            return .just(.routeTo(step: .selectBank(delegate: self)))
            
        case .bankSelected(let bank):
            return .just(Mutation.updateBank(selectedBank: bank))
            
        case .nextButtonPressed:
            return .just(.routeTo(step: .agreeTerm(newUser: user)))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateSubject(type, value):
            switch type {
            case .nickname:
                self.user.nickname = value
                newState.nickname = value
                
            case .accountHolder:
                self.user.bankHolder = value
                newState.accountHolder = value
                
            case .accountNumber:
                self.user.bankNumber = value
                newState.accountNumber = value
            }
            
        case .updateBank(let bank):
            self.user.bank = bank
            newState.bank = bank
            
        case .routeTo(let step):
            newState.step = step
        }
        
        newState.isNextButtonAvailable = checkNextButtonValidation(newState)
        
        return newState
    }
}

// MARK: - Helper
extension EnterUserInfoViewReactor: EnterUserInfoViewDelegate {
    private func checkNextButtonValidation(_ state: State) -> Bool {
        return state.nickname != "" && state.accountHolder != "" && state.accountNumber != "" && state.bank != "은행선택"
    }
    
    func saveBank(_ selectedBank: String) {
        self.action.onNext(Action.bankSelected(selectedBank))
    }
}
