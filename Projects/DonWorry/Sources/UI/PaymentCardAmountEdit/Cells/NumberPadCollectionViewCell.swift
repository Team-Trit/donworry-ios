//
//  NumberPadCollectionViewCell.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/22.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class NumberPadCollectionViewCell: UICollectionViewCell {
    static let identifier = "NumberPadCollectionViewCell"
    lazy var numberLabel: UILabel = {
        let v = UILabel()
        v.textColor = .designSystem(.mainBlue)
        v.font = .designSystem(weight: .bold, size: ._20)
        v.textAlignment = .center
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
extension NumberPadCollectionViewCell {
    private func setUI() {
        self.addSubview(numberLabel)
        
        numberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(45)
        }
    }
}
