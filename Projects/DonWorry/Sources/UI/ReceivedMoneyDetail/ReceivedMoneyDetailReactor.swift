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
    typealias FetchTakerPaymentListResponse = PaymentModels.FetchTakerPaymentList.Response
    typealias PushAlarmsRequest = AlarmModels.PushPayments.Request
    typealias FetchTakerPaymentListPayment = FetchTakerPaymentListResponse.Payment
    typealias PushAlarmsPayment = PushAlarmsRequest.Payment

    enum Action {
        case viewDidLoad
        case didTapBottomButton
    }

    enum Mutation {
        case setup(FetchTakerPaymentListResponse)
        case toast(String)
    }

    struct State {
        var spaceID: Int
        var currentStatus: FetchTakerPaymentListResponse?
        var payments: [RecievingCellViewModel] = []

        @Pulse var toast: String?
    }

    let initialState: State

    init(
        spaceID: Int,
        alarmService: AlarmService = AlarmServiceImpl(),
        getTakerPaymentListUseCase: GetTakerPaymentListUseCase = GetTakerPaymentListUseCaseImpl()
    ) {
        self.initialState = .init(spaceID: spaceID)
        self.alarmService = alarmService
        self.getTakerPaymentListUseCase = getTakerPaymentListUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return requestTakerPayment().map { .setup($0) }
        case .didTapBottomButton:
            return sendAlarms()
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
        case .toast(let message):
            newState.toast = message
        }
        return newState
    }

    private func requestTakerPayment() -> Observable<FetchTakerPaymentListResponse> {
        getTakerPaymentListUseCase.fetchTakerPaymentList(
            request: .init(spaceID: currentState.spaceID)
        )
    }

    private func sendAlarms() -> Observable<Mutation> {
        alarmService.pushPayments(
            request: .init(
                spaceID: currentState.spaceID,
                payments: createRequest()
            )
        ).map { _ in Mutation.toast("미정산자들에게 재촉완료") }
    }

    private func createRequest() -> [PushAlarmsPayment] {
        return currentState.payments
            .filter { $0.isCompleted == false }
            .map { PushAlarmsPayment(id: $0.id, receiverID: $0.id, isCompleted: $0.isCompleted) }
    }
    private func formatTakerMoneyInfoViewModel(from entity: FetchTakerPaymentListPayment) -> RecievingCellViewModel {
        .init(
            id: entity.id,
            name: entity.user.nickname,
            money: entity.amount,
            receiverID: entity.user.id,
            isCompleted: entity.isCompleted,
            imgURL: entity.user.imgURL
        )
    }
    private func formatDate(from date: String) -> String {
        if let date = Formatter.fullDateFormatter.date(from: date) {
            return Formatter.mmddDateFormatter.string(from: date)
        }
        return "00/00"
    }

    private let alarmService: AlarmService
    private let getTakerPaymentListUseCase: GetTakerPaymentListUseCase
}
