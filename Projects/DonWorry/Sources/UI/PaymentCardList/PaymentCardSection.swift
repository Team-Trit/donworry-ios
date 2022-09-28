//
//  PaymentCardSection.swift
//  DonWorry
//
//  Created by Woody on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum PaymentCardSection: Hashable {
    typealias ParticipantCardModel = ParticipantListCellViewModel
    typealias Item = PaymentCardItem

    case participantCard(ParticipantCardModel)
    case PaymentCard(itmes: [Item])
    case addPaymentCard
}

enum PaymentCardItem: Hashable {
    case paymentCard(PaymentCardCellViewModel)
}
