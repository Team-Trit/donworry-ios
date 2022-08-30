//
//  AgreeTermTableViewCell.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class AgreeTermTableViewCell: UITableViewCell {
    static let identifier = "AgreeTermTableViewCell"
    lazy var termLabel: UILabel = {
        let v = UILabel()
        v.textColor = .designSystem(.gray818181)
        v.font = .designSystem(weight: .regular, size: ._15)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension AgreeTermTableViewCell {
    private func setUI() {
        addSubview(termLabel)
        
        termLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.centerY.equalToSuperview()
        }
    }
}

