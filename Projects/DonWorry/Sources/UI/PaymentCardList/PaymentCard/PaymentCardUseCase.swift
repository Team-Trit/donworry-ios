//
//  PaymentCardUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift
import Models

protocol PaymentCardRepository {}

protocol PaymentCardUseCase {
    func fetchPaymentCardList() -> Observable<[PaymentCard]>
}

final class PaymentCardUseCaseImpl: PaymentCardUseCase {

    init(
        _ paymentCardRepository: PaymentCardRepository
    ) {
        self.paymentCardRepository = paymentCardRepository
    }

    func fetchPaymentCardList() -> Observable<[PaymentCard]> {
        return .just([.dummyPaymentCard1, .dummyPaymentCard2, .dummyPaymentCard3])
    }



    private let paymentCardRepository: PaymentCardRepository
}
