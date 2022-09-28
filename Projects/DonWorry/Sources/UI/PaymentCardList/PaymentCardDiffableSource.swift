//
//  PaymentCardDiffableSource.swift
//  DonWorry
//
//  Created by Woody on 2022/09/26.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final class PaymentCardDiffableDataSource: UICollectionViewDiffableDataSource<PaymentCardSection, PaymentCardSection.Item> {
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .paymentCard(let viewModel):
                let paymentCardCell = collectionView.dequeueReusableCell(PaymentCardCollectionViewCell.self, for: indexPath)
                paymentCardCell.viewModel = viewModel
                return paymentCardCell
            }
        }
    }
}
