//
//  ParticipateCollectionView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem

final class ParticipateCollectionView: UICollectionView {
    convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 12
        flowLayout.headerReferenceSize = .init(width: 100, height: 38)
        flowLayout.footerReferenceSize = .init(width: 100, height: 74)
        flowLayout.scrollDirection = .vertical
        
        self.init(frame: .zero, collectionViewLayout: flowLayout)
        self.register(ParticipateCollectionViewCell.self, forCellWithReuseIdentifier: ParticipateCollectionViewCell.cellID)
    }
}
