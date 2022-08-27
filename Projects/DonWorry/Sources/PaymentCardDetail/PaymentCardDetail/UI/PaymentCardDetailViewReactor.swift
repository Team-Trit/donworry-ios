//
//  PaymentCardDetailViewReactor.swift
//  App
//
//  Created by Hankyu Lee on 2022/08/27.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

final class PaymentCardDetailViewReactor: Reactor {

    enum Action {
        // actiom cases
    }

    enum Mutation {
        // mutation cases
    }

    struct State {
        //state
    }

    let initialState: State = State()

    init() {
        // init state initialState = State(...)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        // switch action {
        // }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        // switch mutation {
        // }
        return newState
    }
}
