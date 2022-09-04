//
//  EditRoomNameViewReactor.swift
//  App
//
//  Created by 임영후 on 2022/08/25.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

final class EditRoomNameViewReactor: Reactor {

    enum Action {
    }

    enum Mutation {
    }

    struct State {
    }

    let initialState: State = State()

    init() {

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
