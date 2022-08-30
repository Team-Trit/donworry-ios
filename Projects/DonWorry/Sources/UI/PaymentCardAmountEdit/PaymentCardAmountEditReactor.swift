//
//  PaymentCardAmountEditReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/22.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit

final class PaymentCardAmountEditReactor: Reactor {
    // TODO: RxFlow, Service 추가
    enum Action {
        case numberPadPressed(pressedItem: String)
        case nextButtonPressed
    }
    
    enum Mutation {
        case updateAmount(with: String)
        case navigateToNext
    }
    
    struct State {
        let iconName: String
        let paymentTitle: String
        var amount: String
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(iconName: "ic_calculation_3d", paymentTitle: "승창승창", amount: "0")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .numberPadPressed(pressedItem):
            return .just(.updateAmount(with: pressedItem))
        case .nextButtonPressed:
            // TODO: Navigate to next VC
            return .just(.navigateToNext)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .updateAmount(with):
            state.amount = setNewAmount(state.amount, with: with)
        case .navigateToNext:
            break
        }
        
        return state
    }
}

// MARK: - Helper
extension PaymentCardAmountEditReactor {
    private func setNewAmount(_ amount: String, with: String) -> String {
        var amount = amount.components(separatedBy: [","]).joined()
        
        if amount == "0" && (with == "0" || with == "00") {
            return amount
        }
        
        if with == "<" {
            if amount.count == 1 {
                amount = "0"
            } else {
                _ = amount.popLast()
            }
        } else if amount.count < 16 {
            if amount == "0" {
                amount = with
            } else {
                amount += with
            }
        }
        
        return (Int(amount)?.formatted())!
    }
}
