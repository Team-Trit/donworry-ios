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
        let banks = banks.map { Bank(rawValue: $0)!.koreanName }
            .filter { $0.hasPrefix(filter) }
            .map { convertToBank($0) }
        return banks
    }
    
    private func convertToBank(_ koreanBank: String) -> String {
        switch koreanBank {
        case "경남은행": return "bankGYEONGNAM"
        case "광주은행": return "bankGWANGJU"
        case "국민은행": return "bankKB"
        case "기업은행": return "bankIBK"
        case "농협은행": return "bankNH"
        case "대구은행": return "bankDAEGU"
        case "부산은행": return "bankBUSAN"
        case "산림조합중앙회": return "bankSANLIM"
        case "산업은행": return "bankSANUP"
        case "새마을금고": return "bankSAEMAEUL"
        case "수협은행": return "bankSUHYUP"
        case "신한은행": return "bankSHINHAN"
        case "신협중앙회": return "bankSINHYEOP"
        case "우리은행": return "bankWOORI"
        case "우체국": return "bankEPOST"
        case "저축은행": return "bankJEOCHOOK"
        case "전북은행": return "bankJEONBOOK"
        case "제주은행": return "bankJEJU"
        case "카카오뱅크": return "bankKAKAO"
        case "케이뱅크": return "bankK"
        case "토스뱅크": return "bankTOSS"
        case "하나은행": return "bankHANA"
        case "한국씨티은행": return "bankCITI"
        case "한국투자증권": return "bankHANTOO"
        case "KB증권": return "bankKBSEC"
        case "NH투자증권": return "bankNONGTOO"
        case "SC제일은행": return "bankSC"
        default: return ""
        }
    }
}
