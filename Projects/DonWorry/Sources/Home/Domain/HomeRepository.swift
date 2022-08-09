//
//  Repository.swift
//  donworry-iosManifests
//
//  Created by Woody on 2022/08/04.
//

import Foundation
import RxSwift
import Models

protocol HomeRepository {
    func fetchPaymentRoomList() -> Observable<[PaymentRoom]>
    func fetchPaymentRoom(with id: Int) -> Observable<PaymentRoom>
}

final class HomeRepositoryImpl: HomeRepository {

    public init() {}

    func fetchPaymentRoomList() -> Observable<[PaymentRoom]> {
        // MARK: dto 변환
        return .just([dummyPaymentRoom1, dummyPaymentRoom2])
    }
    func fetchPaymentRoom(with id: Int) -> Observable<PaymentRoom> {
        // MARK: dto 변환
        let rooms = [dummyPaymentRoom1, dummyPaymentRoom2]
        return .just(rooms[id])
    }

}

extension HomeRepositoryImpl {
    var dummyPaymentRoom1: PaymentRoom { .init(
        id: "0",
        code: "213d42s3s5",
        name: "MC2 첫 회식",
        admin: .dummyUser1,
        paymentCardList: [
            PaymentCard.dummyPaymentCard1,
            PaymentCard.dummyPaymentCard2
        ],
        transferList: [
            Transfer(giver: User.dummyUser2, taker: User.dummyUser1, amount: 37000, isCompleted: false),
            Transfer(giver: User.dummyUser3, taker: User.dummyUser1, amount: 37000, isCompleted: false),
            Transfer(giver: User.dummyUser4, taker: User.dummyUser1, amount: 30000, isCompleted: false)
        ])
    }
    var dummyPaymentRoom2: PaymentRoom { .init(
        id: "1",
        code: "5613d42s3s5",
        name: "MC3 서울 나들이",
        admin: .dummyUser2,
        paymentCardList: [
            PaymentCard.dummyPaymentCard1,
            PaymentCard.dummyPaymentCard2
        ],
        transferList: nil)

    }
}
