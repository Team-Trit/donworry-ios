//
//  PaymentCardListViewReactor.swift
//  App
//
//  Created by Woody on 2022/08/14.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import Models

final class PaymentCardListViewReactor: Reactor {

    enum Action {
        case setup
    }

    enum Mutation {
        case updateTitle(PaymentRoom)
    }

    struct State {
        var paymentRoom: PaymentRoom?
    }

    let initialState: State = State()

    init() {

    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setup:
            return Observable.concat([
                .just(.updateTitle(dummyPaymentRoom))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateTitle(let paymentRoom):
            newState.paymentRoom = paymentRoom
        }
        return newState
    }
}

extension PaymentCardListViewReactor {
    var dummyPaymentRoom: PaymentRoom {
        .dummyPaymentRoom2
    }
}
