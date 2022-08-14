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
        self.amount = entity.totalAmount
        self.number = entity.participatedUserList.count
        self.payer = .init(entity.payer)
        self.participatedUserList = entity.participatedUserList.map(PaymentCardCellDdipUser.init)
        self.dateString = Formatter.paymentCardDateFormatter.string(from: entity.date)
    }
}

extension PaymentCardCellDdipUser {
    init(_ entity: User) {
        self.id = entity.id
        self.nickName = entity.nickName
        self.imageURL = entity.image
    }
}
