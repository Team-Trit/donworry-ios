//
//  PaymentCardSection.swift
//  DonWorry
//
//  Created by Woody on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxDataSources

enum PaymentCardItem: Equatable {
    case AddPaymentCard
    case PaymentCard(PaymentCardCellViewModel)
}

enum PaymentCardSection: Equatable {
    case PaymentCardSection([PaymentCardItem])
}
                            
extension PaymentCardSection: SectionModelType {
    typealias Item = PaymentCardItem
    var items: [Item] {
        switch self {
        case .PaymentCardSection(let items):
            return items
        }
    }

    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
