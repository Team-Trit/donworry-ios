//
//  SelectBankCollectionView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem

enum Section: CaseIterable {
    case main
}

final class SelectBankCollectionView: UICollectionView {
    var diffableDataSouce: UICollectionViewDiffableDataSource<Section, String>!
    
    convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth: CGFloat = 150
        let itemHeight: CGFloat = 45
        let itemSpacing: CGFloat = 10
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumInteritemSpacing = itemSpacing
        
        self.init(frame: .zero, collectionViewLayout: flowLayout)
        self.showsVerticalScrollIndicator = false
        self.contentInset = .init(top: 30, left: 10, bottom: 0, right: 10)
        self.register(SelectBankCollectionViewCell.self, forCellWithReuseIdentifier: SelectBankCollectionViewCell.identifier)
        self.diffableDataSouce = UICollectionViewDiffableDataSource<Section, String>(collectionView: self) { (collectionView, indexPath, bank) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectBankCollectionViewCell.identifier, for: indexPath) as? SelectBankCollectionViewCell else { return UICollectionViewCell() }
            cell.bankLabel.text = bank
            cell.bankIconView.image = UIImage(named: bank)
            return cell
        }
    }
}
