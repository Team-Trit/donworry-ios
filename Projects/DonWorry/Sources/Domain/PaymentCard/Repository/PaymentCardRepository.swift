//
//  PaymentCardRepository.swift
//  DonWorryTests
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import DonWorryExtensions
import DonWorryNetworking
import RxSwift

enum PaymentCardError: Error {
    case parsingError
    case noUser
}

final class PaymentCardRepositoryImpl: PaymentCardRepository {
    
    private let network: NetworkServable

    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    func fetchPaymentCardList(spaceID: Int) -> Observable<PaymentCardModels.FetchCardList.Response> {
        return network.request(GetPaymentCardListAPI(spaceID: spaceID))
            .compactMap { [weak self] response in
                guard let self = self else { throw PaymentCardError.parsingError }
                return .init(
                    isAllPaymentCompleted: response.isAllPaymentCompleted,
                    space: self.convertToSpace(response.space),
                    cards: response.cards.compactMap { self.convertToPaymentCard($0) }
                )
            }.asObservable()
    }
    
    func joinPaymentCardList(ids: [Int]) -> Observable<String> {
        network.request(PostJoinPaymentCardAPI(request: .init(cardIds: ids)))
            .compactMap { str in
                    return str
            }.asObservable()
    }
    
    private func convertToSpace(_ dto: DTO.GetPaymentCardList.Space) -> PaymentCardModels.FetchCardList.Response.Space {
        return .init(id: dto.id, adminID: dto.adminID, title: dto.title, status: dto.status, shareID: dto.shareID)
    }

    private func convertToPaymentCard(_ dto: DTO.GetPaymentCardList.PaymentCard) -> PaymentCardModels.FetchCardList.Response.PaymentCard {
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
            givers: dto.givers.map { .init(id: $0.id, nickname: $0.nickname, imgURL: $0.imgURL) },
            isUserParticipatedIn: false
        )
    }

    private func convertToUser(_ dto: DTO.GetPaymentCardList.PaymentCard.User) -> PaymentCardModels.FetchCardList.Response.PaymentCard.User {
        return .init(
            id: dto.id,
            nickname: dto.nickname,
            imgURL: dto.imgURL
        )
    }
    
    
    private func convertToPostPaymentCard(spaceId: Int, paymentCard: PaymentCard) -> PostPaymentCardAPI.Request {
        return .init(
            spaceID: spaceId,
            categoryID: 0,
            bank: paymentCard.bankAccount?.bank ?? "",
            number: paymentCard.bankAccount?.accountNumber ?? "",
            holder: paymentCard.bankAccount?.accountHolderName ?? "",
            name: paymentCard.name,
            totalAmount: paymentCard.totalAmount,
            position: 0,
            bgColor: paymentCard.backgroundColor,
            paymentDate: paymentCard.date.getDateToString(format: "yyyy-MM-dd'T'HH:mm:ss")
        )
    }
    
    
}
