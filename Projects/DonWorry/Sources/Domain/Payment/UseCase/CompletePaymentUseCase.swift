//
//  CompletePaymentUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol CompletePaymentUseCase {
    func completePayment(request: PaymentModels.CompletePayment.Request) -> Observable<PaymentModels.CompletePayment.Response>
}

final class CompletePaymentUseCaseImpl: CompletePaymentUseCase {
    private let paymentRepository: PaymentRepository

    init(
        paymentRepository: PaymentRepository = PaymentRepositoryImpl()
    ) {
        self.paymentRepository = paymentRepository
    }

    func completePayment(request: PaymentModels.CompletePayment.Request) -> Observable<PaymentModels.CompletePayment.Response> {
        paymentRepository.patchPaymentsGiverIsCompleted(paymentID: request.paymentID)
    }
}
