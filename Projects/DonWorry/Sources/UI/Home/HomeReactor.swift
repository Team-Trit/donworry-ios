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
    typealias SpaceList = [Entity.Space]
    typealias Space = Entity.Space
    typealias Index = Int

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
        case updatePaymentRoomList(SpaceList)
        case updatePaymentRoom(Index)
        case leavePaymentRoom(Index)
        case routeTo(HomeStep)
    }

    struct State {
        var spaceList: [Space]
        var spaceViewModelList: [PaymentRoomCellViewModel]
        var sections: [Section]
        var selectedSpaceIndex: Int
        var homeHeader: HeaderModel?
        var selectedSpace: Space?

        @Pulse var step: HomeStep?
    }

    let initialState: State

    init(
        _ getUserAccountUseCase: GetUserAccountUseCase = GetUserAccountUseCaseImpl(),
        _ paymentRoomService: PaymentRoomService = PaymentRoomServiceImpl(),
        _ homePresenter: HomePresenter = HomePresenterImpl()
    ) {
        self.getUserAccountUseCase = getUserAccountUseCase
        self.paymentRoomService = paymentRoomService
        self.homePresenter = homePresenter
        self.initialState = .init(spaceList: [], spaceViewModelList: [], sections: [.BillCardSection([])], selectedSpaceIndex: 0)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setup:
            return .concat([
                getUserAccountUseCase.getUserAccount().compactMap { $0 }.map { .updateHomeHeader($0) },
                paymentRoomService.fetchPaymentRoomList().map { .updatePaymentRoomList($0) }
            ])
        case .didSelectPaymentRoom(let index):
            return .just(.updatePaymentRoom(index))
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
            newState.homeHeader = .init(imageURL: user.image, nickName: user.nickName)
        case .updatePaymentRoomList(let spaceList):
            newState.spaceList = spaceList
            if let selectedSpace = spaceList.first {
                newState.selectedSpace = selectedSpace
                newState.spaceViewModelList = homePresenter.formatSection(
                    spaceList: spaceList,
                    selectedIndex: 0
                )
                newState.sections = homePresenter.formatSection(
                    payments: selectedSpace.payments,
                    isTaker: selectedSpace.isTaker
                )
            }
        case .updatePaymentRoom(let index):
            let selectedSpace = currentState.spaceList[index]
            newState.selectedSpace = selectedSpace
            newState.selectedSpaceIndex = index
            newState.spaceViewModelList = homePresenter.formatSection(
                spaceList: currentState.spaceList,
                selectedIndex: index
            )
            newState.sections = homePresenter.formatSection(
                payments: selectedSpace.payments,
                isTaker: selectedSpace.isTaker
            )
        case .routeTo(let step):
            newState.step = step
        case .leavePaymentRoom(_):
            break
        }
        return newState
    }

    private let getUserAccountUseCase: GetUserAccountUseCase
    private let paymentRoomService: PaymentRoomService
    private let homePresenter: HomePresenter
}

