//
//  SentMoneyDetailViewReactor.swift
//  App
//
//  Created by Woody on 2022/09/05.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

final class SentMoneyDetailViewReactor : Reactor {
    typealias Response = PaymentModels.FetchGiverPayment.Response
    typealias Card = Response.Card

    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case setup(Response)
    }

    struct State {
        var spaceID: Int
        var paymentID: Int
        var currentStatus: Response?
        var cards: [SendingMoneyInfoViewModel] = []
    }

    let initialState: State

    init(
        spaceID: Int,
        paymentID: Int,
        getGiverPaymentUseCase: GetGiverPaymentUseCase = GetGiverPaymentUseCaseImpl()
    ) {
        self.initialState = .init(spaceID: spaceID, paymentID: paymentID)
        self.getGiverPaymentUseCase = getGiverPaymentUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .viewDidLoad:
             return requestGivierPayment().map { .setup($0) }
         }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
         case .setup(let response):
             newState.currentStatus = response
             newState.cards = response.cards.map { formatGiveMoneyInfoViewModel(from: $0) }
         }
        return newState
    }

    private func requestGivierPayment() -> Observable<Response> {
        getGiverPaymentUseCase.fetchGiverPayment(
            request: .init(spaceID: currentState.spaceID, paymentID: currentState.paymentID)
        )
    }

    private func formatGiveMoneyInfoViewModel(from entity: Card) -> SendingMoneyInfoViewModel {
        return .init(
            name: entity.name,
            date: formatDate(from: entity.paymentDate),
            totalAmount: entity.totalAmount,
            totalUers: entity.cardJoinUserCount,
            myAmount: entity.amountPerUser
        )
    }

    private func formatDate(from date: String) -> String {
        if let date = Formatter.fullDateFormatter.date(from: date) {
            return Formatter.mmddDateFormatter.string(from: date)
        }
        return "00/00"
    }


    private let getGiverPaymentUseCase: GetGiverPaymentUseCase
}
