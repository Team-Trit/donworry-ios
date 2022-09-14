//
//  AccountEditViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/06.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Models
import ReactorKit

enum AccountEditViewStep {
    case none
    case pop
    case presentSelectBankView
}

protocol AccountEditViewDelegate: AnyObject {
    func saveBank(selectedBank: String)
}

final class AccountEditViewReactor: Reactor {
    private let userService: UserService
    private let getUserUseCase: GetUserAccountUseCase
    var user: User
    
    enum Action {
        case pressBackButton
        case selectBankButtonPressed
        case selectBank(selectedBank: String)
        case updateHolder(holder: String)
        case updateAccountNumber(number: String)
        case pressDoneButton
    }
    
    enum Mutation {
        case updateBank(selectedBank: String)
        case updateValidation
        case routeTo(step: AccountEditViewStep)
    }
    
    struct State {
        var bank: String
        @Pulse var isDoneButtonAvailable: Bool
        @Pulse var step: AccountEditViewStep?
    }
    
    let initialState: State

    init(
        userService: UserService = UserServiceImpl(),
        getUserUseCase: GetUserAccountUseCase = GetUserAccountUseCaseImpl()
    ) {
        self.userService = userService
        self.getUserUseCase = getUserUseCase
        self.user = getUserUseCase.getUserAccountUnWrapped()!
        self.initialState = State(
            bank: user.bankAccount.bank,
            isDoneButtonAvailable: false
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .pressBackButton:
            return .just(Mutation.routeTo(step: .pop))
            
        case .selectBankButtonPressed:
            return .just(Mutation.routeTo(step: .presentSelectBankView))
            
        case .selectBank(let selectedBank):
            self.user.bankAccount.bank = selectedBank
            return .concat([
                .just(Mutation.updateBank(selectedBank: selectedBank)),
                .just(Mutation.updateValidation)
            ])
            
        case .updateHolder(let holder):
            self.user.bankAccount.accountHolderName = holder
            return .just(Mutation.updateValidation)
            
        case .updateAccountNumber(let number):
            self.user.bankAccount.accountNumber = number
            return .just(Mutation.updateValidation)
            
        case .pressDoneButton:
            return userService.updateUser(nickname: nil,
                                  imgURL: nil,
                                  bank: user.bankAccount.bank,
                                  holder: user.bankAccount.accountHolderName,
                                  accountNumber: user.bankAccount.accountNumber,
                                  isAgreeMarketing: nil)
            .map { _ in .routeTo(step: .pop) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateBank(let selectedBank):
            newState.bank = selectedBank
            
        case .updateValidation:
            newState.isDoneButtonAvailable = checkNextButtonValidation(self.user)
            
        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}

// MARK: - Helper
extension AccountEditViewReactor: AccountEditViewDelegate {
    private func checkNextButtonValidation(_ user: User) -> Bool {
        return user.bankAccount.bank != "" && user.bankAccount.accountHolderName != "" && user.bankAccount.accountNumber != ""
    }
    
    func saveBank(selectedBank: String) {
        self.action.onNext(.selectBank(selectedBank: selectedBank))
    }
}
