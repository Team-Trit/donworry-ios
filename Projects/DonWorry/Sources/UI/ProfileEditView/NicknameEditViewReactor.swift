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
    private let checkNicknameUseCase: CheckNicknameUseCase

    enum Action {
        case viewDidLoad
        case pressBackButton
        case updateNickname(nickname: String)
        case pressDoneButton
    }
    
    enum Mutation {
        case setup(Models.User)
        case updateNickname(nickname: String)
        case showToast(message: String)
        case routeTo(step: NicknameEditViewStep)
    }
    
    struct State {
        var user: Models.User
        @Pulse var isDoneButtonAvailable: Bool
        @Pulse var toast: String?
        @Pulse var step: NicknameEditViewStep?
    }
    
    let initialState: State

    init(
        getUserAccountUseCase: GetUserAccountUseCase = GetUserAccountUseCaseImpl(),
        updateNicknameUseCase: UpdateNicknameUseCase = UpdateNicknameUseCaseImpl(),
        checkNicknameUseCase: CheckNicknameUseCase = CheckNicknameUseCaseImpl()
    ) {
        self.getUserAccountUseCase = getUserAccountUseCase
        self.updateNicknameUseCase = updateNicknameUseCase
        self.checkNicknameUseCase = checkNicknameUseCase
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
            let nickname = currentState.user.nickName
            return checkNicknameUseCase.checkNickname(nickname: nickname)
                .flatMap { [weak self] response in
                    return self?.updateNicknameUseCase.updateNickname(nickname: nickname)
                        .map { Mutation.updateNickname(nickname: $0.nickName) } ?? .just(.showToast(message: "닉네임 수정을 실패했습니다."))
                }.catch { error in
                    guard let error = error as? AuthError else { return .empty() }
                    switch error {
                    case .duplicatedNickname:
                        return .just(.showToast(message: "현재 사용 중인 닉네임입니다."))

                    default:
                        return .empty()
                    }
                }
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
            
        case .showToast(let message):
            newState.toast = message

        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}
