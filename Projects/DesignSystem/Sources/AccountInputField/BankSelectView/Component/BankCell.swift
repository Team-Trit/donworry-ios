//
//  BankCell.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final class BankCell: UICollectionViewCell {
    static let identifier = "BankCell"
    let bankIconView = UIImageView()
    let bankLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attributes()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
extension BankCell {
    private func attributes() {
        bankLabel.font = .systemFont(ofSize: 15)
    }
    
    private func layout() {
        addSubview(bankIconView)
        bankIconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bankIconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bankIconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bankIconView.widthAnchor.constraint(equalToConstant: 25),
            bankIconView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        addSubview(bankLabel)
        bankLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bankLabel.leadingAnchor.constraint(equalTo: bankIconView.trailingAnchor, constant: 10),
            bankLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            bankLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
