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
        from paymentCardList: [PaymentCard]
    ) -> [PaymentCardCellViewModel]
}

final class PaymentCardPresenterImpl: PaymentCardListPresenter {

    func formatSection(
        from paymentCardList: [PaymentCard]
    ) -> [PaymentCardCellViewModel] {
        return paymentCardList.map { convert($0) }
    }

    private func convert(_ paymentCard: PaymentCard) -> PaymentCardCellViewModel {
        return .init(
            id: paymentCard.id,
                     name: paymentCard.name,
            totalAmount: convertTotalAmountToString(paymentCard.totalAmount),
            number: paymentCard.participatedUserList.count,
            cardIconImageName: paymentCard.name,
            payer: .init(
                id: paymentCard.payer.id,
                nickName: paymentCard.payer.nickName,
                imageURL: paymentCard.payer.image
            ),
            participatedUserList: paymentCard.participatedUserList.map {
                .init(id: $0.id, nickName: $0.nickName, imageURL: $0.image)
            },
            dateString: Formatter.paymentCardDateFormatter.string(from: paymentCard.date),
            backgroundColor: paymentCard.backgroundColor)
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
