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
        var sections: [PaymentCardSection] = []
        var timer: Disposable?
        // MARK: 이후에 수정할 조건들
        var isUserAdmin: Bool = false // 다음 화면으로 넘기는 필요한 정보
        var canLeaveSpace: Bool = true // 정산방 나가기 조건
        var cantStartAlgorithm: Bool = false // 정산시작 버튼에 대한 조건
        var paymentCardCount: Int = 0 // 정산시작 버튼에 대한 조건
        @Pulse var error: Error?
        @Pulse var step: PaymentCardListStep?
    }

    let initialState: State
    init(
        spaceID: Int, adminID: Int, status: String,
        spaceService: SpaceService = SpaceServiceImpl(),
        judgeSpaceAdminUseCase: JudgeSpaceAdminUseCase = JudgeSpaceAdminUseCaseImpl(),
        paymentCardService: PaymentCardService = PaymentCardServiceImpl(),
        paymentCardListPresenter: PaymentCardListPresenter = PaymentCardListPresenterImpl()
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
        case .initializeState(let response):
            newState.space = response.space
            newState.sections = paymentCardListPresenter.formatSection(with: response)
            newState.canLeaveSpace = response.isAllPaymentCompleted
            newState.cantStartAlgorithm = paymentCardListPresenter.canAlgorithmStart(with: response.cards)
            newState.paymentCardCount = response.cards.count
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
        if currentState.cantStartAlgorithm {
            return .just(.error(PaymentCardListViewError.cantStartAlgorithm))
        }
        if currentState.paymentCardCount <= 0 {
            return .just(.error(PaymentCardListViewError.noPaymentCardList))
        }
        let space = currentState.space
        let requestAlgorithm = spaceService.startPaymentAlogrithm(request: .init(id: space.id, status: .progress))
        return requestAlgorithm.map { _ in .routeTo(.pop) }
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
        if !currentState.canLeaveSpace {
            return .just(.error(PaymentCardListViewError.cantLeaveUntilPaymentsCompleted))
        }
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
