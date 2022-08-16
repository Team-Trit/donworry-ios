//
//  PaymentRoomRepository.swift
//  DonWorry
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift
import DonWorryNetworking
import Models

final class PaymentRoomRepositoryImpl: PaymentRoomRepository {

    init(network: NetworkServable) {
        self.network = network
    }

    func fetchPaymentRoomList() -> Observable<[PaymentRoom]> {
        let api = PaymentRoomAPI()
        return self.network.request(api)
            .compactMap { response in response.list?.compactMap { $0 } }
            .compactMap { list in return list.compactMap { self.translate(fromDTO: $0) }}
            .asObservable()
    }

    private func translate(fromDTO dto: DTO.PaymentRoom) -> PaymentRoom {
        #warning("서버 DTO 나올경우 수정")
        return .dummyPaymentRoom1
    }

    private let network: NetworkServable
}
