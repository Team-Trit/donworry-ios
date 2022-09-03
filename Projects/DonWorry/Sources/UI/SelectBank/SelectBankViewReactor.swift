//
//  SelectBankViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/24.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import Models
import ReactorKit
import RxCocoa
import RxFlow

final class SelectBankViewReactor: Reactor, Stepper {
    private let authViewModel = AuthViewModel.shared
    private let banks = Bank.allCases.map { $0.rawValue }
    
    let steps = PublishRelay<Step>()
    
    enum Action {
        case dismissButtonPressed
        case searchTextChanged(filter: String)
        case selectBank(_ selectedBank: Bank)
    }
    
    enum Mutation {
        case dismissSelectBankSheet
        case performQuery(filteredBankList: [String])
    }
    
    struct State {
        var snapshot: NSDiffableDataSourceSnapshot<Section, String>
    }
    
    let initialState: State
    
    init() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, String>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(banks)
        self.initialState = State(
            snapshot: initialSnapshot
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .dismissButtonPressed:
            self.steps.accept(DonworryStep.bankSelectIsComplete)
            return .just(Mutation.dismissSelectBankSheet)
            
        case let .searchTextChanged(filter):
            let filteredBankList = performQuery(with: filter)
            return .just(Mutation.performQuery(filteredBankList: filteredBankList))
            
        case let .selectBank(selectedBank):
            self.authViewModel.bank.onNext(selectedBank)
            self.steps.accept(DonworryStep.bankSelectIsComplete)
            return .just(Mutation.dismissSelectBankSheet)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .dismissSelectBankSheet:
            break
            
        case let .performQuery(filteredBankList):
            state.snapshot = NSDiffableDataSourceSnapshot<Section, String>()
            state.snapshot.appendSections([.main])
            state.snapshot.appendItems(filteredBankList)
        }
        
        return state
    }
}

// MARK: - Helper
extension SelectBankViewReactor {
    private func performQuery(with filter: String) -> [String] {
        return banks.filter { $0.hasPrefix(filter) }
    }
}
