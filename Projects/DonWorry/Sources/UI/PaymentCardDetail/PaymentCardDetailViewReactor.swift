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
    case showImage(String)
}

final class PaymentCardDetailViewReactor: Reactor {
    typealias Response = PaymentCardModels.FetchCard.Response
    enum Action {
        case viewDidLoad
        case didTapBackButton
        case didTapBottomButton
        case imageCellButton(String)
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
        var spaceStatus: String
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
        spaceStatus: String,
        participatedUsers: [AttendanceCellViewModel],
        paymentCardService: PaymentCardService = PaymentCardServiceImpl(),
        userAccountService: UserAccountRepository = UserAccountRepositoryImpl()
    ) {
        self.initialState = .init(
            cardID: cardID,
            cardName: cardName,
            isCardAdmin: isCardAdmin,
            spaceStatus: spaceStatus,
            participatedUsers: participatedUsers,
            amount: 0,
            imgURLs: []
        )
        self.paymentCardService = paymentCardService
        self.userAccountService = userAccountService
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
         case .imageCellButton(let url):
             return .just(.routeTo(.showImage(url)))
         }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
         case .updateViewModel(let response):
             newState.amount = response.card.totalAmount
             newState.imgURLs = response.card.imgUrls
             let isParticipated = response.card.users.contains(where: { user in
                 user.id == userAccountService.fetchLocalUserAccount()?.id
             })
             newState.participatedUsers = response.card.users.map {
                 .init(id: $0.id, name: $0.nickname, imgURL: $0.imgURL)
             }
             newState.isParticipated = isParticipated
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

    private func judgeIsParticipated() -> Bool {
            return currentState.isParticipated ?? true
    }
    
    private func requestParticipate() -> Observable<Mutation> {
        return paymentCardService.joinOneCard(request: .init(cardID: currentState.cardID))
            .map { _ in .routeTo(.pop) }
    }

    private func requestDelete() -> Observable<Mutation> {
        return paymentCardService.deletePaymentCardList(cardId: currentState.cardID)
            .map { _ in .routeTo(.pop) }
    }

    private let paymentCardService: PaymentCardService
    private let userAccountService: UserAccountRepository
}
