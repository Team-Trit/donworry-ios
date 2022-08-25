//
//  SelectBankViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/24.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxFlow

final class SelectBankViewReactor: Reactor, Stepper {
    private let banks = ["경남은행", "광주은행", "국민은행", "기업은행", "농협은행", "대구은행", "부산은행", "산림조합중앙회", "산업은행", "새마을금고", "수협은행", "신한은행", "신협중앙회", "우리은행", "우체국", "저축은행", "전북은행", "제주은행", "카카오뱅크", "케이뱅크", "토스뱅크", "하나은행", "한국씨티은행", "한국투자증권", "KB증권", "NH투자증권", "SC제일은행"
    ]
    let steps = PublishRelay<Step>()
    
    enum Action {
        case dismissButtonPressed
        case searchTextChanged(filter: String)
        case selectBank(_ index: Int)
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
            
        case let .selectBank(index):
            let selectedBank = banks[index]
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
