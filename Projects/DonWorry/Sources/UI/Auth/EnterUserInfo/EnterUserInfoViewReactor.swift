//
//  EnterUserInfoViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/23.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import DesignSystem
import Models
import ReactorKit
import RxCocoa

enum TextFieldType {
    case nickname
    case accountHolder
    case accountNumber
}

protocol EnterUserInfoViewDelegate: AnyObject {
    func saveBank(_ selectedBank: String)
}

final class EnterUserInfoViewReactor: Reactor {
    private let disposeBag = DisposeBag()
    private var user = SignUpUserModel(provider: .none,
                                     nickname: "",
                                     email: "",
                                     bank: "",
                                     bankNumber: "",
                                     bankHolder: "",
                                     isAgreeMarketing: false,
                                     accessToken: "")
    
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
        case routeTo(step: DonworryStep)
    }
    
    struct State {
        var nickname: String
        var accountHolder: String
        var accountNumber: String
        var bank: String
        var isNextButtonAvailable: Bool
        @Pulse var step: DonworryStep?
    }
    
    let initialState: State
    
    init(provider: LoginProvider, accessToken: String) {
        self.initialState = State(
            nickname: "",
            accountHolder: "",
            accountNumber: "",
            bank: "은행선택",
            isNextButtonAvailable: false
        )
        self.user.provider = provider
        self.user.accessToken = accessToken
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonPressed:
            return .just(Mutation.routeTo(step: .popViewController))
            
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
            return .just(Mutation.routeTo(step: .bankSelectIsRequired(delegate: self)))
            
        case .bankSelected(let bank):
            return .just(Mutation.updateBank(selectedBank: bank))
            
        case .nextButtonPressed:
            return .just(Mutation.routeTo(step: .agreeTermIsRequired(newUser: user)))
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
