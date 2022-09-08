//
//  PaymentRepository.swift
//  DonWorryTests
//
//  Created by Woody on 2022/09/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import DonWorryNetworking
import RxSwift

protocol PaymentRepository {
    func fetchGiverPayment(spaceID: Int, paymentID: Int) -> Observable<PaymentModels.FetchGiverPayment.Response>
    func fetchTakerPaymentList(spaceID: Int) -> Observable<PaymentModels.FetchTakerPaymentList.Response>
}

final class PaymentRepositoryImpl: PaymentRepository {
    private let network: NetworkServable

    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    func fetchGiverPayment(spaceID: Int, paymentID: Int) -> Observable<PaymentModels.FetchGiverPayment.Response> {
        network.request(GetPaymentsGiverAPI(spaceID: spaceID, paymentID: paymentID))
            .compactMap { [weak self] response in
                self?.convertToGiverPayment(response)
            }.asObservable()
    }

    func fetchTakerPaymentList(spaceID: Int) -> Observable<PaymentModels.FetchTakerPaymentList.Response> {
        network.request(GetPaymentsTakerAPI(spaceID: spaceID))
            .compactMap { [weak self] response in
                self?.convertToTakerPaymentList(response)
            }.asObservable()
    }

    private func convertToGiverPayment(_ dto: DTO.GetPaymentsGiver) -> PaymentModels.FetchGiverPayment.Response {
        return .init(paymentID: dto.paymentID, spaceID: dto.spaceID, amount: dto.amount, spaceTotalAmount: dto.spaceTotalAmount, isCompleted: dto.isCompleted, takerNickname: dto.takerNickname, account: .init(bank: dto.account.bank, number: dto.account.number, holder: dto.account.holder), cards: dto.cards.map { .init(name: $0.name, paymentDate: $0.paymentDate, categoryImgURL: $0.categoryImgURL, totalAmount: $0.totalAmount, cardJoinUserCount: $0.cardJoinUserCount, amountPerUser: $0.amountPerUser)})
    }

    private func convertToTakerPaymentList(_ dto: DTO.GetPaymentsTaker) -> PaymentModels.FetchTakerPaymentList.Response {
        return .init(totalAmount: dto.totalAmount, currentAmount: dto.currentAmount, payments: dto.payments.map { .init(id: $0.id, amount: $0.amount, isCompleted: $0.isCompleted, user: .init(id: $0.user.id, nickname: $0.user.nickname, imgURL: $0.user.imgURL))})
    }
}
