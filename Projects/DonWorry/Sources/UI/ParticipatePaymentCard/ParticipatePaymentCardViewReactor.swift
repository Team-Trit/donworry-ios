//
//  ParticipatePaymentCardViewReactor.swift
//  App
//
//  Created by Hankyu Lee on 2022/08/27.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum ParticipatePaymentCardStep {
    case dismiss
}

final class ParticipatePaymentCardViewReactor: Reactor {

    enum Action {
        case selectCard
        case didTapParticipateButton
    }

    enum Mutation {
        case routeTo(ParticipatePaymentCardStep)
    }

    struct State {

        @Pulse var step: ParticipatePaymentCardStep?
    }

    let initialState: State = State()

    init() {
        // init state initialState = State(...)
    }

//    func mutate(action: Action) -> Observable<Mutation> {
//        // switch action {
//        // }
//    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        // switch mutation {
        // }
        return newState
    }
}
