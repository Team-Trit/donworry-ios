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
    func formatSection(
        from paymentCardList: [PaymentCardModels.FetchCardList.Response.PaymentCard]
    ) -> [PaymentCardCellViewModel]
}

final class PaymentCardPresenterImpl: PaymentCardListPresenter {

    func formatSpace(
        from space: PaymentCardModels.FetchCardList.Response.Space
    ) {

    }

    func formatSection(
        from paymentCardList: [PaymentCardModels.FetchCardList.Response.PaymentCard]
    ) -> [PaymentCardCellViewModel] {
        return paymentCardList.map { convert($0) }
    }

    private func convert(_ paymentCard: PaymentCardModels.FetchCardList.Response.PaymentCard) -> PaymentCardCellViewModel {
        return .init(
            id: paymentCard.id,
            name: paymentCard.name,
            totalAmount: convertTotalAmountToString(paymentCard.totalAmount),
            number: paymentCard.spaceJoinUserCount,
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

    private func convertTotalAmountToString(_ totalAmount: Int) -> String {
        var result: String = ""
        if let amountText = Formatter.amountFormatter.string(from: NSNumber(value: totalAmount)) {
            result = "총 " + amountText + "원"
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
