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
import UIKit

enum PaymentCardDecoStep {
    case pop
    case paymentCardListView
    case completePaymentCardDeco
}

struct CardViewModel {
    var cardColor: CardColor = .pink
    var payDate: Date = Date()
    var bank: String = ""
    var holder: String = ""
    var number: String = ""
    var images: [UIImage?] = []
}

final class PaymentCardDecoReactor: Reactor {

    typealias Space = PaymentCardModels.FetchCardList.Response.Space
    
    enum Action {
        case didTapBackButton
        case didTapCloseButton
        case didTapCompleteButton(CardViewModel)
    }

    enum Mutation {
        case routeTo(PaymentCardDecoStep)
        case setLoading(Bool)
    }

    struct State {
        var isLoading: Bool = false
        var paymentCard: PaymentCardModels.CreateCard.Request
        @Pulse var step: PaymentCardDecoStep?
    }

    let initialState: State

    init(
        paymentCard: PaymentCardModels.CreateCard.Request,
        paymentCardService: PaymentCardService = PaymentCardServiceImpl()
    ){
        self.initialState = .init(paymentCard: paymentCard)
        self.paymentCardService = paymentCardService
    }
    

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        
        case .didTapBackButton:
            return .just(.routeTo(.pop))
            
        case .didTapCloseButton:
            return .just(.routeTo(.paymentCardListView))
             
        case .didTapCompleteButton(let cardVM):
            
            let card = currentState.paymentCard
//            let createCard =  paymentCardService
//                                .map { response -> Mutation in
//                                    return Mutation.routeTo(.completePaymentCardDeco)
//                                }
                                
//            return createCar
            return .just(.routeTo(.pop))

        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
             case .routeTo(let step):
                 newState.step = step
             case .setLoading(let isLoading):
                 newState.isLoading = isLoading
         
         }
        return newState
    }
//    private func createCard() -> Observable<Mutation> {
//        paymentCardService
//    }
    private let paymentCardService: PaymentCardService
}
