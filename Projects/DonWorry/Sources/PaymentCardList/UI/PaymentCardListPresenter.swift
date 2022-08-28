//
//  PaymentCardListPresenter.swift
//  DonWorry
//
//  Created by Woody on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Models
import DonWorryExtensions

protocol PaymentCardListPresenter {
    func formatSection(
        from paymentCardList: [PaymentCard],
        with transfer: [Transfer]?
    ) -> [PaymentCardSection]
}

final class PaymentCardPresenterImpl: PaymentCardListPresenter {

    func formatSection(
        from paymentCardList: [PaymentCard],
        with transferList: [Transfer]?
    ) -> [PaymentCardSection] {
        guard paymentCardList.isNotEmpty else { return [.PaymentCardSection([.AddPaymentCard])]}
        var paymentCardItems = paymentCardList
            .map { paymentCard in convert(paymentCard, yetComplete: transferList == nil) }
            .map { PaymentCardItem.PaymentCard($0) }
        paymentCardItems.append(.AddPaymentCard)
        return [.PaymentCardSection(paymentCardItems)]
    }

    private func convert(_ paymentCard: PaymentCard, yetComplete: Bool) -> PaymentCardCellViewModel {
        return .init(
            id: paymentCard.id,
                     name: paymentCard.name,
            totalAmount: convertTotalAmountToString(paymentCard.totalAmount),
            number: paymentCard.participatedUserList.count,
            cardIconImageName: paymentCard.cardIcon.rawValue,
            payer: .init(
                id: paymentCard.payer.id,
                nickName: paymentCard.payer.nickName,
                imageURL: paymentCard.payer.image
            ),
            participatedUserList: paymentCard.participatedUserList.map {
                .init(id: $0.id, nickName: $0.nickName, imageURL: $0.image)
            },
            dateString: Formatter.paymentCardDateFormatter.string(from: paymentCard.date),
            backgroundColor: paymentCard.backgroundColor,
            yetComplete: yetComplete)
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
}
