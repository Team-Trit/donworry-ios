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

enum PaymentCardNameEditViewType {
    case create //default
    case update
}

final class PaymentCardNameEditViewReactor: Reactor {

    enum Action {
        case didTapNextButton(PaymentCardNameEditViewType)
    }

    enum Mutation {
        case routeTo(PaymentCardNameEditStep)
    }

    struct State {
        @Pulse var step: PaymentCardNameEditStep?
    }

    let initialState: State

    init() {
        self.initialState = .init()
    }

    func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .didTapNextButton(let type):
             let step: PaymentCardNameEditStep = type == .create ? .paymentCardIconEdit : .pop
             return .just(.routeTo(step))
         }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
         case .routeTo(let step):
             newState.step = step
         }
        return newState
    }
}
