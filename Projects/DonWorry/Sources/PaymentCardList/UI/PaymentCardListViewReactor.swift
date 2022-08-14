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
    typealias Section = PaymentCardSection
    enum Action {
        case setup
    }

    enum Mutation {
        case updateTitle(PaymentRoom)
    }

    struct State {
        var paymentRoom: PaymentRoom?
        var section: [Section] = [.PaymentCardSection([.AddPaymentCard])]
    }

    let initialState: State = State()

    init(
        _ paymentCardListPresenter: PaymentCardListPresenter = PaymentCardPresenterImpl()
    ) {
        self.paymentCardListPresenter =  paymentCardListPresenter
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
            newState.section = paymentCardListPresenter.formatSection(from: paymentRoom.paymentCardList)
        }
        return newState
    }

    private let paymentCardListPresenter: PaymentCardListPresenter
}

extension PaymentCardListViewReactor {
    var dummyPaymentRoom: PaymentRoom {
        .dummyPaymentRoom2
    }
}
