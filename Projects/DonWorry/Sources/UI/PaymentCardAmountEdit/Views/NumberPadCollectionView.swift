//
//  NumberPadCollectionView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/22.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem

final class NumberPadCollectionView: UICollectionView {
    convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        let itemSize: CGFloat = UIScreen.main.bounds.width / 3 - 80
        let lineSpacing: CGFloat = 30
        let itemSpacing: CGFloat = 40
        
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        flowLayout.sectionInset = UIEdgeInsets(top: UIDevice.current.hasNotch ? 40 : 30 , left: 45, bottom: 0, right: 45)
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.minimumInteritemSpacing = itemSpacing

        self.init(frame: .zero, collectionViewLayout: flowLayout)
        self.register(NumberPadCollectionViewCell.self, forCellWithReuseIdentifier: NumberPadCollectionViewCell.identifier)
        self.backgroundColor = .designSystem(.grayF9F9F9)
    }
}
