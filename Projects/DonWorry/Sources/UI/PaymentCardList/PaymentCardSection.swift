//
//  PaymentCardSection.swift
//  DonWorry
//
//  Created by Woody on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum PaymentCardSection: Hashable {
    typealias Item = PaymentCardItem

    case ParticipantCard(item: [Item])
    case PaymentCard(itmes: [Item])
    case AddPaymentCard(item: [Item])
}

enum PaymentCardItem: Hashable {
    case AddPaymentCard
    case PaymentCard(PaymentCardCellViewModel)
    case Participant(ParticipantListCellViewModel)
}
