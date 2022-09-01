//
//  PaymentRoomService.swift
//  DonWorryTests
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol PaymentRoomService {
    func fetchPaymentRoomList() -> Observable<[Entity.Space]>
}

final class PaymentRoomServiceImpl: PaymentRoomService {
    private let paymentRoomRepository: PaymentRoomRepository
    init(
    _ paymentRoomRepository: PaymentRoomRepository = PaymentRoomRepositoryImpl()) {
        self.paymentRoomRepository = paymentRoomRepository
    }

    func fetchPaymentRoomList() -> Observable<[Entity.Space]> {
        paymentRoomRepository.fetchPaymentRoomList()
    }

}
