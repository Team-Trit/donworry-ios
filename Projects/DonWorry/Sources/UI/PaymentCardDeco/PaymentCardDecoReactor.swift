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
    var images: [UIImage] = []
}

final class PaymentCardDecoReactor: Reactor {

    typealias Space = PaymentCardModels.FetchCardList.Response.Space
    
    enum Action {
        case didTapBackButton
        case didTapCloseButton
        case didTapCompleteButton(CardViewModel)
        case didTapDate(Date)
    }

    enum Mutation {
        case routeTo(PaymentCardDecoStep)
        case updatePayDate(Date)
    }

    struct State {
        var space: Space
        var paymentCard: PaymentCardModels.PostCard.Request
        @Pulse var step: PaymentCardDecoStep?
    }

    let initialState: State

    init(
        space: Space,
        paymentCard: PaymentCardModels.PostCard.Request,
        paymentCardService: PaymentCardService = PaymentCardServiceImpl()
    ){
        self.initialState = .init(space: space, paymentCard: paymentCard)
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
            return paymentCardService.createPaymentCard(spaceID: currentState.space.id,
                                                        paymentCard: PaymentCardModels.PostCard.Request(
                                                            spaceID: currentState.space.id,
                                                            categoryID: card.categoryID,
                                                            bank: cardVM.bank,
                                                            number: cardVM.number,
                                                            holder: cardVM.holder,
                                                            name: card.name,
                                                            totalAmount: card.totalAmount,
                                                            bgColor: cardVM.cardColor.rawValue,
                                                            paymentDate: 
                                                            cardVM.payDate.modifyDateForNetworking()
                                                            
                                                        )
            )
                .map { _ in Mutation.routeTo(.completePaymentCardDeco)}
         
        case .didTapDate(let date):
            return .just(Mutation.updatePayDate(date))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
         case .routeTo(let step):
             newState.step = step
         case .updatePayDate(let date):
             // 2022-09-06T17:25:20.715Z"
             newState.paymentCard.paymentDate = date.getDateToString(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
         }
        return newState
    }
    
    private let paymentCardService: PaymentCardService
}
