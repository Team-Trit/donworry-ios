//
//  PaymentCardListPresenter.swift
//  DonWorry
//
//  Created by Woody on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import DonWorryExtensions

protocol PaymentCardListPresenter {
    typealias Response = PaymentCardModels.FetchCardList.Response
    typealias PaymentCard = Response.PaymentCard
    func formatPaymentCardModelList(from paymentCardList: [PaymentCard]) -> [PaymentCardCellViewModel]
    func formatSection(with response: Response) -> [PaymentCardSection]
    func canAlgorithmStart(with paymentCardList: [PaymentCard]) -> Bool
}

final class PaymentCardListPresenterImpl: PaymentCardListPresenter {

    func canAlgorithmStart(with paymentCardList: [PaymentCard]) -> Bool {
        return paymentCardList.contains(where: { $0.cardJoinUserCount == 1 })
    }

    func formatPaymentCardModelList(from paymentCardList: [PaymentCard]) -> [PaymentCardCellViewModel] {
        return paymentCardList.compactMap { [weak self] in self?.convertToPaymentCardViewModel($0) }
    }

    func formatSection(with response: Response) -> [PaymentCardSection] {
        var sections: [PaymentCardSection] = []
        sections.append(addParticipantSection(response.spaceJoinUsers))
        sections.append(addPaymentCardSection(response.cards))
        if response.space.status == "OPEN" {
            sections.append(addAddPaymentCardSection())
        }
        return sections
    }

    private func addParticipantSection(_ spaceJoinUsers: [PaymentCard.User]) -> PaymentCardSection {
        return .ParticipantCard(item: [.Participant(.init(users: spaceJoinUsers.map { convertToParticipantViewModel($0) }))])
    }

    private func addPaymentCardSection(_ paymentCardList: [PaymentCard]) -> PaymentCardSection {
        let items = paymentCardList.map { self.convertToPaymentCardViewModel($0) }.map { PaymentCardItem.PaymentCard($0) }
        return .PaymentCard(itmes: items)
    }

    private func addAddPaymentCardSection() -> PaymentCardSection {
        return .AddPaymentCard(item: [.AddPaymentCard])
    }

    // User -> ParticipantCellViewModel
    private func convertToParticipantViewModel(_ user: PaymentCard.User) -> ParticipantCellViewModel {
        return .init(id: user.id, imageURL: user.imgURL, nickname: user.nickname)
    }

    // PaymentCard -> PaymentCardCellViewModel
    private func convertToPaymentCardViewModel(_ paymentCard: PaymentCard) -> PaymentCardCellViewModel {
        return .init(
            id: paymentCard.id,
            name: paymentCard.name,
            totalAmount: convertTotalAmountToString(paymentCard.totalAmount),
            participatedUserCount: paymentCard.cardJoinUserCount,
            categoryImageName: paymentCard.category.name,
            payer: .init(
                id: paymentCard.taker.id,
                nickName: paymentCard.taker.nickname,
                imageURL: paymentCard.taker.imgURL
            ),
            participatedUserList: paymentCard.givers.map {
                .init(id: $0.id, nickName: $0.nickname, imageURL: $0.imgURL)
            },
            dateString: dateFormatting(paymentCard.paymentDate),
            backgroundColor: paymentCard.bgColor,
            isUserParticipated: paymentCard.isUserParticipatedIn
        )
    }

    // totalAmount(Int) -> String (원)
    private func convertTotalAmountToString(_ totalAmount: Int) -> String {
        var result: String = ""
        if let amountText = Formatter.amountFormatter.string(from: NSNumber(value: totalAmount)) {
            result = amountText + "원"
        } else {
            result = "0원"
        }
        return result
    }

    private func dateFormatting(_ dateString: String) -> String {
        if let date = Formatter.fullDateFormatter.date(from: dateString) {
            return Formatter.mmddDateFormatter.string(from: date)
        }
        return "00/00"
    }
}
