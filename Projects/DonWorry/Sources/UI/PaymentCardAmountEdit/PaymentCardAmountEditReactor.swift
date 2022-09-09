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
    case paymentCardList
}

final class PaymentCardAmountEditReactor: Reactor {
    typealias Space = PaymentCardModels.FetchCardList.Response.Space

    enum Action {
        case numberPadPressed(pressedItem: String)
        case nextButtonPressed
        case didTapBackButton
        case didTapCloseButton
    }
    
    enum Mutation {
        case updateAmount(with: String)
        case routeTo(PaymentCardAmountEditStep)
    }
    
    struct State {
        var paymentCard: PaymentCardModels.CreateCard.Request
        var amount: String
        var isButtonEnabled: Bool = false
        @Pulse var step: PaymentCardAmountEditStep?
    }
    
    let initialState: State
    
    init(
        paymentCard: PaymentCardModels.CreateCard.Request
    ){
        self.initialState = State(paymentCard: paymentCard, amount: "0")
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case let .numberPadPressed(pressedItem):
                return .just(.updateAmount(with: pressedItem))
            case .nextButtonPressed:
                return .just(.routeTo(.paymentCardDeco))
            case .didTapBackButton:
                return .just(.routeTo(.pop))
            case .didTapCloseButton:
                return .just(.routeTo(.paymentCardList))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateAmount(amount):
            newState.amount = setNewAmount(state.amount, with: amount)
            if newState.amount != "0" {
                newState.isButtonEnabled = true
                newState.paymentCard.totalAmount = Int(amount) ?? 0
            } else {
                newState.isButtonEnabled = false
            }
        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}

// MARK: - Helper
extension PaymentCardAmountEditReactor {
  
    // TODO: 해당 뷰 담당자와 논의 후 나중에 교체예정
//    private func convertAmount(amount: String) -> Int {
//        let amount = amount.components(separatedBy: [","]).joined()
//        return Int(amount) ?? 0
//    }
    
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
