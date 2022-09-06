//
//  PaymentCardDecoReactor.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/09/05.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import Models


enum PaymentCardDecoStep {
    case pop
    case paymentCardListView
    case completePaymentCardDeco
}

final class PaymentCardDecoReactor: Reactor {

    enum Action {
        case didTapBackButton
        case didTapCloseButton
        case didTapCompleteButton
    }

    enum Mutation {
        case routeTo(PaymentCardDecoStep)
    }

    struct State {
        var spaceId: Int
        var paymentCard: PaymentCardModels.PostCard.Request
        @Pulse var step: PaymentCardDecoStep?
    }

    let initialState: State

    init(
        spaceId: Int,
        paymentCard: PaymentCardModels.PostCard.Request,
        paymentCardService: PaymentCardService = PaymentCardServiceImpl()
    ){
        self.initialState = .init(spaceId: spaceId, paymentCard: paymentCard)
        self.paymentCardService = paymentCardService
    }
    

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        
        case .didTapBackButton:
            return .just(.routeTo(.pop))
            
        case .didTapCloseButton:
            return .just(.routeTo(.paymentCardListView))
             
        case .didTapCompleteButton:
            return paymentCardService.createPaymentCard(spaceID: 42, paymentCard: currentState.paymentCard)
                .map { _ in Mutation.routeTo(.completePaymentCardDeco)}
            
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
    
    private let paymentCardService: PaymentCardService
}
