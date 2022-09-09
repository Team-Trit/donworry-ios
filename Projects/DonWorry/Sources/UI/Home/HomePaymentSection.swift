//
//  HomePaymentSection.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxDataSources

enum HomeBillCardItem: Equatable {
    case TakeBillCard(TakeBillCardCellViewModel)
    case GiveBillCard(GiveBillCardCellViewModel)
    case StateBillCard(StateBillCardViewModel)
    case LeaveBillCard
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
