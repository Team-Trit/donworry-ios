//
//  PaymentCardRepository.swift
//  DonWorryTests
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import DonWorryNetworking
import RxSwift
import Models

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
            .compactMap { _ in
                    return "suc"
            }.asObservable()
    }
    
    func fetchPaymentCard(cardId: Int) -> Observable<PaymentCardModels.FetchCard.Response> {
        network.request(GetPaymentCardAPI(cardId: cardId))
            .compactMap { [weak self] response in
                guard let self = self else { throw PaymentCardError.parsingError }
                return .init(card: self.convertToPaymentCard(response))
            }.asObservable()
    }
    
    func deletePaymentCardList(cardId: Int) -> Observable<String> {
        network.request(DeletePaymentCardAPI(cardId: cardId))
            .compactMap { _ in
                    return "suc"
            }.asObservable()
    }
    
    func putEditPaymentCard(id: Int, totalAmount: Int) -> Observable<PaymentCardModels.PutCard.Response> {
        network.request(PutEditPaymentCardAPI(request: .init(id: id, totalAmount: totalAmount)))
            .compactMap { _ in
                return .init(card: .init(id: id, totalAmount: totalAmount))
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
    
    private func convertToPaymentCard(_ dto: DTO.GetPaymentCard.PaymentCard) -> PaymentCardModels.FetchCard.Response.PaymentCard {
        return .init(id: dto.id, totalAmount: dto.totalAmount, users: dto.users.map{.init(id: $0.id, isTaker: $0.isTaker, nickname: $0.nickname, imgURL: $0.imgURL)}, imgUrls: dto.imgUrls)
    }
    
    private func convertToUser(_ dto: DTO.GetPaymentCardList.PaymentCard.User) -> PaymentCardModels.FetchCardList.Response.PaymentCard.User {
        return .init(
            id: dto.id,
            nickname: dto.nickname,
            imgURL: dto.imgURL
        )
    }
}
