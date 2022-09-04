//
//  SpaceCollectionView.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DonWorryExtensions

final class SpaceCollectionView: UICollectionView {

    convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth: CGFloat = 80
        let itemHeight: CGFloat = itemWidth
        let itemSpacing: CGFloat = 15
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumInteritemSpacing = itemSpacing
        self.init(frame: .zero, collectionViewLayout: flowLayout)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentInset = .init(top: 0, left: 25, bottom: 0, right: 25)
        self.register(SpaceCollectionViewCell.self)
        self.backgroundColor = .clear
        self.allowsSelection = true
        self.allowsMultipleSelection = false
    }
    
}
