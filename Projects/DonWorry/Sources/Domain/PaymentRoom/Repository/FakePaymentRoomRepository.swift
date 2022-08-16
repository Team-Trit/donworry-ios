//
//  FakePaymentRoomRepository.swift
//  DonWorry
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift
import Models

final class FakePaymentRoomRepositoryImpl: PaymentRoomRepository {

    func fetchPaymentRoomList() -> Observable<[PaymentRoom]> {
        return .just(dummyPaymentList)
    }
}

extension FakePaymentRoomRepositoryImpl {
    var dummyPaymentList: [PaymentRoom] {
        [PaymentRoom.dummyPaymentRoom1, PaymentRoom.dummyPaymentRoom2]
    }
}
