//
//  AgreeTermViewReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/24.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import ReactorKit
import RxCocoa

enum AgreeTermStep {
    typealias SignUpModel = AuthModels.SignUp.Request
    case pop
    case home
    case confirmTerm(checkedTerms: [String], newUser: SignUpModel)
}

final class AgreeTermViewReactor: Reactor {
    typealias SignUpModel = AuthModels.SignUp.Request
    let dataSource: [String] = [
        "전체동의",
        "(필수) 만 14세 이상입니다.",
        "(필수) 돈워리 회원약관 및 이용약관 동의",
        "(필수) 개인정보처리방침"
    ]
    private var checkedTerms: [String] = .init(repeating: "", count: 5)
    
    enum Action {
        case backButtonPressed
        case checkButtonPressed(_ index: Int)
        case doneButtonPressed
    }
    
    enum Mutation {
        case toggleCheck(_ index: Int)
        case routeTo(step: AgreeTermStep)
    }
    
    struct State {
        var signUpModel: SignUpModel
        var isChecked: [Bool]
        @Pulse var step: AgreeTermStep?
    }
    
    let initialState: State
    
    init(signUpModel: SignUpModel) {
        self.initialState = State(signUpModel: signUpModel, isChecked:  [false, false, false, false])

    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonPressed:
            return .just(.routeTo(step: .pop))
            
        case let .checkButtonPressed(index):
            return .just(Mutation.toggleCheck(index))
            
        case .doneButtonPressed:
            let checked = checkedTerms.filter { $0 != "" }
            return .just(.routeTo(step: .confirmTerm(checkedTerms: checked, newUser: currentState.signUpModel)))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .toggleCheck(let index):
            if index == 0 {
                // 전체 동의
                if newState.isChecked.allSatisfy({ $0 }) {
                    newState.isChecked = [false, false, false, false]
                } else {
                    newState.isChecked = [true, true, true, true]
                }
            } else {
                // 개별 동의
                newState.isChecked[index].toggle()
                
                if newState.isChecked[1...3].allSatisfy({ $0 }) {
                    newState.isChecked[0] = true
                } else {
                    newState.isChecked[0] = false
                }
            }
            
            for i in 1...3 {
                if newState.isChecked[i] {
                    self.checkedTerms[i] = self.dataSource[i]
                } else {
                    self.checkedTerms[i] = ""
                }
            }
            
        case .routeTo(let step):
            newState.step = step
        }
        
        return newState
    }
}
