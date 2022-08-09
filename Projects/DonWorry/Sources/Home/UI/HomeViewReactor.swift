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
        case updatePaymentRoom(PaymentCard)
        case updatePaymentRoomList(PaymentRoom)
    }

    struct State {
        #warning("초기값 변경하기")
        var homeHeader: HomeHeaderViewModel = .init(
            imageURL: User.dummyUser2.image,
            nickName: User.dummyUser2.nickName)
        var isLoading: Bool = false

        // MARK: 초기값 바꾸면서 수정하기
        var paymentRoomList: [PaymentRoomCellViewModel] = [
            .init(title: "MC2 돈워리", isSelect: true),
            .init(title: "떱떱해", isSelect: false),
        ]
        // MARK: 값 바꿔가며 테스트하기
        var paymentCardSection: [PaymentCardCollectionViewSection] = [
            .CircleSection([.StatePaymentCard,

                            // MARK: 받을 돈 카드 테스트
                            .TakePaymentCard([Transfer(giver: User.dummyUser2, taker: User.dummyUser1, amount: 37000, isCompleted: false),
                                              Transfer(giver: User.dummyUser3, taker: User.dummyUser1, amount: 37000, isCompleted: false),
                                              Transfer(giver: User.dummyUser4, taker: User.dummyUser1, amount: 30000, isCompleted: false)]),

                            .LeavePaymentCard])
        ]

                                             //
    }

    let initialState = State()

    init(_ homeRepository: HomeRepository = FakeHomeRepositoryImpl()) {
        self.homeRepository = homeRepository
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setup:
            return Observable.concat([
                .just(.updateLoading(true)),
                .just(.updateHomeHeader),
//                self.homeRepository.fetchPaymentRoomList().map { .update},
                .just(.updateLoading(false))
            ])
        case .didSelectPaymentRoom(let index):
            return Observable.concat([
                .just(.updateLoading(true)),
//                self.homeRepository.fetchPaymentRoom(with: index),
                .just(.updateLoading(false)),
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

         case .updatePaymentRoom:
             newState.paymentCardSection = [
                .CircleSection([.StatePaymentCard,

                                // MARK: 받을 돈 카드 테스트
                                .TakePaymentCard([Transfer(giver: User.dummyUser2, taker: User.dummyUser1, amount: 37000, isCompleted: false),
                                                  Transfer(giver: User.dummyUser3, taker: User.dummyUser1, amount: 37000, isCompleted: false),
                                                  Transfer(giver: User.dummyUser4, taker: User.dummyUser1, amount: 30000, isCompleted: false)]),
                                .LeavePaymentCard])
             ]

         case .updateLoading(let loading):
             newState.isLoading = loading
         case .updatePaymentRoomList(_):
             return state
         }
        return newState
    }

    private let homeRepository: HomeRepository
}

