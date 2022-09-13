//
//  ParticipatePaymentCardViewReactor.swift
//  App
//
//  Created by Hankyu Lee on 2022/08/27.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum ParticipatePaymentCardStep {
    case dismiss
}

final class ParticipatePaymentCardViewReactor: Reactor {

    enum Action {
        case didTapCancelButton
        case didTapCancelSelectButton
        case didTapSelectAllButton
        case didTapAttendanceButton
        case selectCard(ParticipateCellViewModel)
    }

    enum Mutation {
        case updateCard(ParticipateCellViewModel)
        case resetCardList
        case selectAllCard
        case toast(Error)
        case routeTo(ParticipatePaymentCardStep)
    }

    struct State {
        var currentCardIDList: [Int]
        var cardList: [ParticipateCellViewModel]

        @Pulse var step: ParticipatePaymentCardStep?
        @Pulse var toast: String?
    }

    let initialState: State

    init(
        participatedCards: [ParticipateCellViewModel],
        paymentCardService: PaymentCardService = PaymentCardServiceImpl(),
        getUserAccountUseCase: GetUserAccountUseCase = GetUserAccountUseCaseImpl()
    ) {
        self.initialState = .init(
            currentCardIDList: participatedCards.filter { $0.isSelected }.map { $0.id },
            cardList: participatedCards
        )
        self.paymentCardService = paymentCardService
        self.getUserAccountUseCase = getUserAccountUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapCancelButton:
            return .just(.routeTo(.dismiss))
        case .didTapCancelSelectButton:
            let selectCard = getUserAccountUseCase.compareIsUserList(
                ids: currentState.cardList.filter { $0.isSelected}.map { $0.payer.id }
            ).map { Mutation.resetCardList }
                .catch { .just(.toast($0)) }
            return selectCard
        case .didTapSelectAllButton:
            return .just(.selectAllCard)
        case .didTapAttendanceButton:
            let participate = requestParticipate()
            return participate
        case .selectCard(let cardModel):
            let selectCard = getUserAccountUseCase.compareIsUser(id: cardModel.payer.id)
                .map { Mutation.updateCard(cardModel) }
                .catch { .just(.toast($0)) }
            return selectCard
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateCard(let cardModel):
            if let firstIndex = newState.cardList.firstIndex(where: { $0.id == cardModel.id}) {
                newState.cardList[firstIndex].isSelected.toggle()
            }
        case .resetCardList:
            newState.cardList = updateAllCardList(false)
        case .selectAllCard:
            newState.cardList = updateAllCardList(true)
        case .routeTo(let step):
            newState.step = step
        case .toast(let error):
            newState.toast = error.toUserError()?.message
        }
        return newState
    }

    private func updateAllCardList(_ direction: Bool) -> [ParticipateCellViewModel] {
        return currentState.cardList.map {
            .init(
                id: $0.id,
                isSelected: direction,
                name: $0.name,
                categoryName: $0.categoryName,
                amount: $0.amount,
                payer: $0.payer,
                date: $0.date,
                bgColor: $0.bgColor
            )
        }
    }

    private func requestParticipate() -> Observable<Mutation> {
        paymentCardService.joinCards(
            request: .init(
                currentCardIds: currentState.currentCardIDList,
                selectedCardIds: currentState.cardList.filter { $0.isSelected }.map { $0.id }
            )
        ).map { _ in .routeTo(.dismiss) }
    }

    private let paymentCardService: PaymentCardService
    private let getUserAccountUseCase: GetUserAccountUseCase
}
