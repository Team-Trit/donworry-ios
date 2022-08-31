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

enum PaymentCardListStep {
    case dismiss
    case none
}
final class PaymentCardListReactor: Reactor {
    typealias Section = PaymentCardSection
    enum Action {
        case setup
        case didTapDismissButton
    }

    enum Mutation {
        case updateTitle(String)
        case updatePaymentCardList([PaymentCard])
        case routeTo(PaymentCardListStep)
    }

    struct State {
        var spaceID: Int = 0
        var paymentRoom: PaymentRoom?
        var section: [Section] = [.PaymentCardSection([.AddPaymentCard])]
        var title: String = ""
        @Pulse var step: PaymentCardListStep?
    }

    var initialState: State = State()
    
    init(
        _ paymentCardService: PaymentCardService = PaymentCardServiceImpl(),
        _ paymentCardListPresenter: PaymentCardListPresenter = PaymentCardPresenterImpl(),
        _ spaceID: Int = 0
    ) {
        self.paymentCardService = paymentCardService
        self.paymentCardListPresenter =  paymentCardListPresenter
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setup:
            return Observable.concat([
                paymentCardService.fetchPaymentCardList(spaceID: currentState.spaceID)
                    .map { .updatePaymentCardList($0) },
                .just(.updateTitle("이전 화면에서 받아올 제목"))
            ])
        case .didTapDismissButton:
            return .just(.routeTo(.dismiss))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateTitle(let title):
            newState.title = title
        case .updatePaymentCardList(let paymentCardList):
            newState.section = paymentCardListPresenter.formatSection(
                from: paymentCardList
            )
        case .routeTo(let step):
            newState.step = step
        }
        return newState
    }

    private let paymentCardService: PaymentCardService
    private let paymentCardListPresenter: PaymentCardListPresenter
}

extension PaymentCardListReactor {
    var dummyPaymentRoom: PaymentRoom {
        .dummyPaymentRoom2
    }
}
