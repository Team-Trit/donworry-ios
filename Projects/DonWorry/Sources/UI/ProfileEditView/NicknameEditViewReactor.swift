//
//  NicknameEditViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/06.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit

enum NicknameEditViewStep {
    case none
    case pop
}

final class NicknameEditViewReactor: Reactor {
    enum Action {
        case updateNickname(nickname: String)
        case doneButtonPressed
    }
    
    enum Mutation {
        case nicknameChanged(count: Int)
        case routeTo(step: NicknameEditViewStep)
    }
    
    struct State {
        @Pulse var isDoneButtonAvailable: Bool
        @Pulse var step: NicknameEditViewStep?
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(
            isDoneButtonAvailable: false
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateNickname(let nickname):
            return .just(Mutation.nicknameChanged(count: nickname.count))
            
        case .doneButtonPressed:
            // TODO: User 정보 수정 API Call
            return .just(Mutation.routeTo(step: .pop))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .nicknameChanged(let count):
            newState.isDoneButtonAvailable = count == 0 ? false : true
            
        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}
