//
//  SelectBankCollectionViewCell.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem

final class SelectBankCollectionViewCell: UICollectionViewCell {
    static let identifier = "SelectBankCollectionViewCell"
    lazy var bankIconView = UIImageView()
    lazy var bankLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .regular, size: ._15)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension SelectBankCollectionViewCell {
    private func setUI() {
        addSubviews(bankIconView, bankLabel)
        
        bankIconView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(25)
            make.centerY.equalToSuperview()
        }
        
        bankLabel.snp.makeConstraints { make in
            make.leading.equalTo(bankIconView.snp.trailing).offset(10)
            make.trailing.centerY.equalToSuperview()
        }
    }
}
