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
import Models

protocol PaymentCardRepository {
    func fetchPaymentCardList(spaceID: Int) -> Observable<PaymentCardModels.FetchCardList.Response>
    func joinCard(request: PaymentCardModels.JoinCard.Request) -> Observable<PaymentCardModels.Empty.Response>
    func createCard(request: PaymentCardModels.CreateCard.Request) -> Observable<PaymentCardModels.Empty.Response>
    func fetchPaymentCard(cardId: Int) -> Observable<PaymentCardModels.FetchCard.Response>
    func deletePaymentCardList(cardId: Int) -> Observable<PaymentCardModels.Empty.Response>
    func putEditPaymentCard(id: Int, totalAmount: Int) -> Observable<PaymentCardModels.PutCard.Response>
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

    func joinCard(request: PaymentCardModels.JoinCard.Request) -> Observable<PaymentCardModels.Empty.Response> {
        network.request(
            PostJoinPaymentCardAPI(
                request:  .init(
                    currentCardIds: request.currentCardIds,
                    selectedCardIds: request.selectedCardIds
                )
            )
        )
        .compactMap { _ in .init() }.asObservable()
    }

    func fetchPaymentCard(cardId: Int) -> Observable<PaymentCardModels.FetchCard.Response> {
        network.request(GetPaymentCardAPI(cardId: cardId))
            .compactMap { [weak self] response in
                guard let self = self else { throw PaymentCardError.parsingError }
                return .init(card: self.convertToPaymentCard(response))
            }.asObservable()
    }
    
    func deletePaymentCardList(cardId: Int) -> Observable<PaymentCardModels.Empty.Response> {
         network.request(DeletePaymentCardAPI(cardId: cardId))
            .compactMap { _ in return .init() }
            .asObservable()
            
    }
    
    func putEditPaymentCard(id: Int, totalAmount: Int) -> Observable<PaymentCardModels.PutCard.Response> {
        network.request(PutEditPaymentCardAPI(request: .init(id: id, totalAmount: totalAmount)))
            .compactMap { _ in
                return .init(card: .init(id: id, totalAmount: totalAmount))
            }.asObservable()
    }

    func createCard(request: PaymentCardModels.CreateCard.Request) -> Observable<PaymentCardModels.Empty.Response> {
        network.request(PostPaymentCardAPI(request: createPostPaymentCardReqeust(paymentCard: request)))
            .compactMap { _ in .init() }.asObservable()
    }

    // SpaceDTO에서 Space도메인으로 변환해줍니다.
    private func convertToSpace(_ dto: DTO.GetPaymentCardList.Space) -> PaymentCardModels.FetchCardList.Response.Space {
        return .init(id: dto.id, adminID: dto.adminID, title: dto.title, status: dto.status, shareID: dto.shareID)
    }

    // PaymentCardDTO에서 PaymentCard 도메인으로 변환해줍니다.
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
    
    // PaymentCardUserDTO에서 PaymentCardUser 도메인으로 변환해줍니다.
    private func convertToUser(_ dto: DTO.GetPaymentCardList.PaymentCard.User) -> PaymentCardModels.FetchCardList.Response.PaymentCard.User {
        return .init(
            id: dto.id,
            nickname: dto.nickname,
            imgURL: dto.imgURL
        )
    }


    private func createPostPaymentCardReqeust(paymentCard: PaymentCardModels.CreateCard.Request) -> PostPaymentCardAPI.Request {
        return  .init(
            spaceID: paymentCard.spaceID, categoryID: paymentCard.categoryID, bank: paymentCard.bank, number: paymentCard.accountNumber, holder: paymentCard.holder, name: paymentCard.name, totalAmount: paymentCard.totalAmount, bgColor: paymentCard.bgColor, paymentDate: paymentCard.paymentDate, imgUrls: paymentCard.imageURLs)

    }
}
