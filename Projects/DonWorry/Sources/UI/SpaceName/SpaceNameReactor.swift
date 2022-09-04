//
//  SpaceNameReactor.swift
//  App
//
//  Created by 임영후 on 2022/08/25.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum SpaceNameStep {
    case pop
    case cardList(SpaceModels.CreateSpace.Response)
}

final class SpaceNameReactor: Reactor {
    enum RoomNameEditViewType {
        case create //default
        case rename
    }

    enum Action {
        case viewDidLoad
        case didTapButton
        case didTapBackButton
        case typeTextField(String)
    }

    enum Mutation {
        case setup
        case routeTo(SpaceNameStep)
        case changeSpaceName(String)
    }

    struct State {
        var title: String?
        var placeHolderText: String?
        var spaceName: String = ""
        var type: RoomNameEditViewType

        @Pulse var step: SpaceNameStep?
    }

    let initialState: State

    init(
        type: RoomNameEditViewType,
        spaceService: SpaceService = SpaceServiceImpl()
    ) {
        self.initialState = State(type: type)
        self.spaceService = spaceService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.setup)
        case .didTapButton:
            switch currentState.type {
            case .rename:
                return .just(.routeTo(.pop))
            case .create:
                return spaceService.createSpace(title: currentState.spaceName)
                    .map { .routeTo(.cardList($0)) }
            }
        case .didTapBackButton:
            return .just(.routeTo(.pop))
        case .typeTextField(let name):
            return .just(.changeSpaceName(name))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
         case .setup:
             switch currentState.type {
             case .create:
                 newState.title = "정산방을\n생성해볼까요?"
                 newState.placeHolderText = "정산방 이름을 입력하세요."
             case .rename:
                 newState.title = "정산방\n이름을 설정해주세요"
                 newState.placeHolderText = "ex) MC2 번개모임"
             }
         case .routeTo(let step):
             newState.step = step
         case .changeSpaceName(let name):
             newState.spaceName = name
         }
        return newState
    }

    private let spaceService: SpaceService
}
