//
//  GivePaymentCardCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import DonWorryExtensions
import Kingfisher

struct GivePaymentCardCellViewModel: Equatable {
    var takerID: Int
    var imageURL: String
    var nickName: String
    var amount: Int
    var isCompleted: Bool
}

final class GivePaymentCardCollectionViewCell: UICollectionViewCell {

    lazy var wholeStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .center
        v.distribution = .equalSpacing
        return v
    }()

    lazy var profileStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .center
        v.distribution = .fill
        v.spacing = 10
        return v
    }()
    lazy var profileImageView: UIImageView = {
        let v = UIImageView()
        v.layer.borderColor = UIColor.designSystem(.white)?.cgColor
        v.layer.borderWidth = 1
        v.contentMode = .scaleAspectFill
        return v
    }()
    lazy var nickNameLabel: UILabel = {
        let v = UILabel()
        v.textColor = .designSystem(.white)
        v.font = .designSystem(weight: .heavy, size: ._15)
        v.textAlignment = .center
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
        v.text = "줄돈"
        v.textAlignment = .center
        return v
    }()
    lazy var moneyLabel: UILabel = {
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

    var viewModel: GivePaymentCardCellViewModel? {
        didSet {
            self.nickNameLabel.text = viewModel?.nickName
            if let amountText = Formatter.amountFormatter.string(from: NSNumber(value: viewModel?.amount ?? 0)) {
                self.moneyLabel.text = amountText + "원"
            }
            if let viewModel = viewModel {
                let urlString = URL(string: viewModel.imageURL)
                profileImageView.kf.setImage(with: urlString)
            }
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
        self.contentView.backgroundColor = .designSystem(.brown)
        self.contentView.addSubview(self.wholeStackView)
        self.contentView.addSubview(self.completeCoverView)
        self.wholeStackView.addArrangedSubview(self.profileStackView)
        self.wholeStackView.addArrangedSubview(self.descriptionStackView)
        self.profileStackView.addArrangedSubview(self.profileImageView)
        self.profileStackView.addArrangedSubview(self.nickNameLabel)
        self.descriptionStackView.addArrangedSubview(self.descriptionLabel)
        self.descriptionStackView.addArrangedSubview(self.moneyLabel)

        self.wholeStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().inset(19)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        self.profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        self.completeCoverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.profileImageView.roundCorners(30)
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
