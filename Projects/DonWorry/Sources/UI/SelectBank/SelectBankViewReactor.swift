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
    private let banks = Bank.allCases.map { $0.rawValue }
    
    let steps = PublishRelay<Step>()
    
    enum Action {
        case dismissButtonPressed
        case searchTextChanged(filter: String)
        case selectBank(_ selectedBank: String)
    }
    
    enum Mutation {
        case updateLoading(Bool)
        case dismissSelectBankSheet
        case performQuery(filteredBankList: [String])
    }
    
    struct State {
        var isLoading: Bool
        var snapshot: NSDiffableDataSourceSnapshot<Section, String>
    }
    
    let initialState: State
    
    init() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, String>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(banks)
        self.initialState = State(
            isLoading: false,
            snapshot: initialSnapshot
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .dismissButtonPressed:
            self.steps.accept(DonworryStep.bankSelectIsComplete(selectedBank: nil))
            return .just(Mutation.dismissSelectBankSheet)
            
        case let .searchTextChanged(filter):
            let filteredBankList = performQuery(with: filter)
            return Observable.concat([
                .just(Mutation.updateLoading(true)),
                .just(Mutation.performQuery(filteredBankList: filteredBankList)),
                .just(Mutation.updateLoading(false))
            ])
            
        case let .selectBank(selectedBank):
            self.steps.accept(DonworryStep.bankSelectIsComplete(selectedBank: selectedBank))
            return .just(Mutation.dismissSelectBankSheet)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .updateLoading(let isLoading):
            state.isLoading = isLoading
            
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
