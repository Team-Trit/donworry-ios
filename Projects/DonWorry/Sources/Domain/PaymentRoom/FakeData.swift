//
//  FakeRepository.swift
//  DonWorry
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models

extension PaymentRoom {
    static let dummyPaymentRoom1: PaymentRoom = {
        .init(
            id: 1,
            code: "213d42s3s5",
            name: "MC2 첫 회식",
            admin: .dummyUser1,
            paymentCardList: [.dummyPaymentCard1, .dummyPaymentCard2],
            transferList: [
                Transfer(giver: .dummyUser2, taker: .dummyUser1, amount: 37000, isCompleted: false),
                Transfer(giver: .dummyUser3, taker: .dummyUser1, amount: 37000, isCompleted: true),
                Transfer(giver: .dummyUser4, taker: .dummyUser1, amount: 30000, isCompleted: false),
                Transfer(giver: .dummyUser2, taker: .dummyUser5, amount: 37000, isCompleted: true),
            ]
        )
    }()
    static let dummyPaymentRoom2: PaymentRoom = {
        .init(
            id: 2,
            code: "5613d42s3s5",
            name: "서울 나들이",
            admin: .dummyUser2,
            paymentCardList: [.dummyPaymentCard1, .dummyPaymentCard2,.dummyPaymentCard3],
            transferList: nil
        )
    }()

}

extension PaymentCard {
    static let  dummyPaymentCard1: PaymentCard = {
        .init(
            id: 1,
            name: "1차 고깃집 파티",
            cardIcon: .chicken,
            totalAmount: 120000,
            payer: .dummyUser1,
            backgroundColor: "#4A2597",
            date: Date(),
            bankAccount: nil,
            images: nil,
            participatedUserList: [.dummyUser1, .dummyUser2, .dummyUser3, .dummyUser4, .dummyUser5]
        )
    }()
    static let dummyPaymentCard2: PaymentCard = {
        .init(
            id: 2,
            name: "2차 유스택시",
            cardIcon: .chicken,
            totalAmount: 21000,
            payer: .dummyUser1,
            backgroundColor: "#FF5454",
            date: Date(),
            bankAccount: nil,
            images: nil,
            participatedUserList: [.dummyUser1, .dummyUser2, .dummyUser3, .dummyUser5]
        )
    }()
    static let dummyPaymentCard3: PaymentCard = {
        .init(
            id: 2,
            name: "3차 볼링장",
            cardIcon: .chicken,
            totalAmount: 132000,
            payer: .dummyUser2,
            backgroundColor: "#4A2597",
            date: Date(),
            bankAccount: nil,
            images: nil,
            participatedUserList: [.dummyUser1, .dummyUser2, .dummyUser3, .dummyUser4 ,.dummyUser5]
        )
    }()
}

extension User {
    static let dummyUser1: User = {
        .init(
            id: 1,
            nickName: "우디",
            bankAccount: .init(bank: "토스뱅크", accountHolderName: "이재용", accountNumber: "1000-1831-4124"),
            image: "https://img.sbs.co.kr/newsnet/etv/upload/2021/03/05/30000673929_1280.jpg"
        )
    }()

    static let dummyUser2: User = {
        .init(
            id: 2,
            nickName: "에이브리",
            bankAccount: .init( bank: "토스뱅크", accountHolderName: "정찬희",  accountNumber: "1000-1831-4124"),
            image: "https://user-images.githubusercontent.com/56102421/179954565-010e44d2-7bf9-40de-b2af-345a3967031d.png"
        )
    }()

    static let dummyUser3: User = {
        .init(
            id: 3,
            nickName: "애셔",
            bankAccount: .init(bank: "한국씨티은행", accountHolderName: "임영후", accountNumber: "3000-2183-182723"),
            image: "https://i.pinimg.com/originals/2c/2c/60/2c2c60b20cb817a80afd381ae23dab05.jpg"
        )
    }()

    static let dummyUser4: User = {
        .init(
            id: 4,
            nickName: "유스",
            bankAccount: .init(bank: "한국씨티은행", accountHolderName: "김의성", accountNumber: "2000-2183-182723"),
            image: "https://img.theqoo.net/img/fzxPW.jpg"
        )
    }()

    static let dummyUser5: User = {
        .init(
            id: 5,
            nickName: "찰리",
            bankAccount: .init(bank: "한국씨티은행", accountHolderName: "김승창", accountNumber: "4000-9732-893621"),
            image: "https://post-phinf.pstatic.net/MjAxOTAyMTZfMTMz/MDAxNTUwMjg0NTQ3Njk3.nOALV-TOkthnpIEg3kFCA6QA221DrLgZsBJxMKE1Hj0g.I_EYQvpkiwhl8Jj9sTBfNIs5U7Hai968vAqa5BJHlpAg.JPEG/n1233.jpg?type=w1200"
        )
    }()
}
