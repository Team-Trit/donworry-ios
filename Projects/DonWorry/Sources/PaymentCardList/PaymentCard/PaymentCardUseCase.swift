//
//  PaymentCardUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

protocol PaymentCardRepository {}

protocol PaymentCardUseCase {}

final class PaymentCardUseCaseImpl: PaymentCardUseCase {

    init(
        _ paymentCardRepository: PaymentCardRepository
    ) {
        self.paymentCardRepository = paymentCardRepository
    }

    private let paymentCardRepository: PaymentCardRepository
}
