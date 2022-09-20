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
        case viewDidDisappear
        case getSpace(Int)
        case didSelectSpace(at: Int, model: SpaceCellViewModel?)
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
        case updateSpace(Index, SpaceCellViewModel)
        case updateSpaceWithServer(Space)
        case setupTimer(Bool)
        case setupIsSpaceTapped(Bool)
        case routeTo(HomeStep)
    }

    struct State {
        var spaceViewModelList: [SpaceCellViewModel] // 정산방 뷰모델
        var sections: [Section] // 정산카드 뷰모델
        var selectedSpaceIndex: Int // 선택된 정산방 index
        var selectedSpaceViewModel: SpaceCellViewModel? // 선택된 정산방 ID
        var homeHeader: HeaderModel? // 헤더 뷰모델
        var timer: Disposable?
        var isSpaceTapped: Bool = false
        var isSpaceEmpty: Bool = false

        @Pulse var reloadWithScroll: Void? // 스크롤 있는 collectionView 업데이트
        @Pulse var reload: Void? // 주기적인 collectionView 업데이트
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
        self.initialState = .init(
            spaceViewModelList: [],
            sections: [.BillCardSection([])],
            selectedSpaceIndex: 0
        )

        self.presentationDelegateProxy.delegate = self
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .concat([
                requestUserAccount(),
                requestSpaceList(),
                .just(.setupTimer(true))
            ])
        case .viewDidDisappear:
            return .just(.setupTimer(false))
        case .getSpace(let spaceID):
            let updateSpaceWithServer = requestSpace(spaceID: spaceID)
            return updateSpaceWithServer
        case .didSelectSpace(let index, let spaceModel):
            guard let space = spaceModel else {
                return .error(SpaceError.undefined)
            }
            let updateSpace = Observable.just(Mutation.updateSpace(index, space))
            let updateSpaceWithServer = requestSpace(spaceID: space.id)
            return .concat([
                .just(.setupTimer(false)),
                .just(.setupIsSpaceTapped(true)),
                updateSpace,
                updateSpaceWithServer,
                .just(.setupIsSpaceTapped(false)),
                .just(.setupTimer(true))
            ])
        case .didTapAlarm:
            return .just(.routeTo(.alarm))
        case .didTapSearchButton:
            return .just(.routeTo(.joinSpace))
        case .didTapCreateSpaceButton:
            return .just(.routeTo(.spaceName))
        case .didTapProfileImage:
            return .just(.routeTo(.profile))
        case .didTapGiveBillCard(let paymentID):
            guard let selectedSpaceID = currentState.selectedSpaceViewModel?.id else {
                return .error(SpaceError.undefined)
            }
            return .just(.routeTo(.sentMoneyDetail(selectedSpaceID, paymentID)))
        case .didTapTakeBillCard:
            guard let selectedSpaceID = currentState.selectedSpaceViewModel?.id else {
                return .error(SpaceError.undefined)
            }
            return .just(.routeTo(.recievedMoneyDetail(selectedSpaceID)))
        case .didTapStateBillCard:
            guard let selectedSpace = currentState.selectedSpaceViewModel else {
                return .error(SpaceError.undefined)
            }
            return .just(.routeTo(.spaceList(selectedSpace.id, selectedSpace.adminID, selectedSpace.status.rawValue)))
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
        case .setupTimer(let direction):
            if direction {
                newState.timer = setupTimer()
            } else {
                newState.timer?.dispose()
            }
        case .updateSpaceList(let spaceList):
            if spaceList.isEmpty {
                newState.spaceViewModelList = []
                newState.sections = [.BillCardSection([])]
                newState.selectedSpaceViewModel = nil
                newState.isSpaceEmpty = true
                break
            }

            newState.isSpaceEmpty = false
            if currentState.selectedSpaceIndex < spaceList.count {
                let selectedSpace = spaceList[currentState.selectedSpaceIndex]
                newState.spaceViewModelList = homePresenter.formatSpaceCellListViewModel(spaceList: spaceList)
                newState.sections = homePresenter.formatSection(
                    isAllPaymentCompleted: selectedSpace.isAllPaymentCompleted,
                    space: selectedSpace
                )
                newState.selectedSpaceViewModel = homePresenter.formatSpaceCellViewModel(space: selectedSpace)
            }

            // 삭제하고 홈으로 돌아온 경우 선택된 정산방 index가 전체 정산방보다 큰 경우가 나옵니다.
            // 마지막 index인 정산방을 눌렀을 경우입니다. 이럴경우 마지막 정산방으로 이동합니다.
            if currentState.selectedSpaceIndex >= spaceList.count {
                let initialIndex = spaceList.count - 1 // 마지막 정산방
                newState.selectedSpaceIndex = initialIndex
                let selectedSpace = spaceList[initialIndex]
                newState.spaceViewModelList = homePresenter.formatSpaceCellListViewModel(spaceList: spaceList)
                newState.sections = homePresenter.formatSection(
                    isAllPaymentCompleted: selectedSpace.isAllPaymentCompleted,
                    space: selectedSpace
                )
                newState.selectedSpaceViewModel = homePresenter.formatSpaceCellViewModel(space: selectedSpace)
            }
            newState.reload = ()
        case .updateSpace(let index, let spaceModel):
            newState.selectedSpaceIndex = index
            newState.selectedSpaceViewModel = spaceModel
        case .updateSpaceWithServer(let space):
            if let index = newState.spaceViewModelList.firstIndex(where: { $0.id == space.id }) {
                newState.spaceViewModelList[index] = homePresenter.formatSpaceCellViewModel(space: space)
                newState.sections = homePresenter.formatSection(
                    isAllPaymentCompleted: space.isAllPaymentCompleted,
                    space: space
                )
                if currentState.isSpaceTapped {
                    newState.reloadWithScroll = ()
                } else {
                    newState.reload = ()
                }
            }
        case .setupIsSpaceTapped(let direction):
            newState.isSpaceTapped = direction
        case .routeTo(let step):
            newState.step = step
        }
        print(newState)
        return newState
    }

    private func requestLeave() -> Observable<Mutation> {
        guard let selectedSpace = currentState.selectedSpaceViewModel else {
            return .error(SpaceError.undefined)
        }
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

    private func requestSpace(spaceID: Int) -> Observable<Mutation> {
        spaceService.fetchSpace(request: .init(spaceID: spaceID))
            .map { Mutation.updateSpaceWithServer($0) }
    }

    private func setupTimer() -> Disposable {
        Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
            if let selectedSpaceID = self?.currentState.selectedSpaceViewModel?.id {
                self?.action.onNext(.getSpace(selectedSpaceID))
            }
        })
    }

    func presentationControllerDidDismiss() {}

    private let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    private let getUserAccountUseCase: GetUserAccountUseCase
    private let spaceService: SpaceService
    private let homePresenter: HomePresenter
}

