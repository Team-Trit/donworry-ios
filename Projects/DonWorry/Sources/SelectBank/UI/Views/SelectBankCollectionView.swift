//
//  SelectBankCollectionView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final class SelectBankCollectionView: UICollectionView {
    private let banks = ["경남은행", "광주은행", "국민은행", "기업은행", "농협은행", "대구은행", "부산은행", "산림조합중앙회", "산업은행", "새마을금고", "수협은행", "신한은행", "신협증앙회", "우리은행", "우체국", "저축은행", "전북은행", "제주은행", "카카오뱅크", "케이뱅크", "토스뱅크", "하나은행", "한국씨티은행", "한국투자증권", "KB증권", "NH투자증권", "SC제일은행"
    ]
    
    convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth: CGFloat = 150
        let itemHeight: CGFloat = 45
        let itemSpacing: CGFloat = 10
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumInteritemSpacing = itemSpacing
        self.init(frame: .zero, collectionViewLayout: flowLayout)
        showsVerticalScrollIndicator = false
        contentInset = .init(top: 30, left: 10, bottom: 0, right: 10)
        register(SelectBankCollectionViewCell.self, forCellWithReuseIdentifier: SelectBankCollectionViewCell.identifier)
        dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension SelectBankCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: SelectBankCollectionViewCell.identifier, for: indexPath) as! SelectBankCollectionViewCell
        let bank = banks[indexPath.row]
        cell.bankIconView.image = UIImage(named: bank)
        cell.bankLabel.text = bank
        return cell
    }
}
