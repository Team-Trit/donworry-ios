//
//  HomePaymentSection.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxDataSources
import Models

enum HomePaymentCardItem {
    case TakePaymentCard([Transfer])
    case GivePaymentCard(Transfer)
    case StatePaymentCard
    case LeavePaymentCard
}

enum PaymentCardCollectionViewSection {
    case CircleSection([HomePaymentCardItem])
}

extension PaymentCardCollectionViewSection: SectionModelType {
    typealias Item = HomePaymentCardItem

    var items: [HomePaymentCardItem] {
        switch self {
        case .CircleSection(let items):
            return items
        }
    }

    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
