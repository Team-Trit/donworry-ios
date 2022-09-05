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
    func fetchPaymentCardList(spaceID: Int) -> Observable<PaymentCardModels.FetchCardList.ResponseList>
}

protocol PaymentCardService {
    func fetchPaymentCardList(spaceID: Int) -> Observable<PaymentCardModels.FetchCardList.ResponseList>
}

final class PaymentCardServiceImpl: PaymentCardService {
    private let paymentCardRepository: PaymentCardRepository

    init(paymentCardRepository: PaymentCardRepository = PaymentCardRepositoryImpl()) {
        self.paymentCardRepository = paymentCardRepository
    }

    func fetchPaymentCardList(spaceID: Int) -> Observable<PaymentCardModels.FetchCardList.ResponseList> {
        paymentCardRepository.fetchPaymentCardList(spaceID: spaceID)
    }
}
