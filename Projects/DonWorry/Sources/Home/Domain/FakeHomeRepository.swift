//
//  FakeHomeRepository.swift
//  DonWorry
//
//  Created by Woody on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift
import Models

final class FakeHomeRepositoryImpl: HomeRepository {

    public init() {}

    func fetchPaymentRoomList() -> Observable<[PaymentRoom]> {
        return .just([dummyPaymentRoom1, dummyPaymentRoom2])
    }
    func fetchPaymentRoom(with id: Int) -> Observable<PaymentRoom> {
        let rooms = [dummyPaymentRoom1, dummyPaymentRoom2]
        return .just(rooms[id])
    }

}

extension FakeHomeRepositoryImpl {
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

extension PaymentRoom {
    static let dummyPaymentRoom = PaymentRoom(
        id: "0",
        code: "213d42s3s5",
        name: "MC2 첫 회식",
        admin: .dummyUser1,
        paymentCardList: [

        ],
        transferList: [
        ])
}

extension PaymentCard {
    static let dummyPaymentCard1 = PaymentCard(
        id: "0",
        name: "1차 고깃집 파티",
        cardIcon: .chicken,
        totalAmount: 120000,
        payer: User.dummyUser1,
        backgroundColor: "#4A2597",
        date: Date(),
        bankAccount: nil,
        images: nil,
        participatedUserList: [
            User.dummyUser1,
            User.dummyUser2,
            User.dummyUser3,
            User.dummyUser4
        ])
    static let dummyPaymentCard2 = PaymentCard(
        id: "1",
        name: "2차 유스택시",
        cardIcon: .dinner,
        totalAmount: 21000,
        payer: User.dummyUser1,
        backgroundColor: "#FF5454",
        date: Date(),
        bankAccount: nil,
        images: nil,
        participatedUserList: [
            User.dummyUser1,
            User.dummyUser2,
            User.dummyUser3
        ])
}
extension User {
    static let dummyUser1 = User(
        id: 0,
        nickName: "후영",
        bankAccount: .init(
            bank: .toss,
            accountHolderName: "애셔",
            accountNumber: "1000-1831-4124"
        ),
        image: "https://user-images.githubusercontent.com/56102421/179954565-010e44d2-7bf9-40de-b2af-345a3967031d.png"
    )

    static let dummyUser2 = User(
        id: 0,
        nickName: "에이브리",
        bankAccount: .init(bank: .citi, accountHolderName: "정찬희", accountNumber: "1000-2183-182723"),
        image: "https://user-images.githubusercontent.com/56102421/183689143-d12baec3-cba9-40e0-aa2b-d0a8c53a751b.jpg"
    )
    static let dummyUser3 = User(
        id: 1,
        nickName: "애셔",
        bankAccount: .init(bank: .citi, accountHolderName: "임영후", accountNumber: "3000-2183-182723"),
        image: "https://user-images.githubusercontent.com/56102421/179951845-1bc77f9d-0491-4c46-84b1-5b424d66bd60.png"
    )
    static let dummyUser4 = User(
        id: 1,
        nickName: "우디",
        bankAccount: .init(bank: .citi, accountHolderName: "이재용", accountNumber: "2000-2183-182723"),
        image: "https://user-images.githubusercontent.com/56102421/179954387-968f7152-23dc-496c-a6d6-48f49ac39700.png"
    )
}
