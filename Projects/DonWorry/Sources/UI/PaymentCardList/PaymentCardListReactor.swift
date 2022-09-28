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
import RxRelay

enum PaymentCardListStep {
    typealias IsCardAdmin = Bool

    case pop
    case paymentCardDetail(PaymentCardCellViewModel, IsCardAdmin, String)
    case actionSheet(Bool)
    case nameEdit
    case addPaymentCard
    case participate
    case none
}

final class PaymentCardListReactor: Reactor {
    typealias Section = PaymentCardSection
    typealias PaymentCardListInformation = PaymentCardModels.FetchCardList.Response
    typealias PaymentCardList = [PaymentCardModels.FetchCardList.Response.PaymentCard]
    typealias Space = PaymentCardModels.FetchCardList.Response.Space
    typealias Status = SpaceModels.StartPaymentAlogrithm.Request.Status
    typealias User = PaymentCardModels.FetchCardList.Response.PaymentCard.User

    enum Action {
        case viewWillAppear
        case viewDidDisappear
        case getPaymentStatus
        case didTapStartPaymentAlgorithmButton
        case didTapBackButton
        case didTapParticipatedButton
        case didTapPaymentCard(PaymentCardCellViewModel)
        case didTapOptionButton
        case didTapAddPaymentCard
        case routeToNameEdit
        case didTapLeaveButton
    }

    enum Mutation {
        case initializeState(PaymentCardListInformation)
        case initializeIsUserAdmin(Bool)
        case setupTimer(Bool)
        case routeTo(PaymentCardListStep)
        case error(Error?)
    }

    struct State {
        var space: Space
        var paymentCardListViewModel: [PaymentCardCellViewModel] = []
        var sections: [PaymentCardSection] = []
        var canLeaveSpace: Bool = true
        var isUserAdmin: Bool = false
        var spaceJoinUsers: [User] = []
        var timer: Disposable?

        @Pulse var error: Error?
        @Pulse var step: PaymentCardListStep?
    }

    let initialState: State
    init(
        spaceID: Int, adminID: Int, status: String,
        spaceService: SpaceService = SpaceServiceImpl(),
        judgeSpaceAdminUseCase: JudgeSpaceAdminUseCase = JudgeSpaceAdminUseCaseImpl(),
        paymentCardService: PaymentCardService = PaymentCardServiceImpl(),
        paymentCardListPresenter: PaymentCardListPresenter = PaymentCardPresenterImpl()
    ) {
        self.initialState = .init(space: .init(id: spaceID, adminID: adminID, title: "", status: status, shareID: ""))
        self.spaceService = spaceService
        self.judgeSpaceAdminUseCase = judgeSpaceAdminUseCase
        self.paymentCardService = paymentCardService
        self.paymentCardListPresenter =  paymentCardListPresenter
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let isUserAdmin = requestIsUserSpaceAdmin()
            let paymentCardListInformation = requestPaymentCardListInformation()
            let startTimer = Observable.just(Mutation.setupTimer(true))
            return .concat([isUserAdmin, paymentCardListInformation, startTimer])
        case .viewDidDisappear:
            return .just(.setupTimer(false))
        case .getPaymentStatus:
            return requestPaymentCardListInformation()
        case .didTapStartPaymentAlgorithmButton:
            return requestStartPaymentAlgorithm()
        case .didTapBackButton:
            return .just(.routeTo(.pop))
        case .didTapPaymentCard(let card):
            let detailCard = requestIsUserCardAdmin(card: card)
            return detailCard
        case .didTapOptionButton:
            return .just(.routeTo(.actionSheet(currentState.isUserAdmin)))
        case .routeToNameEdit:
            return .just(.routeTo(.nameEdit))
        case .didTapLeaveButton:
            let leaveAct = requestLeaveSpace()
            return leaveAct
        case .didTapAddPaymentCard:
            return .just(.routeTo(.addPaymentCard))
        case .didTapParticipatedButton:
            return .just(.routeTo(.participate))
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
        case .setupTimer(let direction):
            if direction {
                newState.timer = setupTimer()
            } else {
                newState.timer?.dispose()
            }
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

    private func requestIsUserSpaceAdmin() -> Observable<Mutation> {
        judgeSpaceAdminUseCase.judgeUserIsSpaceAdmin(spaceAdminID: currentState.space.adminID).map { .initializeIsUserAdmin($0) }
    }

    private func requestIsUserCardAdmin(card: PaymentCardCellViewModel) -> Observable<Mutation> {
        judgeSpaceAdminUseCase.judgeUserIsCardAdmin(cardAdminID: card.payer.id)
            .map { .routeTo(.paymentCardDetail(card, $0, self.currentState.space.status)) }
    }
    private func requestPaymentCardListInformation() -> Observable<Mutation> {
        paymentCardService.fetchPaymentCardList(spaceID: currentState.space.id)
            .map { .initializeState($0)  }
    }

    private func requestLeaveSpace() -> Observable<Mutation> {
        if !currentState.canLeaveSpace { return .just(.error(PaymentCardListViewError.cantLeaveUntilPaymentsCompleted)) }
        return spaceService.leaveSpace(
            request: .init(
                isStatusOpen: currentState.space.status == "OPEN",
                isAdmin: currentState.space.adminID,
                spaceID: currentState.space.id
            )
        )
        .map { _ in  .routeTo(.pop) }
    }

    private func setupTimer() -> Disposable {
        Observable<Int>.interval(.seconds(3), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            self?.action.onNext(.getPaymentStatus)
        })
    }
    
    private let spaceService: SpaceService
    private let judgeSpaceAdminUseCase: JudgeSpaceAdminUseCase
    private let paymentCardService: PaymentCardService
    private let paymentCardListPresenter: PaymentCardListPresenter
}
