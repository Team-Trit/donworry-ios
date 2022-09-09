//
//  ConfirmTermViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/24.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit

final class ConfirmTermViewReactor: Reactor {
    let checkedTerms: [String]
    private var user: SignUpUserModel
    private let userService: UserService
    
    enum Action {
        case confirmButtonPressed
    }
    
    enum Mutation {
        case completeLogin
        case routeTo(step: DonworryStep)
    }
    
    struct State {
        @Pulse var step: DonworryStep?
    }
    
    let initialState: State
    
    init(checkedTerms: [String], newUser: SignUpUserModel, userService: UserService) {
        self.checkedTerms = checkedTerms
        self.user = newUser
        self.userService = userService
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .confirmButtonPressed:
            switch user.provider {
            case .APPLE:
                return userService.registerUserWithApple(provider: user.provider.rawValue,
                                                         nickname: user.nickname,
                                                         email: user.email,
                                                         bank: user.bank,
                                                         bankNumber: user.bankNumber,
                                                         bankHolder: user.bankHolder,
                                                         isAgreeMarketing: user.isAgreeMarketing,
                                                         identityToken: user.token)
                .map { _ in .completeLogin }
                
            case .GOOGLE:
                // TODO: Google API 호출
                return .empty()
                
            case .KAKAO:
                return userService.registerUserWithKakao(provider: user.provider.rawValue,
                                                         nickname: user.nickname,
                                                         email: user.email,
                                                         bank: user.bank,
                                                         bankNumber: user.bankNumber,
                                                         bankHolder: user.bankHolder,
                                                         isAgreeMarketing: user.isAgreeMarketing,
                                                         accessToken: user.token)
                .map { _ in .completeLogin }
                
            default:
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .completeLogin:
            break
            
        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}
