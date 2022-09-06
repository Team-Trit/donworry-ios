//
//  GetTakerPaymentListUseCase.swift
//  DonWorryTests
//
//  Created by Woody on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol GetTakerPaymentListUseCase {
    func fetchTakerPaymentList(request: PaymentModels.FetchTakerPaymentList.Request) -> Observable<PaymentModels.FetchTakerPaymentList.Response>
}

final class GetTakerPaymentListUseCaseImpl: GetTakerPaymentListUseCase {
    private let paymentRepository: PaymentRepository

    init(
        paymentRepository: PaymentRepository = PaymentRepositoryImpl()
    ) {
        self.paymentRepository = paymentRepository
    }
    func fetchTakerPaymentList(request: PaymentModels.FetchTakerPaymentList.Request) -> Observable<PaymentModels.FetchTakerPaymentList.Response> {
        paymentRepository.fetchTakerPaymentList(spaceID: request.spaceID)
    }
}
