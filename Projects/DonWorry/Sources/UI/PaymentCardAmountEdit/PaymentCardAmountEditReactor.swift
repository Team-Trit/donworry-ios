//
//  PaymentCardAmountEditReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/22.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit

enum PaymentCardAmountEditStep {
    case pop
    case paymentCardDeco
}

final class PaymentCardAmountEditReactor: Reactor {
    // TODO: RxFlow, Service 추가
    enum Action {
        case numberPadPressed(pressedItem: String)
        case nextButtonPressed
    }
    
    enum Mutation {
        case updateAmount(with: String)
        case routeTo(PaymentCardAmountEditStep)
    }
    
    struct State {
        let iconName: String
        let paymentTitle: String
        var amount: String

        @Pulse var step: PaymentCardAmountEditStep?
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
            return .just(.routeTo(.paymentCardDeco))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateAmount(with):
            newState.amount = setNewAmount(state.amount, with: with)
        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}

// MARK: - Helper
extension PaymentCardAmountEditReactor {
    private func setNewAmount(_ amount: String, with: String) -> String {
        var amount = amount.components(separatedBy: [","]).joined()
        
        if amount == "0" && (with == "0" || with == "00") {
            return amount
        }
        
        if with == "delete.left.fill" {
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
