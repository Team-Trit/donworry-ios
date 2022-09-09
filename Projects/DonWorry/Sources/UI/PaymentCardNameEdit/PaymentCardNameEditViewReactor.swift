//
//  PaymentCardNameEditViewReactor.swift
//  App
//
//  Created by Chanhee Jeong on 2022/08/18.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum PaymentCardNameEditStep {
    case pop
    case paymentCardIconEdit
}

final class PaymentCardNameEditViewReactor: Reactor {
    typealias Space = PaymentCardModels.FetchCardList.Response.Space

    enum PaymentCardNameEditViewType {
        case create //default
        case update
    }

    enum Action {
        case didTapBackButton
        case didTapNextButton
        case fetchCardName(String)
    }

    enum Mutation {
        case routeTo(PaymentCardNameEditStep)
        case updateCardName(String)
    }

    struct State {
        var type: PaymentCardNameEditViewType
        var paymentCard: PaymentCardModels.CreateCard.Request
        @Pulse var step: PaymentCardNameEditStep?
    }

    let initialState: State

    init(
        type: PaymentCardNameEditViewType,
        paymentCard: PaymentCardModels.CreateCard.Request
    ){
        self.initialState = .init(type: type, paymentCard: paymentCard)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackButton:
            return .just(.routeTo(.pop))

        case .didTapNextButton:
            let step: PaymentCardNameEditStep = (currentState.type == .create) ? .paymentCardIconEdit : .pop
            return .just(.routeTo(step))

        case .fetchCardName(let newName):
            return .just(Mutation.updateCardName(newName))

        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .routeTo(let step):
            newState.step = step
        case .updateCardName(let newName):
            newState.paymentCard.name = newName
        }
        return newState
    }
}
