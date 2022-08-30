//
//  HomeViewReactor.swift
//  App
//
//  Created by Woody on 2022/08/08.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import Models

enum HomeStep {
    case editRoom
    case enterRoom
    case recievedMoneyDetail
    case sentMoneyDetail
    case alert
    case profile
    case paymentCardList
    case none
}

final class HomeReactor: Reactor {
    typealias Section = BillCardSection
    typealias HeaderModel = HomeHeaderViewModel
    enum Action {
        case setup
        case didSelectPaymentRoom(at: Int)
        case didTapAlarm
        case didTapSearchButton
        case didTapCreatePaymentRoomButton
        case didTapProfileImage
        case didTapGiveBillCard
        case didTapTakeBillCard
        case didTapStateBillCard
        case didTapLeaveBillCard(Int)
        case none
    }

    enum Mutation {
        case updateHomeHeader(User)
        case updatePaymentRoom(Int)
        case updatePaymentRoomList([PaymentRoom])
        case leavePaymentRoom(Int)
        case routeTo(HomeStep)
    }

    struct State {
        var homeHeader: HeaderModel?
        var user: User?
        var selectedPaymentRoomIndex: Int = 0
        var paymentRoomList: [PaymentRoom] = []
        var sections: [Section] = [.BillCardSection([])]

        @Pulse var step: HomeStep?
    }

    let initialState = State()

    init(
        _ paymentRoomUseCase: PaymentRoomUseCase = PaymentRoomUseCaseImpl(),
        _ userUseCase: UserUseCase = UserUseCaseImpl(),
        _ homePresenter: HomePresenter = HomePresenterImpl()
    ) {
        self.userUseCase = userUseCase
        self.paymentRoomUseCase = paymentRoomUseCase
        self.homePresenter = homePresenter
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setup:
            return Observable.concat([
                self.userUseCase.fetchUser().compactMap { .updateHomeHeader($0) },
                self.paymentRoomUseCase.fetchPaymentRoomList().compactMap { .updatePaymentRoomList($0) }
            ])
        case .didSelectPaymentRoom(let index):
            return Observable.concat([
                .just(.updatePaymentRoom(index))
            ])
        case .didTapAlarm:
            return .just(.routeTo(.alert))
        case .didTapSearchButton:
            return .just(.routeTo(.enterRoom))
        case .didTapCreatePaymentRoomButton:
            return .just(.routeTo(.editRoom))
        case .didTapProfileImage:
            return .just(.routeTo(.profile))
        case .didTapGiveBillCard:
            return .just(.routeTo(.sentMoneyDetail))
        case .didTapTakeBillCard:
            return .just(.routeTo(.recievedMoneyDetail))
        case .didTapStateBillCard:
            return .just(.routeTo(.paymentCardList))
        case .didTapLeaveBillCard(let index):
            return .concat([
                .just(.leavePaymentRoom(index))
            ])
        case .none:
            return .just(.routeTo(.none))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateHomeHeader(let user):
            newState.homeHeader = homePresenter.formHomeHeader(from: user)
            newState.user = user
        case .updatePaymentRoom(let index):
            newState.selectedPaymentRoomIndex = index
            newState.sections = homePresenter.formatSection(
                from: currentState.paymentRoomList,
                with: index,
                user: currentState.user!
            )
        case .updatePaymentRoomList(let paymentRoomList):
            newState.paymentRoomList = paymentRoomList
            newState.sections = homePresenter.formatSection(
                from: paymentRoomList,
                with: currentState.selectedPaymentRoomIndex,
                user: currentState.user!
            )
        case .routeTo(let step):
            newState.step = step
        case .leavePaymentRoom(_):
            break
        }
        print(newState)
        return newState
    }

    private let userUseCase: UserUseCase
    private let paymentRoomUseCase: PaymentRoomUseCase
    private let homePresenter: HomePresenter
}

