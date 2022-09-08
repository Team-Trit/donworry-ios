//
//  PaymentCardIconEditViewReactor.swift
//  App
//
//  Created by Chanhee Jeong on 2022/08/18.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum PaymentCardIconEditStep {
    case pop
    case paymentCardAmountEdit
    case paymentCardList
}

final class PaymentCardIconEditViewReactor: Reactor {
    
    typealias Space = PaymentCardModels.FetchCardList.Response.Space

    enum Action {
        case didTapBackButton
        case didTapNextButton
        case didTapCloseButton
        case fetchIcon(Int?)
    }

    enum Mutation {
        case routeTo(PaymentCardIconEditStep)
        case updateCategory(Int)
    }

    struct State {
        var space: Space
        var paymentCard: PaymentCardModels.PostCard.Request
        var isNextButtonEnabled: Bool  = false
        @Pulse var step: PaymentCardIconEditStep?
    }

    let initialState: State

    init(
        space: Space,
        paymentCard: PaymentCardModels.PostCard.Request
    ){
        self.initialState = .init(space: space, paymentCard: paymentCard)
    }
    

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .didTapBackButton:
                return .just(.routeTo(.pop))
            case .didTapNextButton:
                return .just(.routeTo(.paymentCardAmountEdit))
            case .didTapCloseButton:
                return .just(.routeTo(.paymentCardList))
            case .fetchIcon(let category):
                guard let category = category else { return .empty() }
                return .just(Mutation.updateCategory(category))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
             case .routeTo(let step):
                 newState.step = step
             case .updateCategory(let category):
                 newState.paymentCard.categoryID = category
                 if category > -1 {
                     newState.isNextButtonEnabled = true
                 } else {
                     newState.isNextButtonEnabled = false
                 }
         }
        return newState
    }
}
