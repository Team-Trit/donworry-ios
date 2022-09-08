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
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .heavy)
        let v = UIImageView(image: UIImage(systemName: "rectangle.portrait.and.arrow.right", withConfiguration: configuration))
        v.tintColor = .designSystem(.white)
        return v
    }()

    lazy var circleView: UIView = {
        let v = UIView()
        v.backgroundColor = .designSystem(.grayF6F6F6)
        v.alpha = 0.51
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
        self.contentView.addSubview(self.circleView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.leaveImageView)

        self.circleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(83)
        }
        self.leaveImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom).offset(19.5)
            make.centerX.equalToSuperview()
        }

        self.circleView.roundCorners(83/2)
        self.contentView.addGradient(
            startColor: .designSystem(.redTopGradient)!,
            endColor: .designSystem(.redBottomGradient)!
        )
        self.contentView.roundCorners(8)
        self.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.4).cgColor)
    }
}
