//
//  SplashViewReactor.swift
//  App
//
//  Created by Woody on 2022/09/14.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum SplashStep {
    case home
    case login
    case paymentCardList(SpaceModels.JoinSpace.Response)
}

final class SplashViewReactor: Reactor {

    enum Action {
        case splashEnd
    }

    enum Mutation {
        case error(Error)
        case routeTo(SplashStep)
    }

    struct State {
        var shareID: String?
        @Pulse var errorMessage: String?
        @Pulse var step: SplashStep?
    }

    let initialState: State

    init(
        shareID: String?,
        isUserLogginedUseCase: IsUserLogginedUseCase = IsUserLogginedUseCaseImpl(),
        joinSpaceUseCase: JoinSpaceUseCase = JoinSpaceUseCaseImpl()

    ) {
        self.initialState = State(shareID: shareID)
        self.isUserLogginedUseCase = isUserLogginedUseCase
        self.joinSpaceUseCase = joinSpaceUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .splashEnd:
            let isUserLoggined = isUserLogginedUseCase.isUserLoggined()
            let goToHome = (currentState.shareID == nil) && isUserLoggined

            if goToHome  {
                return .just(.routeTo(.home))
            } else if !isUserLoggined {
                return .just(.routeTo(.login))
            } else {
                return joinSpace().catch { .just(.error($0)) }

            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .error(let error):
            newState.errorMessage = error.toSpaceError()?.message
            newState.step = .home
        case .routeTo(let step):
            newState.step = step
        }
        return newState
    }

    private func joinSpace() -> Observable<Mutation> {
        if let shareID = currentState.shareID {
            return joinSpaceUseCase.joinSpace(shareID: shareID)
                .asObservable()
                .map { .routeTo(.paymentCardList($0)) }
        }
        return .just(.routeTo(.login))

    }

    private let isUserLogginedUseCase: IsUserLogginedUseCase
    private let joinSpaceUseCase: JoinSpaceUseCase
}
