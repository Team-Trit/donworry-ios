//
//  PaymentCardIconEditViewReactor.swift
//  App
//
//  Created by Chanhee Jeong on 2022/08/18.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum PaymentCardIconEditStep {
    case pop
    case paymentCardAmountEdit
}

final class PaymentCardIconEditViewReactor: Reactor {

    enum Action {
        case didTapNextButton
    }

    enum Mutation {
        case routeTo(PaymentCardIconEditStep)
    }

    struct State {
        @Pulse var step: PaymentCardIconEditStep?
    }

    let initialState: State

    init() {
        self.initialState = .init()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .just(.routeTo(.paymentCardAmountEdit))
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
