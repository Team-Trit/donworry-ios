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
    private let getUserAccountUseCase: GetUserAccountUseCase
    private let updateAccountUseCase: UpdateAccountUseCase
    
    enum Action {
        case viewDidLoad
        case pressBackButton
        case selectBankButtonPressed
        case selectBank(selectedBank: String)
        case updateHolder(holder: String)
        case updateAccountNumber(number: String)
        case pressDoneButton
    }
    
    enum Mutation {
        case setup(Models.User)
        case updateBank(selectedBank: String)
        case updateHolder(holder: String)
        case updateNumber(number: String)
        case updateValidation
        case routeTo(step: AccountEditViewStep)
    }
    
    struct State {
        var user: Models.User
        @Pulse var isDoneButtonAvailable: Bool
        @Pulse var step: AccountEditViewStep?
    }
    
    let initialState: State

    init(
        getUserAccountUseCase: GetUserAccountUseCase = GetUserAccountUseCaseImpl(),
        updateAccountUseCase: UpdateAccountUseCase = UpdateAccountUseCaseImpl()
    ) {
        self.getUserAccountUseCase = getUserAccountUseCase
        self.updateAccountUseCase = updateAccountUseCase
        self.initialState = State(
            user: User(id: -1, nickName: "", bankAccount: BankAccount(bank: "", accountHolderName: "", accountNumber: ""), image: ""),
            isDoneButtonAvailable: false
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return getUserAccountUseCase.getUserAccount()
                .map { user in
                    guard let user = user else { return .routeTo(step: .pop) }
                    return .setup(user)
                }
            
        case .pressBackButton:
            return .just(Mutation.routeTo(step: .pop))
            
        case .selectBankButtonPressed:
            return .just(Mutation.routeTo(step: .presentSelectBankView))
            
        case .selectBank(let selectedBank):
            return .concat([
                .just(Mutation.updateBank(selectedBank: selectedBank)),
                .just(Mutation.updateValidation)
            ])
            
        case .updateHolder(let holder):
            return .concat([
                .just(Mutation.updateHolder(holder: holder)),
                .just(Mutation.updateValidation)
            ])
            
        case .updateAccountNumber(let number):
            return .concat([
                .just(Mutation.updateNumber(number: number)),
                .just(Mutation.updateValidation)
            ])
            
        case .pressDoneButton:
            let currentUser = currentState.user
            return updateAccountUseCase.updateAccount(
                bank: currentUser.bankAccount.bank,
                holder: currentUser.bankAccount.accountHolderName,
                accountNumber: currentUser.bankAccount.accountNumber
            )
            .map { _ in return .routeTo(step: .pop)}
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setup(let user):
            newState.user = user
            
        case .updateBank(let selectedBank):
            newState.user.bankAccount.bank = selectedBank
            
        case .updateHolder(let holder):
            newState.user.bankAccount.accountHolderName = holder
            
        case .updateNumber(let number):
            newState.user.bankAccount.accountNumber = number
            
        case .updateValidation:
            newState.isDoneButtonAvailable = checkNextButtonValidation(self.currentState.user)
            
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
