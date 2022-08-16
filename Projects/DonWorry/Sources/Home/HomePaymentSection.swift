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

enum HomeBillCardItem: Equatable {
    case TakePaymentCard(TakeBillCardCellViewModel)
    case GivePaymentCard(GiveBillCardCellViewModel)
    case StatePaymentCard
    case LeavePaymentCard
}

enum BillCardSection: Equatable {
    case BillCardSection([HomeBillCardItem])
}

extension BillCardSection: SectionModelType {
    typealias Item = HomeBillCardItem

    var items: [HomeBillCardItem] {
        switch self {
        case .BillCardSection(let items):
            return items
        }
    }

    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
