//
//  EmptyCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import DonWorryExtensions
import SnapKit
import SkeletonView

final class EmptyPaymentCardView: UIView {

    lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 20
        v.distribution = .fill
        v.alignment = .center
        return v
    }()

    lazy var emptyImageView: UIImageView = {
        let v = UIImageView(image: .init(.ic_calculation_3d))
        v.contentMode = .scaleAspectFit
        return v
    }()

    lazy var boxView: UIView = {
        let v = UIView()
        v.backgroundColor = .designSystem(.grayF6F6F6)
        return v
    }()

    lazy var emptyLabel: UILabel = {
        let v = UILabel()
        v.text = "정산방을 만들거나, 검색하여 정산을 시작하세요!"
        v.font = UIFont.designSystem(weight: .regular, size: ._13)
        v.textColor = .designSystem(.gray818181)
        v.textAlignment = .left
        v.isSkeletonable = true
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
        self.backgroundColor = .designSystem(.white)

        self.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.emptyImageView)
        self.stackView.addArrangedSubview(self.boxView)
        self.boxView.addSubview(self.emptyLabel)

        commonAttribute(of: self)
        commonAttribute(of: stackView)
        commonAttribute(of: emptyLabel)
        commonAttribute(of: boxView)
        commonAttribute(of: emptyImageView)

        self.stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        }
        self.boxView.snp.makeConstraints { make in
            make.height.equalTo(62)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        self.emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
        }
        self.emptyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(207)
        }

        self.boxView.roundCorners(20)
    }

    private func commonAttribute(of target: UIView) {
        target.isSkeletonable = true
    }
}
