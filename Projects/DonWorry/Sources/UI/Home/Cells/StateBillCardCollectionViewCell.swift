//
//  StateBillCardCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import DonWorryExtensions

final class StateBillCardCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "StateBillCardCollectionViewCell"
    lazy var periodLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .heavy, size: ._30)
        v.textColor = .designSystem(.white)
        v.text = "•••"
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
        v.text = "참석확인 중"
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
        self.contentView.addSubview(self.periodLabel)

        self.circleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(83)
        }
        self.periodLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom).offset(19.5)
            make.centerX.equalToSuperview()
        }

        self.circleView.roundCorners(83/2)
        self.contentView.addGradient(
            startColor: .designSystem(.blueTopGradient)!,
            endColor: .designSystem(.blueBottomGradient)!
        )
        self.contentView.roundCorners(8)
        self.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.4).cgColor)
    }
}
