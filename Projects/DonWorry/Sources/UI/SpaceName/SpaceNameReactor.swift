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
import Models

enum SpaceNameStep {
    case pop
    case cardList
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
    }

    enum Mutation {
        case setup
        case routeTo(SpaceNameStep)
    }

    struct State {
        var title: String?
        var placeHolderText: String?
        var type: RoomNameEditViewType

        @Pulse var step: SpaceNameStep?
    }

    let initialState: State

    init(type: RoomNameEditViewType) {
        self.initialState = State(type: type)
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
                return .just(.routeTo(.cardList))
            }
        case .didTapBackButton:
            return .just(.routeTo(.pop))
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
         }
        return newState
    }
}
