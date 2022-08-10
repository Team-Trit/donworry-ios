//
//  BankSelectView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import BaseArchitecture
import UIKit

private let banks = ["경남은행", "광주은행", "국민은행", "기업은행", "농협은행", "대구은행", "부산은행", "산림조합중앙회", "산업은행", "새마을금고", "수협은행", "신한은행", "신협증앙회", "우리은행", "우체국", "저축은행", "전북은행", "제주은행", "카카오뱅크", "케이뱅크", "토스뱅크", "하나은행", "한국씨티은행", "한국투자증권", "KB증권", "NH투자증권", "SC제일은행"
]

final class BankSelectView: BaseViewController {
    private let titleLabel = UILabel()
    private let bankCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        attributes()
        layout()
        bankCollectionView.dataSource = self
        bankCollectionView.delegate = self
    }
}

// MARK: - Configuration
extension BankSelectView {
    private func attributes() {
        titleLabel.text = "은행선택"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        bankCollectionView.register(BankHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BankHeaderView.bankHeaderViewID)
        bankCollectionView.register(BankCell.self, forCellWithReuseIdentifier: BankCell.bankCellID)
        if let layout = bankCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        ])
        view.addSubview(bankCollectionView)
        bankCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bankCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            bankCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            bankCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            bankCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - DataSource
extension BankSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bankCollectionView.dequeueReusableCell(withReuseIdentifier: BankCell.bankCellID, for: indexPath) as! BankCell
        let bank = banks[indexPath.row]
        cell.bankIconView.image = UIImage(named: bank)
        cell.bankLabel.text = bank
        return cell
    }
}

// MARK: - Delegate
extension BankSelectView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BankHeaderView.bankHeaderViewID, for: indexPath)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 30
        let height: CGFloat = 45
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
