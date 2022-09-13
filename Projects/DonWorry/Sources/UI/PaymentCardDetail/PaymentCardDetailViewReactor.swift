//
//  PaymentCardDetailViewReactor.swift
//  App
//
//  Created by Hankyu Lee on 2022/08/27.
//  Updated by Woody on 2022/09/13.
//
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum PaymentCardDetailStep {
    case pop
    case editAmount
}

final class PaymentCardDetailViewReactor: Reactor {
    typealias Response = PaymentCardModels.FetchCard.Response
    enum Action {
        case viewDidLoad
        case didTapBackButton
        case didTapBottomButton
    }

    enum Mutation {
//        case updateCardName(String)
//        case updateIsCardAdmin(Bool)
//        case updateParticipatedUsers([AttendanceCellViewModel])
        case updateViewModel(Response)
        case routeTo(PaymentCardDetailStep)
    }

    struct State {
        var cardID: Int
        var cardName: String
        var isCardAdmin: Bool
        var participatedUsers: [AttendanceCellViewModel]
        var amount: Int
        var isParticipated: Bool?
        var imgURLs: [String?]
        @Pulse var step: PaymentCardDetailStep?
    }

    let initialState: State

    init(
        cardID: Int,
        cardName: String,
        isCardAdmin: Bool,
        participatedUsers: [AttendanceCellViewModel],
        paymentCardService: PaymentCardService = PaymentCardServiceImpl()
    ) {
        self.initialState = .init(
            cardID: cardID,
            cardName: cardName,
            isCardAdmin: isCardAdmin,
            participatedUsers: participatedUsers,
            amount: 0,
            imgURLs: []
        )
        self.paymentCardService = paymentCardService
    }

    func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .viewDidLoad:
             let cardInfo = requestCardDetails()
             return cardInfo
         case .didTapBackButton:
             return .just(.routeTo(.pop))
         case .didTapBottomButton:
             let result = judgeIsAdmin()
             return result
         }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
         case .updateViewModel(let response):
             newState.amount = response.card.totalAmount
             newState.imgURLs = response.card.imgUrls
             newState.participatedUsers = response.card.users.map {
                 .init(id: $0.id, name: $0.nickname, imgURL: $0.imgURL)
             }
         case .routeTo(let step):
             newState.step = step
         }
        return newState
    }

    private func requestCardDetails() -> Observable<Mutation> {
        paymentCardService.fetchPaymentCard(cardId: currentState.cardID)
            .map { Mutation.updateViewModel($0) }
    }

    private func judgeIsAdmin() -> Observable<Mutation> {
        if currentState.isCardAdmin {
            return requestDelete()
        } else {
            return requestParticipate()
        }
    }

    private func requestParticipate() -> Observable<Mutation> {
        // TODO: API 요청한 상태
        return paymentCardService.DeletePaymentCardList(cardId: currentState.cardID)
            .map { _ in .routeTo(.pop) }
    }

    private func requestDelete() -> Observable<Mutation> {
        return paymentCardService.DeletePaymentCardList(cardId: currentState.cardID)
            .map { _ in .routeTo(.pop) }
    }

    private let paymentCardService: PaymentCardService
}
