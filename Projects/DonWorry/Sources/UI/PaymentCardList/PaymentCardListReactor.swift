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

enum PaymentCardListStep {
    case pop
    case none
    case paymentCardDetail
    case actionSheet
    case nameEdit
    case cantLeaveAlert
}

final class PaymentCardListReactor: Reactor {
    typealias Section = PaymentCardSection
    typealias PaymentCardListInformation = PaymentCardModels.FetchCardList.Response
    typealias PaymentCardList = [PaymentCardModels.FetchCardList.Response.PaymentCard]
    typealias Space = PaymentCardModels.FetchCardList.Response.Space

    enum Action {
        case viewWillAppear
        case didTapBackButton
        case didTapPaymentCardDetail
        case didTapOptionButton
        case routeToNameEdit
        case didTapLeaveButton
    }

    enum Mutation {
        case initializeState(PaymentCardListInformation)
        case routeTo(PaymentCardListStep)
    }

    struct State {
        var space: Space
        var paymentCardListViewModel: [PaymentCardCellViewModel] = []
        var canLeaveSpace: Bool = true

        @Pulse var step: PaymentCardListStep?
    }

    let initialState: State
    
    init(
        spaceID: Int, adminID: Int,
        spaceService: SpaceService = SpaceServiceImpl(),
        paymentCardService: PaymentCardService = PaymentCardServiceImpl(),
        paymentCardListPresenter: PaymentCardListPresenter = PaymentCardPresenterImpl()
    ) {
        self.initialState = .init(space: .init(id: spaceID, adminID: adminID, title: "", status: "", shareID: ""))
        self.spaceService = spaceService
        self.paymentCardService = paymentCardService
        self.paymentCardListPresenter =  paymentCardListPresenter

    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let paymentCardListInformation = requestPaymentCardListInformation()
            return paymentCardListInformation
        case .didTapBackButton:
            return .just(.routeTo(.pop))
        case .didTapPaymentCardDetail:
            return .just(.routeTo(.paymentCardDetail))
        case .didTapOptionButton:
            return .just(.routeTo(.actionSheet))
        case .routeToNameEdit:
            return .just(.routeTo(.nameEdit))
        case .didTapLeaveButton:
            let leaveAct = requestLeaveSpace()
            return leaveAct
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .initializeState(let information):
            newState.space = information.space
            newState.canLeaveSpace = information.isAllPaymentCompleted
            newState.paymentCardListViewModel = paymentCardListPresenter.formatSection(
                from: information.cards
            )
        case .routeTo(let step):
            newState.step = step
        }
        return newState
    }

    private func requestPaymentCardListInformation() -> Observable<Mutation> {
        paymentCardService.fetchPaymentCardList(spaceID: currentState.space.id)
            .map { .initializeState($0)  }
    }

    private func requestLeaveSpace() -> Observable<Mutation> {
        if !currentState.canLeaveSpace { return .just(.routeTo(.cantLeaveAlert)) }
        return spaceService.leaveSpace(request: .init(isStatusOpen: currentState.canLeaveSpace, isAdmin: currentState.space.adminID, spaceID: currentState.space.id))
            .map { _ in  .routeTo(.pop) }
    }

    private let spaceService: SpaceService
    private let paymentCardService: PaymentCardService
    private let paymentCardListPresenter: PaymentCardListPresenter
}
