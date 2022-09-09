//
//  LeaveSpaceBillCardCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

final class LeaveSpaceBillCardCollectionViewCell: UICollectionViewCell {
    lazy var leaveImageView: UIImageView = {
        let v = UIImageView(image: UIImage(.ic_billcard_leave))
        return v
    }()

    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .heavy, size: ._15)
        v.textColor = .designSystem(.white)
        v.text = "정산방 나가기"
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
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.leaveImageView)

        self.leaveImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(84)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(leaveImageView.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
        }

        self.leaveImageView.roundCorners(42)
        self.contentView.addGradient(
            startColor: .designSystem(.redTopGradient)!,
            endColor: .designSystem(.redBottomGradient)!
        )
        self.contentView.roundCorners(8)
        self.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.4).cgColor)
    }
}
