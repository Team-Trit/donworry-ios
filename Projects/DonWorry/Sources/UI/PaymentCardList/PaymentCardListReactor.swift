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
        case setup
        case didTapBackButton
        case didTapPaymentCardDetail
        case didTapOptionButton
        case routeToNameEdit
        case didTapLeaveButton
    }

    enum Mutation {
        case updateSpace(Space)
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
        space: Space,
        spaceService: SpaceService = SpaceServiceImpl(),
        paymentCardService: PaymentCardService = PaymentCardServiceImpl(),
        paymentCardListPresenter: PaymentCardListPresenter = PaymentCardPresenterImpl()
    ) {
        self.initialState = .init(space: space)
        self.spaceService = spaceService
        self.paymentCardService = paymentCardService
        self.paymentCardListPresenter =  paymentCardListPresenter

    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setup:
            // 통신이 느릴것을 대비하여 이전 화면에서 넘겨온 정보를 먼저 띄어주는 역할입니다. 빠르다면 제거하여도 됩니다.
            let space = Observable.just(Mutation.updateSpace(currentState.space))
            let paymentCardListInformation = requestPaymentCardListInformation()
            return Observable.concat([space, paymentCardListInformation])
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
        case .updateSpace(let space):
            newState.space = space
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
