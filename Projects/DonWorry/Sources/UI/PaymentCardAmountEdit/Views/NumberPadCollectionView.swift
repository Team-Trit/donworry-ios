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
        let itemSize: CGFloat = 50
        let lineSpacing: CGFloat = 30
        let itemSpacing: CGFloat = 40
        
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        flowLayout.sectionInset = UIEdgeInsets(top: 40, left: 45, bottom: 0, right: 45)
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.minimumInteritemSpacing = itemSpacing

        self.init(frame: .zero, collectionViewLayout: flowLayout)
        self.register(NumberPadCollectionViewCell.self, forCellWithReuseIdentifier: NumberPadCollectionViewCell.identifier)
        self.backgroundColor = .designSystem(.grayF9F9F9)
//        self.layer.borderWidth = 2
//        self.layer.borderColor = CGColor(red: 0.8568, green: 0.8568, blue: 0.8568, alpha: 1)
//        self.layer.cornerRadius = 38
    }
}
