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
    private let getUserAccountUseCase: GetUserAccountUseCase
    private let updateNicknameUseCase: UpdateNicknameUseCase

    enum Action {
        case viewDidLoad
        case pressBackButton
        case updateNickname(nickname: String)
        case pressDoneButton
    }
    
    enum Mutation {
        case setup(Models.User)
        case updateNickname(nickname: String)
        case routeTo(step: NicknameEditViewStep)
    }
    
    struct State {
        var user: Models.User
        @Pulse var isDoneButtonAvailable: Bool
        @Pulse var step: NicknameEditViewStep?
    }
    
    let initialState: State

    init(
        getUserAccountUseCase: GetUserAccountUseCase = GetUserAccountUseCaseImpl(),
        updateNicknameUseCase: UpdateNicknameUseCase = UpdateNicknameUseCaseImpl()
    ) {
        self.getUserAccountUseCase = getUserAccountUseCase
        self.updateNicknameUseCase = updateNicknameUseCase
        self.initialState = State(
            user: User(id: -1, nickName: "", bankAccount: BankAccount(bank: "", accountHolderName: "", accountNumber: ""), image: ""),
            isDoneButtonAvailable: false
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return getUserAccountUseCase.getUserAccount()
                .map { user in
                    guard let user = user else { return .routeTo(step: .pop) }
                    return .setup(user)
                }
            
        case .pressBackButton:
            return .just(Mutation.routeTo(step: .pop))
            
        case .updateNickname(let nickname):
            return .just(.updateNickname(nickname: nickname))
            
        case .pressDoneButton:
            return updateNicknameUseCase.updateNickname(nickname: currentState.user.nickName)
                .map { _ in .routeTo(step: .pop) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setup(let user):
            newState.user = user
            
        case .updateNickname(let nickname):
            newState.user.nickName = nickname
            newState.isDoneButtonAvailable = nickname.count == 0 ? false : true
            
        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}
