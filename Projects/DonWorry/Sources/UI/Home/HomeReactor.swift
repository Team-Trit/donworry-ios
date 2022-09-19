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
    case joinSpace
    case recievedMoneyDetail(Int)
    case sentMoneyDetail(Int, Int)
    case alarm
    case profile
    case leaveAlertMessage // 확인메시지 알람창 -> 토스트
    case cantLeaveSpace // 오류메시지 알림창 -> 토스트
    case spaceList(Int, Int, String)
    case none
}

final class HomeReactor: Reactor, AdaptivePresentationControllerDelegate {
    typealias Section = BillCardSection
    typealias HeaderModel = HomeHeaderViewModel
    typealias SpaceList = [SpaceModels.Space]
    typealias Space = SpaceModels.Space
    typealias Index = Int

    enum Action {
        case viewWillAppear
        case didSelectSpace(at: Int)
        case didTapAlarm
        case didTapSearchButton
        case didTapCreateSpaceButton
        case didTapProfileImage
        case didTapGiveBillCard(Int)
        case didTapTakeBillCard
        case didTapStateBillCard
        case didTapLeaveBillCard
        case none
    }

    enum Mutation {
        case updateHomeHeader(User)
        case updateSpaceList(SpaceList)
        case updateSpace(Index)
        case updateSpaceWithServer(Space)
        case routeTo(HomeStep)
    }

    struct State {
        var spaceList: [Space] // 새로 서버를 불러오지 않기 때문에 뷰에서 들고있어야 하는 정보
        var spaceViewModelList: [SpaceCellViewModel] // 정산방 뷰모델
        var sections: [Section] // 정산카드 뷰모델
        var selectedSpaceIndex: Int // 선택된 정산방 index
        var homeHeader: HeaderModel? // 헤더 뷰모델

        @Pulse var step: HomeStep?
    }

    let initialState: State

    init(
        _ getUserAccountUseCase: GetUserAccountUseCase = GetUserAccountUseCaseImpl(),
        _ spaceService: SpaceService = SpaceServiceImpl(),
        _ homePresenter: HomePresenter = HomePresenterImpl()
    ) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.getUserAccountUseCase = getUserAccountUseCase
        self.spaceService = spaceService
        self.homePresenter = homePresenter
        self.initialState = .init(spaceList: [], spaceViewModelList: [], sections: [.BillCardSection([])], selectedSpaceIndex: 0)

        self.presentationDelegateProxy.delegate = self
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .concat([requestUserAccount(), requestSpaceList()])
        case .didSelectSpace(let index):
            let updateSpaceFirst = Observable.just(Mutation.updateSpace(index))
            let selectedSpaceID = currentState.spaceList[index].id
            let updateSpaceWithServer = spaceService.fetchSpace(request: .init(spaceID: selectedSpaceID)).map { Mutation.updateSpaceWithServer($0) }
            return .concat([updateSpaceFirst, updateSpaceWithServer])
        case .didTapAlarm:
            return .just(.routeTo(.alarm))
        case .didTapSearchButton:
            return .just(.routeTo(.joinSpace))
        case .didTapCreateSpaceButton:
            return .just(.routeTo(.spaceName))
        case .didTapProfileImage:
            return .just(.routeTo(.profile))
        case .didTapGiveBillCard(let paymentID):
            let selectedSpace = currentState.spaceList[currentState.selectedSpaceIndex]
            return .just(.routeTo(.sentMoneyDetail(selectedSpace.id, paymentID)))
        case .didTapTakeBillCard:
            let selectedSpace = currentState.spaceList[currentState.selectedSpaceIndex]
            return .just(.routeTo(.recievedMoneyDetail(selectedSpace.id)))
        case .didTapStateBillCard:
            let selectedSpace = currentState.spaceList[currentState.selectedSpaceIndex]
            return .just(.routeTo(.spaceList(selectedSpace.id, selectedSpace.adminID, selectedSpace.status)))
        case .didTapLeaveBillCard:
            return requestLeave()
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
            if spaceList.isEmpty {
                newState.spaceList = []
                newState.spaceViewModelList = []
                newState.sections = [.BillCardSection([])]
                newState.selectedSpaceIndex = -1
                break
            }

            if currentState.selectedSpaceIndex < spaceList.count {
                let selectedSpace = spaceList[currentState.selectedSpaceIndex]
                newState.spaceViewModelList = homePresenter.formatSpaceCellViewModel(
                    spaceList: spaceList,
                    selectedIndex: currentState.selectedSpaceIndex
                )
                newState.sections = homePresenter.formatSection(
                    isAllPaymentCompleted: selectedSpace.isAllPaymentCompleted,
                    payments: selectedSpace.payments,
                    isTaker: selectedSpace.isTaker
                )
                newState.spaceList = spaceList
            }

            // 삭제하고 홈으로 돌아온 경우 선택된 정산방 index가 전체 정산방보다 큰 경우가 나옵니다.
            // 마지막 index인 정산방을 눌렀을 경우입니다. 이럴경우 마지막 정산방으로 이동합니다.
            if currentState.selectedSpaceIndex >= spaceList.count {
                let initialIndex = spaceList.count - 1 // 마지막 정산방
                newState.selectedSpaceIndex = initialIndex
                let selectedSpace = spaceList[initialIndex]
                newState.spaceViewModelList = homePresenter.formatSpaceCellViewModel(
                    spaceList: spaceList,
                    selectedIndex: initialIndex
                )
                newState.sections = homePresenter.formatSection(
                    isAllPaymentCompleted: selectedSpace.isAllPaymentCompleted,
                    payments: selectedSpace.payments,
                    isTaker: selectedSpace.isTaker
                )
                newState.spaceList = spaceList
            }
        case .updateSpace(let index): // 셀이 눌렸을 때 리로드
            let selectedSpace = currentState.spaceList[index]
            newState.selectedSpaceIndex = index
            newState.spaceViewModelList = homePresenter.formatSpaceCellViewModel(
                spaceList: currentState.spaceList,
                selectedIndex: index
            )
            newState.sections = homePresenter.formatSection(
                isAllPaymentCompleted: selectedSpace.isAllPaymentCompleted,
                payments: selectedSpace.payments,
                isTaker: selectedSpace.isTaker
            )
        case .updateSpaceWithServer(let space):
            newState.spaceList[currentState.selectedSpaceIndex] = space
            newState.spaceViewModelList = homePresenter.formatSpaceCellViewModel(
                spaceList: currentState.spaceList,
                selectedIndex: currentState.selectedSpaceIndex
            )
            newState.sections = homePresenter.formatSection(
                isAllPaymentCompleted: space.isAllPaymentCompleted,
                payments: space.payments,
                isTaker: space.isTaker
            )
        case .routeTo(let step):
            newState.step = step
        }
        return newState
    }

    private func requestLeave() -> Observable<Mutation> {
        let selectedSpace = currentState.spaceList[currentState.selectedSpaceIndex]
        if selectedSpace.isAllPaymentCompleted {
            return spaceService.leaveSpaceInProgress(requeset: .init(spaceID: selectedSpace.id))
                .map { .updateSpaceList($0) }
        }
        return .just(.routeTo(.cantLeaveSpace))
    }

    private func requestSpaceList() -> Observable<Mutation> {
        spaceService.fetchSpaceList().map { .updateSpaceList($0) }
    }

    private func requestUserAccount() -> Observable<Mutation> {
        getUserAccountUseCase.getUserAccount().compactMap { $0 }.map { .updateHomeHeader($0) }
    }

    func presentationControllerDidDismiss() {
        print("presentationControllerDidDismiss")
    }

    private let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    private let getUserAccountUseCase: GetUserAccountUseCase
    private let spaceService: SpaceService
    private let homePresenter: HomePresenter
}

