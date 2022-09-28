//
//  SpaceDiffableDataSource.swift
//  DonWorry
//
//  Created by Woody on 2022/09/26.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final class SpaceDiffableDataSource: UICollectionViewDiffableDataSource<SpaceSection, SpaceSection.Item> {

    init(collectionView: UICollectionView) {

        super.init(collectionView: collectionView) { collectionView, indexPath, cellIdetifier in
            guard case .space(let itemmodel) = cellIdetifier else { return .init() }
            let cell = collectionView.dequeueReusableCell(SpaceCollectionViewCell.self, for: indexPath)
            cell.viewModel = itemmodel
            return cell
        }
    }
}
