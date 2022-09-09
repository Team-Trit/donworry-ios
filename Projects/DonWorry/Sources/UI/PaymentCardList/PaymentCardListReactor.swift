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
}

final class PaymentCardListReactor: Reactor {
    typealias Section = PaymentCardSection
    typealias PaymentCardListInformation = PaymentCardModels.FetchCardList.Response
    typealias PaymentCardList = [PaymentCardModels.FetchCardList.Response.PaymentCard]
    typealias Space = PaymentCardModels.FetchCardList.Response.Space
    typealias Status = SpaceModels.StartPaymentAlogrithm.Request.Status

    enum Action {
        case viewWillAppear
        case didTapStartPaymentAlgorithmButton
        case didTapBackButton
        case didTapPaymentCardDetail
        case didTapOptionButton
        case routeToNameEdit
        case didTapLeaveButton
    }

    enum Mutation {
        case initializeState(PaymentCardListInformation)
        case initializeIsUserAdmin(Bool)
        case routeTo(PaymentCardListStep)
        case error(Error?)
    }

    struct State {
        var space: Space
        var paymentCardListViewModel: [PaymentCardCellViewModel] = []
        var canLeaveSpace: Bool = true
        var isUserAdmin: Bool = false

        @Pulse var error: Error?
        @Pulse var step: PaymentCardListStep?
    }

    let initialState: State
    
    init(
        spaceID: Int, adminID: Int,
        spaceService: SpaceService = SpaceServiceImpl(),
        judgeSpaceAdminUseCase: JudgeSpaceAdminUseCase = JudgeSpaceAdminUseCaseImpl(),
        paymentCardService: PaymentCardService = PaymentCardServiceImpl(),
        paymentCardListPresenter: PaymentCardListPresenter = PaymentCardPresenterImpl()
    ) {
        self.initialState = .init(space: .init(id: spaceID, adminID: adminID, title: "", status: "", shareID: ""))
        self.spaceService = spaceService
        self.judgeSpaceAdminUseCase = judgeSpaceAdminUseCase
        self.paymentCardService = paymentCardService
        self.paymentCardListPresenter =  paymentCardListPresenter
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let isUserAdmin = requestIsUserAdmin()
            let paymentCardListInformation = requestPaymentCardListInformation()

            return .concat([isUserAdmin, paymentCardListInformation])
        case .didTapStartPaymentAlgorithmButton:
            return requestStartPaymentAlgorithm()
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
        case .initializeIsUserAdmin(let isUserAdmin):
            newState.isUserAdmin = isUserAdmin
        case .routeTo(let step):
            newState.step = step
        case .error(let error):
            newState.error = error
        }
        return newState
    }

    private func requestStartPaymentAlgorithm() -> Observable<Mutation> {
        if currentState.paymentCardListViewModel.contains(where: { $0.participatedUserCount == 1 }) {
            return .just(.error(PaymentCardListViewError.cantStartAlgorithm))
        } else if currentState.paymentCardListViewModel.isEmpty {
            return .just(.error(PaymentCardListViewError.noPaymentCardList))
        }
        let space = currentState.space
        return spaceService.startPaymentAlogrithm(request: .init(id: space.id, status: .progress)).map { _ in .routeTo(.pop) }
    }
    private func requestIsUserAdmin() -> Observable<Mutation> {
        judgeSpaceAdminUseCase.judgeUserIsSpaceAdmin(spaceAdminID: currentState.space.adminID).map { .initializeIsUserAdmin($0) }
    }

    private func requestPaymentCardListInformation() -> Observable<Mutation> {
        paymentCardService.fetchPaymentCardList(spaceID: currentState.space.id)
            .map { .initializeState($0)  }
    }

    private func requestLeaveSpace() -> Observable<Mutation> {
        if !currentState.canLeaveSpace { return .just(.error(PaymentCardListViewError.cantLeaveUntilPaymentsCompleted)) }
        return spaceService.leaveSpace(request: .init(isStatusOpen: currentState.canLeaveSpace, isAdmin: currentState.space.adminID, spaceID: currentState.space.id))
            .map { _ in  .routeTo(.pop) }
    }

    private let spaceService: SpaceService
    private let judgeSpaceAdminUseCase: JudgeSpaceAdminUseCase
    private let paymentCardService: PaymentCardService
    private let paymentCardListPresenter: PaymentCardListPresenter
}
