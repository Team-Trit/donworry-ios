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
        case updateHomeHeader
        case updatePaymentRoom(Int)
        case updatePaymentRoomList([PaymentRoom])
    }

    struct State {
        var homeHeader: HomeHeaderViewModel = .init(
            imageURL: User.dummyUser1.image,
            nickName: User.dummyUser1.nickName)
        var isLoading: Bool = false
        var selectedPaymentRoomIndex: Int = 0
        var paymentRoomList: [PaymentRoom] = []
        var sections: [Section] = [.BillCardSection([])]
    }

    let initialState = State()

    init(_ homeRepository: HomeRepository = FakeHomeRepositoryImpl(),
         _ homePresenter: HomePresenter = HomePresenterImpl(),
         _ user: User = .dummyUser1) {
        self.homeRepository = homeRepository
        self.homePresenter = homePresenter
        self.user = user
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setup:
            return Observable.concat([
                .just(.updateLoading(true)),
                .just(.updateHomeHeader),
                self.homeRepository.fetchPaymentRoomList().map { .updatePaymentRoomList($0) },
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
        return .just(.updateHomeHeader)
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
         case .updateHomeHeader:
             newState = state

         case .updatePaymentRoom(let index):
             newState.selectedPaymentRoomIndex = index
             newState.sections = homePresenter.formatSection(
                from: currentState.paymentRoomList,
                with: currentState.selectedPaymentRoomIndex,
                user: user
             )
         case .updateLoading(let loading):
             newState.isLoading = loading
         case .updatePaymentRoomList(let paymentRoomList):
             newState.paymentRoomList = paymentRoomList
             newState.sections = homePresenter.formatSection(
                from: paymentRoomList,
                with: currentState.selectedPaymentRoomIndex,
                user: user
             )
         }
        return newState
    }

    private let user: User
    private let homeRepository: HomeRepository
    private let homePresenter: HomePresenter
}

