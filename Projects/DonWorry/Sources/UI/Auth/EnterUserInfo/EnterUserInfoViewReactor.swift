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

enum TextFieldType {
    case nickname
    case accountHolder
    case accountNumber
}

final class EnterUserInfoViewReactor: Reactor, Stepper {
    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    
    private let accessToken: String
    private var nickname = ""
    private var bank = ""
    private var holder = ""
    private var number = ""
    
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
        case navigateToNextVC
    }
    
    struct State {
        var nickname: String
        var accountHolder: String
        var accountNumber: String
        var bank: String
        var isNextButtonAvailable: Bool
    }
    
    let initialState: State
    
    init(accessToken: String) {
        self.initialState = State(
            nickname: "",
            accountHolder: "",
            accountNumber: "",
            bank: "은행선택",
            isNextButtonAvailable: false
        )
        self.accessToken = accessToken
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonPressed:
            self.steps.accept(DonworryStep.popViewController)
            return .empty()
            
        case .nicknameFieldUpdated(let nickname):
            return .just(Mutation.updateSubject(type: .nickname, nickname))
            
        case .accountHolderFieldUpdated(let holder):
            return .just(Mutation.updateSubject(type: .accountHolder, holder))
            
        case .accountNumberFieldUpdated(let number):
            return .just(Mutation.updateSubject(type: .accountNumber, number))
            
        case .bankSelectButtonPressed:
            self.steps.accept(DonworryStep.bankSelectIsRequired(delegate: self))
            return .empty()
            
        case .bankSelected(let bank):
            return .just(Mutation.updateBank(selectedBank: bank))
            
        case .nextButtonPressed:
            self.steps.accept(DonworryStep.agreeTermIsRequired(accessToken: accessToken, nickname: nickname, bank: bank, holder: holder, number: number))
            return .just(Mutation.navigateToNextVC)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateSubject(type, value):
            switch type {
            case .nickname:
                nickname = value
                newState.nickname = value
                
            case .accountHolder:
                holder = value
                newState.accountHolder = value
                
            case .accountNumber:
                number = value
                newState.accountNumber = value
            }
            
        case .updateBank(let bank):
            
            self.bank = bank
            newState.bank = bank
            
        case .navigateToNextVC:
            break
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
