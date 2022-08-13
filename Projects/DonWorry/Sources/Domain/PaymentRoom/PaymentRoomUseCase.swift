//
//  PaymentRoomUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift
import Models

public protocol PaymentRoomRepository {
    func fetchPaymentRoomList() -> Observable<[PaymentRoom]>
}

protocol PaymentRoomUseCase {
    func fetchPaymentRoomList() -> Observable<[PaymentRoom]>
}

final class PaymentRoomUseCaseImpl: PaymentRoomUseCase {

    init(
        _ paymentRoomRepository: PaymentRoomRepository = FakePaymentRoomRepositoryImpl()) {
            self.paymentRoomRepository = paymentRoomRepository
        }

    func fetchPaymentRoomList() -> Observable<[PaymentRoom]> {
        return paymentRoomRepository.fetchPaymentRoomList().asObservable()
    }

    private let paymentRoomRepository: PaymentRoomRepository
}
