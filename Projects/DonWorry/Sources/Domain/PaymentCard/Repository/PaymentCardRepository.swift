//
//  PaymentCardRepository.swift
//  DonWorryTests
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import DonWorryNetworking
import Models
import RxSwift

final class PaymentCardRepositoryImpl: PaymentCardRepository {
    private let network: NetworkServable

    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    func fetchPaymentCardList(spaceID: Int) -> Observable<[PaymentCard]> {
        network.request(PaymentCardListAPI(spaceID: spaceID))
            .compactMap { response in
                response.map { [weak self] dto in return self?.convertToPaymentCard(dto) ?? .dummyPaymentCard1 } // TODO: 더미 없애기
            }.asObservable()
    }

    private func convertToPaymentCard(_ dto: DTO.PaymentCard) -> PaymentCard {
        return .init(
            id: dto.id,
            name: dto.name,
            cardIcon: .init(id: 1, content: "", imageURL: ""), // TODO: 카테고리 아이콘 요청
            totalAmount: dto.totalAmount,
            payer: convertToUser(dto.taker),
            backgroundColor: dto.bgColor,
            date: Formatter.paymentCardDateFormatter.date(from: dto.paymentDate) ?? Date(),
            bankAccount: .init(bank: dto.bank, accountHolderName: "", accountNumber: ""), // TODO: 이것도 필요하지않나? 흐음...
            images: [],
            participatedUserList: dto.givers.map { .init(id: $0.id, nickName: $0.nickname, bankAccount: .empty, image: $0.imgURL) }
        )
    }
    private func convertToUser(_ dto: DTO.PaymentCard.User) -> User {
        return .init(
            id: dto.id,
            nickName: dto.nickname,
            bankAccount: .empty,
            image: dto.imgURL)
    }
}
