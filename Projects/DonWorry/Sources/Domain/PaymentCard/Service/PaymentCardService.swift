//
//  PaymentCardService.swift
//  DonWorryTests
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift
import Models

protocol PaymentCardService {
    func fetchPaymentCardList(spaceID: Int) -> Observable<PaymentCardModels.FetchCardList.Response>
    func joinCards(request: PaymentCardModels.JoinCard.Request) -> Observable<PaymentCardModels.Empty.Response>
    func joinOneCard(request: PaymentCardModels.JoinOneCard.Request) -> Observable<PaymentCardModels.Empty.Response>
    func createCard(request: PaymentCardModels.CreateCard.Request) -> Observable<PaymentCardModels.Empty.Response>
    func fetchPaymentCard(cardId: Int) -> Observable<PaymentCardModels.FetchCard.Response>
    func deletePaymentCardList(cardId: Int) -> Observable<PaymentCardModels.Empty.Response>
    func putEditPaymentCardAmount(id: Int, totalAmount: Int) -> Observable<PaymentCardModels.PutCard.Response>

}

final class PaymentCardServiceImpl: PaymentCardService {
    
    private let paymentCardRepository: PaymentCardRepository
    private let userAccountRepository: UserAccountRepository

    init(
        userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl(),
        paymentCardRepository: PaymentCardRepository = PaymentCardRepositoryImpl()
    ) {
        self.userAccountRepository = userAccountRepository
        self.paymentCardRepository = paymentCardRepository
    }

    func fetchPaymentCardList(spaceID: Int) -> Observable<PaymentCardModels.FetchCardList.Response> {
        paymentCardRepository.fetchPaymentCardList(spaceID: spaceID)
            .compactMap { [weak self] in
                self?.compareUserIsParticipatedInPaymentCard(response: $0)
            }
    }

    func createCard(request: PaymentCardModels.CreateCard.Request) -> Observable<PaymentCardModels.Empty.Response> {
        paymentCardRepository.createCard(request: request)
    }

    // 유저가 정산 카드에 참여했는지 안했는지 판단해주는 메소드
    // 참여했다면 isUserParticipatedIn을 True로 변환 res
    private func compareUserIsParticipatedInPaymentCard(
        response: PaymentCardModels.FetchCardList.Response
    ) -> PaymentCardModels.FetchCardList.Response {
        guard let userAccount = userAccountRepository.fetchLocalUserAccount() else { return response }
        return .init(
            isAllPaymentCompleted: response.isAllPaymentCompleted,
            space: response.space,
            spaceJoinUsers: response.spaceJoinUsers,
            cards: response.cards.map { c in
                    .init(
                        id: c.id,
                        cardJoinUserCount: c.cardJoinUserCount,
                        name: c.name,
                        totalAmount: c.totalAmount,
                        bgColor: c.bgColor,
                        paymentDate: c.paymentDate,
                        category: c.category,
                        account: c.account,
                        taker: c.taker,
                        givers: c.givers,
                        isUserParticipatedIn: c.givers.contains { $0.id == userAccount.id } || (c.taker.id == userAccount.id)
                    )
            })
    }

    func joinCards(request: PaymentCardModels.JoinCard.Request) -> Observable<PaymentCardModels.Empty.Response> {
        paymentCardRepository.joinCards(request: request)
    }
    func fetchPaymentCard(cardId: Int) -> Observable<PaymentCardModels.FetchCard.Response> {
        paymentCardRepository.fetchPaymentCard(cardId: cardId)
    }
    func deletePaymentCardList(cardId: Int) -> Observable<PaymentCardModels.Empty.Response> {
        paymentCardRepository.deletePaymentCardList(cardId: cardId)
    }
    func putEditPaymentCardAmount(id: Int, totalAmount: Int) -> Observable<PaymentCardModels.PutCard.Response> {
        paymentCardRepository.putEditPaymentCard(id: id, totalAmount: totalAmount)
    }
    func joinOneCard(request: PaymentCardModels.JoinOneCard.Request) -> Observable<PaymentCardModels.Empty.Response> {
        paymentCardRepository.joinOneCard(request: request)
    }
}
