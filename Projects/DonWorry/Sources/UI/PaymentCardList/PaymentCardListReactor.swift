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
    typealias Space = Entity.Space

    enum Action {
        case setup
        case didTapDismissButton
    }

    enum Mutation {
        case updateSpace(Space)
        case updatePaymentCardList([PaymentCard])
        case routeTo(PaymentCardListStep)
    }

    struct State {
        var space: Space
        var paymentCardListViewModel: [PaymentCardCellViewModel] = []

        @Pulse var step: PaymentCardListStep?
    }

    let initialState: State
    
    init(
        space: Space,
        paymentCardService: PaymentCardService = PaymentCardServiceImpl(),
        paymentCardListPresenter: PaymentCardListPresenter = PaymentCardPresenterImpl()
    ) {
        self.initialState = .init(space: space)
        self.paymentCardService = paymentCardService
        self.paymentCardListPresenter =  paymentCardListPresenter

    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setup:
            let cardList = paymentCardService
                .fetchPaymentCardList(spaceID: currentState.space.id)
                .map { Mutation.updatePaymentCardList($0) }
            let space = Observable.just(Mutation.updateSpace(currentState.space))
            return Observable.concat([cardList, space])
        case .didTapDismissButton:
            return .just(.routeTo(.dismiss))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateSpace(let space):
            newState.space = space
        case .updatePaymentCardList(let paymentCardList):
            newState.paymentCardListViewModel = paymentCardListPresenter.formatSection(
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