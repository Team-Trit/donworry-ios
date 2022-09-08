//
//  NicknameEditViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/06.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Models
import ReactorKit

enum NicknameEditViewStep {
    case none
    case pop
}

final class NicknameEditViewReactor: Reactor {
    private let userService: UserService
    var user: User
    enum Action {
        case pressBackButton
        case updateNickname(nickname: String)
        case pressDoneButton
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
    
    init(userService: UserService) {
        self.userService = userService
        self.user = userService.fetchLocalUser()!
        self.initialState = State(
            isDoneButtonAvailable: false
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .pressBackButton:
            return .just(Mutation.routeTo(step: .pop))
            
        case .updateNickname(let nickname):
            user.nickName = nickname
            return .just(Mutation.nicknameChanged(count: nickname.count))
            
        case .pressDoneButton:
            return userService.updateUser(nickname: user.nickName,
                                  imgURL: nil,
                                  bank: nil,
                                  holder: nil,
                                  accountNumber: nil,
                                  isAgreeMarketing: nil)
            .map { _ in .routeTo(step: .pop) }
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
