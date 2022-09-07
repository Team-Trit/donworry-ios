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

protocol PaymentCardRepository {
    func fetchPaymentCardList(spaceID: Int) -> Observable<PaymentCardModels.FetchCardList.Response>
    func joinPaymentCardList(ids:[Int]) -> Observable<String>
    func fetchPaymentCard(cardId: Int) -> Observable<PaymentCardModels.FetchCard.Response>
    func deletePaymentCardList(cardId: Int) -> Observable<String>
}

protocol PaymentCardService {
    func fetchPaymentCardList(spaceID: Int) -> Observable<PaymentCardModels.FetchCardList.Response>
    func joinPaymentCardList(ids:[Int]) -> Observable<String>
    func fetchPaymentCard(cardId: Int) -> Observable<PaymentCardModels.FetchCard.Response>
    func DeletePaymentCardList(cardId: Int) -> Observable<String>
}

final class PaymentCardServiceImpl: PaymentCardService {
    
    private let paymentCardRepository: PaymentCardRepository

    init(paymentCardRepository: PaymentCardRepository = PaymentCardRepositoryImpl()) {
        self.paymentCardRepository = paymentCardRepository
    }

    func fetchPaymentCardList(spaceID: Int) -> Observable<PaymentCardModels.FetchCardList.Response> {
        paymentCardRepository.fetchPaymentCardList(spaceID: spaceID)
    }
    func joinPaymentCardList(ids: [Int]) -> Observable<String> {
        paymentCardRepository.joinPaymentCardList(ids: ids)
    }
    func fetchPaymentCard(cardId: Int) -> Observable<PaymentCardModels.FetchCard.Response> {
        paymentCardRepository.fetchPaymentCard(cardId: cardId)
    }
    func DeletePaymentCardList(cardId: Int) -> Observable<String> {
        paymentCardRepository.deletePaymentCardList(cardId: cardId)
    }
}
