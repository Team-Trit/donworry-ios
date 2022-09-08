//
//  GetGiverPaymentUseCase.swift
//  DonWorryTests
//
//  Created by Woody on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol GetGiverPaymentUseCase {
    func fetchGiverPayment(request: PaymentModels.FetchGiverPayment.Request) -> Observable<PaymentModels.FetchGiverPayment.Response>
}

final class GetGiverPaymentUseCaseImpl: GetGiverPaymentUseCase {
    private let paymentRepository: PaymentRepository

    init(
        paymentRepository: PaymentRepository = PaymentRepositoryImpl()
    ) {
        self.paymentRepository = paymentRepository
    }

    func fetchGiverPayment(request: PaymentModels.FetchGiverPayment.Request) -> Observable<PaymentModels.FetchGiverPayment.Response> {
        paymentRepository.fetchGiverPayment(
            spaceID: request.spaceID,
            paymentID: request.paymentID
        )
    }
}
