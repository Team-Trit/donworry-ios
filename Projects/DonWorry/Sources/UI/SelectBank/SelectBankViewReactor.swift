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

enum SelectBankStep {
    case none
    case dismissToPaymentCardDeco
    case dismissToProfileAccountEdit
}

final class SelectBankViewReactor: Reactor, Stepper {
    private let banks = Bank.allCases.map { $0.rawValue }
    var selectedBank = ""
    let parentView: ParentView
    let steps = PublishRelay<Step>()
    
    enum ParentView {
        case enterUserInfo
        case paymentCardDeco
        case profileAccountEdit
    }
    
    enum Action {
        case dismissButtonPressed
        case searchTextChanged(filter: String)
        case selectBank(_ selectedBank: String)
    }
    
    enum Mutation {
        case performQuery(filteredBankList: [String])
        case routeTo(step: SelectBankStep)
    }
    
    struct State {
        var isLoading: Bool
        var snapshot: NSDiffableDataSourceSnapshot<Section, String>
        @Pulse var step: SelectBankStep
    }
    
    let initialState: State
    
    init(parentView: ParentView) {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, String>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(banks)
        self.initialState = State(
            isLoading: false,
            snapshot: initialSnapshot,
            step: .none
        )
        self.parentView = parentView
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .dismissButtonPressed:
            switch parentView {
            case .enterUserInfo:
                self.steps.accept(DonworryStep.bankSelectIsComplete(selectedBank: nil))
                return .empty()
                
            case .paymentCardDeco:
                return .just(Mutation.routeTo(step: .dismissToPaymentCardDeco))
                
            case .profileAccountEdit:
                return .just(Mutation.routeTo(step: .dismissToProfileAccountEdit))
            }
            
        case let .searchTextChanged(filter):
            let filteredBankList = performQuery(with: filter)
            return .just(Mutation.performQuery(filteredBankList: filteredBankList))
            
        case let .selectBank(selectedBank):
            switch parentView {
            case .enterUserInfo:
                self.steps.accept(DonworryStep.bankSelectIsComplete(selectedBank: selectedBank))
                return .empty()
                
            case .paymentCardDeco:
                self.selectedBank = selectedBank
                return .just(Mutation.routeTo(step: .dismissToPaymentCardDeco))
                
            case .profileAccountEdit:
                self.selectedBank = selectedBank
                return .just(Mutation.routeTo(step: .dismissToProfileAccountEdit))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .performQuery(filteredBankList):
            newState.snapshot = NSDiffableDataSourceSnapshot<Section, String>()
            newState.snapshot.appendSections([.main])
            newState.snapshot.appendItems(filteredBankList)
            
        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}

// MARK: - Helper
extension SelectBankViewReactor {
    private func performQuery(with filter: String) -> [String] {
        return banks.filter { $0.hasPrefix(filter) }
    }
}
