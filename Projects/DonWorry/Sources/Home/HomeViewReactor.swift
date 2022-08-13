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

final class HomeViewReactor: Reactor {
    typealias Section = BillCardSection
    typealias HeaderModel = HomeHeaderViewModel
    enum Action {
        case setup
        case didSelectPaymentRoom(at: Int)
        case didTapAlarm
        case didTapSearchButton
        case didTapCreatePaymentRoomButton
        case didTapProfileImage
    }

    enum Mutation {
        case updateLoading(Bool)
        case updateHomeHeader(User)
        case updatePaymentRoom(Int)
        case updatePaymentRoomList([PaymentRoom])
    }

    struct State {
        var homeHeader: HeaderModel?
        var user: User?
        var isLoading: Bool = false
        var selectedPaymentRoomIndex: Int = 0
        var paymentRoomList: [PaymentRoom] = []
        var sections: [Section] = [.BillCardSection([])]
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
                .just(.updateLoading(true)),
                self.userUseCase.fetchUser().compactMap { .updateHomeHeader($0) },
                self.paymentRoomUseCase.fetchPaymentRoomList().compactMap { .updatePaymentRoomList($0) },
                .just(.updateLoading(false))
            ])
        case .didSelectPaymentRoom(let index):
            return Observable.concat([
                .just(.updatePaymentRoom(index))
            ])
        case .didTapAlarm:
            break
        case .didTapSearchButton:
            break
        case .didTapCreatePaymentRoomButton:
            break
        case .didTapProfileImage:
            break
        }
        return .just(.updateLoading(false))
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
        case .updateLoading(let loading):
            newState.isLoading = loading
        case .updatePaymentRoomList(let paymentRoomList):
            newState.paymentRoomList = paymentRoomList
            newState.sections = homePresenter.formatSection(
                from: paymentRoomList,
                with: currentState.selectedPaymentRoomIndex,
                user: currentState.user!
            )
        }
        return newState
    }

    private let userUseCase: UserUseCase
    private let paymentRoomUseCase: PaymentRoomUseCase
    private let homePresenter: HomePresenter
}

