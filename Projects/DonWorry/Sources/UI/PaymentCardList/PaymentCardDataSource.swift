//
//  PaymentCardDataSource.swift
//  DonWorry
//
//  Created by Woody on 2022/09/28.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final class PaymentCardDiffableDataSource: UICollectionViewDiffableDataSource<PaymentCardSection, PaymentCardSection.Item> {

    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .AddPaymentCard:
                let cell = collectionView.dequeueReusableCell(AddPaymentCardCollectionViewCell.self, for: indexPath)
                return cell
            case .Participant(let model):
                let cell = collectionView.dequeueReusableCell(ParticipantListCollectionViewCell.self, for: indexPath)
                cell.viewModel = model
                return cell
            case .PaymentCard(let model):
                let cell = collectionView.dequeueReusableCell(PaymentCardCollectionViewCell.self, for: indexPath)
                cell.viewModel = model
                return cell
            }
        }
    }
}
