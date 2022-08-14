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
    ) -> [PaymentCardSection]
}

final class PaymentCardPresenterImpl: PaymentCardListPresenter {

    func formatSection(
        from paymentCardList: [PaymentCard]
    ) -> [PaymentCardSection] {
        guard paymentCardList.isNotEmpty else { return [.PaymentCardSection([.AddPaymentCard])]}
        var paymentCardItems = paymentCardList.map(PaymentCardCellViewModel.init)
            .map { PaymentCardItem.PaymentCard($0)}
        paymentCardItems.append(.AddPaymentCard)
        return [.PaymentCardSection(paymentCardItems)]
    }
}

extension PaymentCardCellViewModel {
    init(_ entity: PaymentCard) {
        self.id = entity.id
        self.name =  entity.name
        self.number = entity.participatedUserList.count
        self.payer = .init(entity.payer)
        self.participatedUserList = entity.participatedUserList.map(PaymentCardCellDdipUser.init)
        self.cardIconImageName = entity.cardIcon.rawValue
        self.backgroundColor = entity.backgroundColor
        self.dateString = Formatter.paymentCardDateFormatter.string(from: entity.date)
        if let amountText = Formatter.amountFormatter.string(from: NSNumber(value: entity.totalAmount)) {
            self.totalAmount = "총 " + amountText + "원"
        } else {
            self.totalAmount = "0원"
        }
    }
}

extension PaymentCardCellDdipUser {
    init(_ entity: User) {
        self.id = entity.id
        self.nickName = entity.nickName
        self.imageURL = entity.image
    }
}
