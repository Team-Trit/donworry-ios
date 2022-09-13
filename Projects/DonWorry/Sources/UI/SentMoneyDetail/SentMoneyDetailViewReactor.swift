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

enum SentMoneyDetailStep {
    case moreDetail
}

final class SentMoneyDetailViewReactor : Reactor {
    typealias Response = PaymentModels.FetchGiverPayment.Response
    typealias Card = Response.Card
    typealias Payment = Response.Payment

    enum Action {
        case viewDidLoad
        case didTapSendButtton
        case didTapMoreDetailButton
    }

    enum Mutation {
        case setup(Response)
        case updateIsSent(Bool)
        case routeTo(SentMoneyDetailStep)
    }

    struct State {
        var spaceID: Int
        var paymentID: Int
        var isSent: Bool = false
        var currentStatus: Response?
        var totalAmount: Int = 0 // 다음 화면에서 필요
        var cards: [SentMoneyCellViewModel] = [] // 다음 화면에서 필요
        var payments: [DetailProgressCellViewModel] = [] // 다음 화면에서 필요

        @Pulse var toast: Void?
        @Pulse var step: SentMoneyDetailStep?
    }

    let initialState: State

    init(
        spaceID: Int,
        paymentID: Int,
        getGiverPaymentUseCase: GetGiverPaymentUseCase = GetGiverPaymentUseCaseImpl(),
        completePaymentUseCase: CompletePaymentUseCase = CompletePaymentUseCaseImpl()
    ) {
        self.initialState = .init(spaceID: spaceID, paymentID: paymentID)
        self.getGiverPaymentUseCase = getGiverPaymentUseCase
        self.completePaymentUseCase = completePaymentUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .viewDidLoad:
             let setup = requestGivierPayment()
             return setup
         case .didTapMoreDetailButton:
             return .just(.routeTo(.moreDetail))
         case .didTapSendButtton:
             let sendMoney = requestSendMoney()
             return sendMoney
         }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
         case .setup(let response):
             newState.currentStatus = response
             newState.totalAmount = response.amount
             newState.cards = response.cards.compactMap { [weak self] in
                 self?.formatGiveMoneyInfoViewModel(from: $0)
             }
             newState.payments = response.payments.compactMap { [weak self] in
                 self?.formatDetailProgressCellViewModel(from: $0, with: response.amount)
             }
             newState.isSent = response.isCompleted
         case .updateIsSent(let isSent):
             newState.isSent = isSent
             if isSent { newState.toast = () }
         case .routeTo(let step):
             newState.step = step
         }
        return newState
    }

    private func requestSendMoney() -> Observable<Mutation> {
        completePaymentUseCase.completePayment(request: .init(paymentID: currentState.paymentID)).map { _ in .updateIsSent(true) }

    }

    private func requestGivierPayment() -> Observable<Mutation> {
        getGiverPaymentUseCase.fetchGiverPayment(request: .init(spaceID: currentState.spaceID, paymentID: currentState.paymentID)).map { .setup($0) }
    }

    private func formatGiveMoneyInfoViewModel(from entity: Card) -> SentMoneyCellViewModel {
        return .init(
            name: entity.name,
            date: formatDate(from: entity.paymentDate),
            totalAmount: entity.totalAmount,
            totalUers: entity.cardJoinUserCount,
            myAmount: entity.amountPerUser
        )
    }

    private func formatDetailProgressCellViewModel(from entity: Payment, with amount: Int) -> DetailProgressCellViewModel {
        return .init(
            name: entity.takerNickname,
            myAmount: entity.amount,
            totalAmount: amount
        )
    }

    private func formatDate(from date: String) -> String {
        if let date = Formatter.fullDateFormatter.date(from: date) {
            return Formatter.mmddDateFormatter.string(from: date)
        }
        return "00/00"
    }


    private let getGiverPaymentUseCase: GetGiverPaymentUseCase
    private let completePaymentUseCase: CompletePaymentUseCase
}
