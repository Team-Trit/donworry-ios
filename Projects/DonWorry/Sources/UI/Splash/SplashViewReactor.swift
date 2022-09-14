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
}

final class SplashViewReactor: Reactor {

    enum Action {
        case judgeUserIsLogined
    }

    struct State {
        @Pulse var step: SplashStep?
    }

    let initialState: State = State()

    init(isUserLogginedUseCase: IsUserLogginedUseCase = IsUserLogginedUseCaseImpl()) {
        self.isUserLogginedUseCase = isUserLogginedUseCase
    }

    func reduce(state: State, mutation: Action) -> State {
        var newState = state
        switch mutation {
        case .judgeUserIsLogined:
            if isUserLogginedUseCase.isUserLoggined() {
                newState.step = .home
            } else {
                newState.step = .login
            }
        }
        return newState
    }

    private let isUserLogginedUseCase: IsUserLogginedUseCase
}
