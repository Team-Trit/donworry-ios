//
//  EnterRoomViewReactor.swift
//  App
//
//  Created by 임영후 on 2022/08/24.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum JoinSpaceStep {
    case dismiss
    case paymentCardList(SpaceModels.JoinSpace.Response)
}
final class JoinSpaceReactor: Reactor {

    enum Action {
        case didTapDismissButton
        case didTapNextButton
        case typeTextField(String)
    }

    enum Mutation {
        case changeSharedID(String)
        case routeTo(JoinSpaceStep)
        case occurError(Error)
    }

    struct State {
        var sharedID: String = ""
        @Pulse var step: JoinSpaceStep?
        @Pulse var error: String?
    }

    let initialState: State

    init(spaceService: SpaceService = SpaceServiceImpl()) {
        self.spaceService = spaceService
        self.initialState = .init()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .typeTextField(let sharedID):
            return .just(.changeSharedID(sharedID))
        case .didTapDismissButton:
            return .just(.routeTo(.dismiss))
        case .didTapNextButton:
            let joinSpace = joinSpace()
            return joinSpace.catch { error in .just(.occurError(error))}
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .changeSharedID(let sharedID):
            newState.sharedID = sharedID
        case .routeTo(let step):
            newState.step = step
        case .occurError(let error):
            newState.error = error.toSpaceError()?.message
        }
        return newState
    }

    func joinSpace() -> Observable<Mutation> {
        spaceService.joinSpace(shareID: currentState.sharedID)
            .asObservable()
            .map { .routeTo(.paymentCardList($0)) }
    }

    private func errorMessage(error: Error) -> String? {
        return error.toSpaceError()?.message
    }

    private let spaceService: SpaceService
}
