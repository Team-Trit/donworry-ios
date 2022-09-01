//
//  PaymentRoomRepository.swift
//  DonWorryTests
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import DonWorryNetworking
import RxSwift

protocol PaymentRoomRepository {
    func fetchPaymentRoomList() -> Observable<[Entity.Space]>
}

final class PaymentRoomRepositoryImpl: PaymentRoomRepository {
    private let network: NetworkServable

    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    func fetchPaymentRoomList() -> Observable<[Entity.Space]> {
        network.request(GetPaymentRoomListAPI())
            .compactMap { response in response.compactMap { self.convert(from: $0) }}
            .asObservable()
    }

    private func convert(from dto: DTO.PaymentRoom) -> Entity.Space {
        return .init(
            id: dto.id,
            adminID: dto.adminID,
            title: dto.title,
            status: dto.status,
            shareID: dto.shareID,
            isTaker: dto.isTaker,
            payments: dto.payments.map { convert(from: $0) }
        )
    }
    private func convert(from dto: DTO.PaymentRoom.Payment) -> Entity.SpacePayment {
        return .init(id: dto.id, amount: dto.amount, isCompleted: dto.isCompleted, user: convert(from: dto.user))
    }
    private func convert(from dto: DTO.PaymentRoom.User) -> Entity.SpaceUser {
        return .init(id: dto.id, nickname: dto.nickname, imgURL: dto.imgURL)
    }
}
