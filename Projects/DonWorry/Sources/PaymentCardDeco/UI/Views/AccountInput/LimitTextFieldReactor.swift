//
//  LimitTextFieldReactor.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

#warning("나중에 디자인시스템 공용컴포넌트로 교체예정")

import ReactorKit

final class LimitTextFieldReactor: Reactor {
    enum Action {
        case edit(String?, Int?)
    }
    
    enum Mutation {
        case editText(String, Int?)
    }
    
    struct State {
        var trimmedText: String
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(
            trimmedText: ""
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .edit(let text, let limit):
            guard let text = text else { return .empty() }
            return .just(Mutation.editText(text, limit), scheduler: MainScheduler.instance)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .editText(let text, let limit):
            state.trimmedText = limit != nil ? getTrimmedText(text, limit: limit!) : text
        }
        return state
    }
}

// MARK: - Helper Methods
extension LimitTextFieldReactor {
    private func getTrimmedText(_ text: String, limit: Int) -> String {
        if text.count > limit {
            let index = text.index(text.startIndex, offsetBy: limit)
            return String(text[..<index])
        }
        return text
    }
}
