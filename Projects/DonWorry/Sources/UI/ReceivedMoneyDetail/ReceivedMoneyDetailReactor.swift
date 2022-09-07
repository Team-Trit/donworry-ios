//
//  ReceivedMoneyDetailViewReactor.swift
//  App
//
//  Created by Woody on 2022/09/05.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

final class ReceivedMoneyDetailReactor: Reactor {
    typealias Response = PaymentModels.FetchTakerPaymentList.Response
    typealias Payment = Response.Payment
    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case setup(Response)
    }

    struct State {
        var spaceID: Int
        var currentStatus: Response?
        var payments: [RecievingCellViewModel] = []
    }

    let initialState: State

    init(
        spaceID: Int,
        getTakerPaymentListUseCase: GetTakerPaymentListUseCase = GetTakerPaymentListUseCaseImpl()
    ) {
        self.initialState = .init(spaceID: spaceID)
        self.getTakerPaymentListUseCase = getTakerPaymentListUseCase

    }

    func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .viewDidLoad:
             return requestTakerPayment().map { .setup($0) }
         }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
         case .setup(let response):
             newState.currentStatus = response
             newState.payments = response.payments.compactMap { [weak self] in
                 self?.formatTakerMoneyInfoViewModel(from: $0)
             }
         }
        return newState
    }

    private func requestTakerPayment() -> Observable<Response> {
        getTakerPaymentListUseCase.fetchTakerPaymentList(
            request: .init(spaceID: currentState.spaceID)
        )
    }

    private func formatTakerMoneyInfoViewModel(from entity: Payment) -> RecievingCellViewModel {
        return .init(
            name: entity.user.nickname,
            money: entity.amount,
            isCompleted: entity.isCompleted
        )
    }

    private func formatDate(from date: String) -> String {
        if let date = Formatter.fullDateFormatter.date(from: date) {
            return Formatter.mmddDateFormatter.string(from: date)
        }
        return "00/00"
    }


    private let getTakerPaymentListUseCase: GetTakerPaymentListUseCase
}
