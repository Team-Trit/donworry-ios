//
//  ReceivedMoneyDetailViewReactor.swift
//  App
//
//  Created by Woody on 2022/09/05.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

final class ReceivedMoneyDetailReactor: Reactor {

    enum Action {
        // actiom cases
    }

    enum Mutation {
        // mutation cases
    }

    struct State {
        var payments: [RecievingCellViewModel] = []
    }

    let initialState: State

    init() {
        self.initialState = .init()
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
