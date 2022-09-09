//
//  AddPaymentCardCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import DonWorryExtensions

final class AddPaymentCardCollectionViewCell: UICollectionViewCell {

    lazy var plusStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 10
        v.distribution = .equalSpacing
        v.alignment = .center
        return v
    }()
    lazy var plusButton: UIButton = {
        let v = UIButton(type: .system)
        v.setImage(UIImage(systemName: "plus"), for: .normal)
        v.tintColor = .designSystem(.white)
        v.backgroundColor = .designSystem(.mainBlue)
        return v
    }()
    lazy var plusLabel: UILabel = {
        let v = UILabel()
        v.text = "정산내역 추가"
        v.font = .designSystem(weight: .bold, size: ._13)
        v.textColor = .designSystem(.mainBlue)
        v.textAlignment = .center
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }

    private func setUI() {
        self.backgroundColor = .designSystem(.grayF6F6F6)
        self.roundCorners(20)
        self.contentView.addSubview(self.plusStackView)
        self.plusStackView.addArrangedSubviews(self.plusButton, self.plusLabel)

        self.plusStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(30)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        self.plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
        self.plusButton.roundCorners(18)
    }
}
