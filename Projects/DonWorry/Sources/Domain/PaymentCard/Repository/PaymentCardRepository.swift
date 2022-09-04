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
        print("fetchPaymentCardList")
        return network.request(GetPaymentCardListAPI(spaceID: spaceID))
            .compactMap { response in
                print("request done")
                return response.compactMap { [weak self] dto in
                    print("dto 레포지토리 단 : ", dto)
                    return self?.convertToPaymentCard(dto)
                }
            }.asObservable()
    }

    private func convertToPaymentCard(_ dto: DTO.PaymentCard) -> PaymentCardModels.FetchCardList.Response {
        return .init(
            id: dto.id,
            categoryID: dto.categoryID,
            taker: .init(id: dto.taker.id, nickname: dto.taker.nickname, imgURL: dto.taker.imgURL),
            givers: dto.givers.map { .init(id: $0.id, nickname: $0.nickname, imgURL: $0.imgURL)},
            spaceJoinUserCount: dto.spaceJoinUserCount,
            cardJoinUserCount: dto.cardJoinUserCount,
            bank: dto.bank,
            number: dto.number,
            holder: dto.holder,
            name: dto.name,
            totalAmount: dto.totalAmount,
            status: dto.status,
            bgColor: dto.bgColor,
            paymentDate: dto.paymentDate
        )
    }
    private func convertToUser(_ dto: DTO.PaymentCard.User) -> PaymentCardModels.FetchCardList.Response.Taker {
        return .init(
            id: dto.id,
            nickname: dto.nickname,
            imgURL: dto.imgURL
        )
    }
}
