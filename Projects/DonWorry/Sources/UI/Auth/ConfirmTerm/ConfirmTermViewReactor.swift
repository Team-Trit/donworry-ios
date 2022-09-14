//
//  ConfirmTermViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/24.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit

enum ConfirmTermStep {
    case home
    case none
}

final class ConfirmTermViewReactor: Reactor {
    typealias SignUpModel = AuthModels.SignUp.Request
    
    enum Action {
        case confirmButtonPressed
    }
    
    enum Mutation {
        case routeTo(ConfirmTermStep)
    }
    
    struct State {
        var signUpModel: SignUpModel
        var checkedTerms: [String]

        @Pulse var step: ConfirmTermStep?
    }
    
    let initialState: State
    
    init(
        signUpModel: SignUpModel,
        checkedTerms: [String],
        signUpUseCase: SignUpUseCase = SignUpUseCaseImpl()
    ) {
        self.initialState = State(
            signUpModel: signUpModel, checkedTerms: checkedTerms
        )
        self.signUpUseCase = signUpUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .confirmButtonPressed:
            return signUpUseCase.signUp(request: currentState.signUpModel)
                .map { _ in .routeTo(.home) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .routeTo(let step):
            newState.step = step
        }

        return newState
    }

    private let signUpUseCase: SignUpUseCase
}
