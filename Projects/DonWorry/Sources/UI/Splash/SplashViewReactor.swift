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

final class SplashViewReactor: Reactor {

    enum Action {
        case fetchUser
    }

    struct State {

    }

    let initialState: State = State()

    init() {}
}
