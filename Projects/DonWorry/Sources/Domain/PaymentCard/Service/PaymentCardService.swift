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
    func fetchPaymentCardList(spaceID: Int) -> Observable<[PaymentCard]>
}

protocol PaymentCardService {
    typealias PaymentCardList = [PaymentCard]
    func fetchPaymentCardList(spaceID: Int) -> Observable<[PaymentCard]>
}

final class PaymentCardServiceImpl: PaymentCardService {
    private let paymentCardRepository: PaymentCardRepository

    init(paymentCardRepository: PaymentCardRepository = PaymentCardRepositoryImpl()) {
        self.paymentCardRepository = paymentCardRepository
    }

    func fetchPaymentCardList(spaceID: Int) -> Observable<[PaymentCard]> {
        paymentCardRepository.fetchPaymentCardList(spaceID: spaceID)
    }
}
