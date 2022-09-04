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

    func fetchPaymentCardList(spaceID: Int) -> Observable<PaymentCardModels.FetchCardList.ResponseList> {
        return network.request(GetPaymentCardListAPI(spaceID: spaceID))
            .compactMap { response in
                return response.compactMap { [weak self] dto in
                    return self?.convertToPaymentCard(dto)
                }
            }.asObservable()
    }

    private func convertToPaymentCard(_ dto: DTO.PaymentCard) -> PaymentCardModels.FetchCardList.Response {
        return .init(
            id: dto.id,
            spaceJoinUserCount: dto.spaceJoinUserCount,
            cardJoinUserCount: dto.cardJoinUserCount,
            name: dto.name,
            totalAmount: dto.totalAmount,
            bgColor: dto.bgColor,
            paymentDate: dto.paymentDate,
            category: .init(id: dto.category.id, name: dto.category.name, imgURL: dto.category.imgURL),
            account: .init(bank: dto.account.bank, number: dto.account.number, holder: dto.account.holder),
            taker: .init(id: dto.taker.id, nickname: dto.taker.nickname, imgURL: dto.taker.imgURL),
            givers: dto.givers.map { .init(id: $0.id, nickname: $0.nickname, imgURL: $0.imgURL) }
        )
    }

    private func convertToUser(_ dto: DTO.PaymentCard.User) -> PaymentCardModels.FetchCardList.Response.User {
        return .init(
            id: dto.id,
            nickname: dto.nickname,
            imgURL: dto.imgURL
        )
    }
}
