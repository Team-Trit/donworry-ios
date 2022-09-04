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
    case spaceName
    case enterRoom
    case recievedMoneyDetail
    case sentMoneyDetail
    case alert
    case profile
    case spaceList
    case none
}

final class HomeReactor: Reactor {
    typealias Section = BillCardSection
    typealias HeaderModel = HomeHeaderViewModel
    typealias SpaceList = [SpaceModels.FetchSpaceList.Space]
    typealias Space = SpaceModels.FetchSpaceList.Space
    typealias Index = Int

    enum Action {
        case setup
        case didSelectSpace(at: Int)
        case didTapAlarm
        case didTapSearchButton
        case didTapCreateSpaceButton
        case didTapProfileImage
        case didTapGiveBillCard
        case didTapTakeBillCard
        case didTapStateBillCard
        case didTapLeaveBillCard(Int)
        case none
    }

    enum Mutation {
        case updateHomeHeader(User)
        case updateSpaceList(SpaceList)
        case updateSpace(Index)
        case leaveSpace(Index)
        case routeTo(HomeStep)
    }

    struct State {
        var spaceList: [Space] // 새로 서버를 불러오지 않기 때문에 뷰에서 들고있어야 하는 정보
        var spaceViewModelList: [SpaceCellViewModel] // 정산방 뷰모델
        var sections: [Section] // 정산카드 뷰모델
        var selectedSpaceIndex: Int // 선택된 정산방 index
        var beforeSelectedSpaceIndex: Int
        var homeHeader: HeaderModel? // 헤더 뷰모델

        @Pulse var reload: Void?
        @Pulse var step: HomeStep?
    }

    let initialState: State

    init(
        _ getUserAccountUseCase: GetUserAccountUseCase = GetUserAccountUseCaseImpl(),
        _ SpaceService: SpaceService = SpaceServiceImpl(),
        _ homePresenter: HomePresenter = HomePresenterImpl()
    ) {
        self.getUserAccountUseCase = getUserAccountUseCase
        self.SpaceService = SpaceService
        self.homePresenter = homePresenter
        self.initialState = .init(spaceList: [], spaceViewModelList: [], sections: [.BillCardSection([])], selectedSpaceIndex: 0, beforeSelectedSpaceIndex: 0)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setup:
            return .concat([
                getUserAccountUseCase.getUserAccount().compactMap { $0 }.map { .updateHomeHeader($0) },
                SpaceService.fetchSpaceList().map { .updateSpaceList($0) }
            ])
        case .didSelectSpace(let index):
            return .just(.updateSpace(index))
        case .didTapAlarm:
            return .just(.routeTo(.alert))
        case .didTapSearchButton:
            return .just(.routeTo(.enterRoom))
        case .didTapCreateSpaceButton:
            return .just(.routeTo(.spaceName))
        case .didTapProfileImage:
            return .just(.routeTo(.profile))
        case .didTapGiveBillCard:
            return .just(.routeTo(.sentMoneyDetail))
        case .didTapTakeBillCard:
            return .just(.routeTo(.recievedMoneyDetail))
        case .didTapStateBillCard:
            return .just(.routeTo(.spaceList))
        case .didTapLeaveBillCard(let index):
            return .concat([
                .just(.leaveSpace(index))
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
        case .updateSpaceList(let spaceList):
            if let selectedSpace = spaceList.first {
                newState.spaceViewModelList = homePresenter.formatSection(
                    spaceList: spaceList,
                    selectedIndex: 0
                )
                newState.sections = homePresenter.formatSection(
                    payments: selectedSpace.payments,
                    isTaker: selectedSpace.isTaker
                )
                newState.spaceList = spaceList
                newState.reload = ()
            }
        case .updateSpace(let index):
            let selectedSpace = currentState.spaceList[index]
            newState.selectedSpaceIndex = index
            newState.beforeSelectedSpaceIndex = currentState.selectedSpaceIndex
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
        case .leaveSpace(_):
            break
        }
        return newState
    }

    private let getUserAccountUseCase: GetUserAccountUseCase
    private let SpaceService: SpaceService
    private let homePresenter: HomePresenter
}

