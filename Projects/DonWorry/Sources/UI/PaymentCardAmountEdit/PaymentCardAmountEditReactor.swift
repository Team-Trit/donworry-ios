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
    private let paymentUseCase: PaymentCardService = PaymentCardServiceImpl()

    enum Action {
        case numberPadPressed(pressedItem: String)
        case nextButtonPressed
        case doneButtonPressed
        case didTapBackButton
        case didTapCloseButton
    }
    
    enum Mutation {
        case updateAmount(with: String)
        case routeTo(PaymentCardAmountEditStep)
    }
    
    struct State {
        // create var
        var paymentCard: PaymentCardModels.CreateCard.Request?
        
        // update var
        var cardTitle: String?
        var updateCard: PaymentCardModels.FetchCard.Response.PaymentCard?
        
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
    
    init(
        title: String,
        updateCard: PaymentCardModels.FetchCard.Response.PaymentCard
    ) {
        self.initialState = State(cardTitle: title, updateCard: updateCard, amount: "0")
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case let .numberPadPressed(pressedItem):
                return .just(.updateAmount(with: pressedItem))
            case .nextButtonPressed:
                return .just(.routeTo(.paymentCardDeco))
            case .doneButtonPressed:
            return paymentUseCase.putEditPaymentCardAmount(id: currentState.updateCard!.id, totalAmount: currentState.updateCard!.totalAmount)
                .map { _ in .routeTo(.pop) }
            
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
                if currentState.paymentCard != nil {
                    newState.paymentCard?.totalAmount = convertAmount(newState.amount)
                } else {
                    newState.updateCard?.totalAmount = convertAmount(newState.amount)
                }
                
            } else {
                newState.isButtonEnabled = false
            }
        case .routeTo(let step):
            newState.step = step
        }
        return newState
    }

    func convertAmount(_ amount: String) -> Int {
        let amount = amount.components(separatedBy: [","]).joined()
        return Int(amount) ?? 0
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
        } else if amount.count < 9 {
            if amount == "0" {
                amount = with
            } else {
                amount += with
            }
        }
        
        return (Int(amount)?.formatted())!
    }
}
