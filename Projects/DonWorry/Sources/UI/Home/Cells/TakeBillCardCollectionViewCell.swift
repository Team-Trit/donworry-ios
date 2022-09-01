//
//  TakeBillCardCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

struct TakeBillCardCellViewModel: Equatable {
    var amount: String
    var isCompleted: Bool
}

final class TakeBillCardCollectionViewCell: UICollectionViewCell {

    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .bold, size: ._13)
        v.textColor = .designSystem(.white)
        v.text = "받을 돈"
        return v
    }()

    lazy var descriptionStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .center
        v.distribution = .fill
        v.spacing = 5
        return v
    }()
    lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.textColor = .designSystem(.white)
        v.font = .designSystem(weight: .bold, size: ._13)
        v.text = "미정산"
        v.textAlignment = .center
        return v
    }()
    lazy var amountLabel: UILabel = {
        let v = UILabel()
        v.textColor = .designSystem(.white)
        v.font = .designSystem(weight: .heavy, size: ._20)
        v.textAlignment = .center
        return v
    }()
    lazy var completeCoverView: UIView = {
        let v = UIView()
        v.isHidden = true
        return v
    }()

    var viewModel: TakeBillCardCellViewModel? {
        didSet {
            self.amountLabel.text = viewModel?.amount
            if let viewModel = viewModel {
                completeCoverView.isHidden = !viewModel.isCompleted
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setUI()
    }

    private func setUI() {
        self.contentView.backgroundColor = .designSystem(.green)
        self.contentView.addSubview(self.completeCoverView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descriptionStackView)
        self.descriptionStackView.addArrangedSubview(self.descriptionLabel)
        self.descriptionStackView.addArrangedSubview(self.amountLabel)

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(14)
        }
        self.descriptionStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.completeCoverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.contentView.roundCorners(8)
        self.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.4).cgColor)
        self.addCompleteCoverViewBlurEffect()
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }

    private func addCompleteCoverViewBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = completeCoverView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addCompleteCheckImageView(to: blurEffectView)
        self.completeCoverView.addSubview(blurEffectView)
    }

    private func addCompleteCheckImageView(to superView: UIVisualEffectView) {
        let checkImageView = UIImageView(image: .init(.ic_check_white))
        superView.contentView.addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(36)
        }
    }
}
