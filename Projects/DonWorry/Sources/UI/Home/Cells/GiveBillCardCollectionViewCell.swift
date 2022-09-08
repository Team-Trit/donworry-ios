//
//  GiveBillCardCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import DonWorryExtensions
import Kingfisher

struct GiveBillCardCellViewModel: Equatable {
    var id: Int
    var takerID: Int
    var imageURL: String?
    var nickName: String
    var amount: String
    var isCompleted: Bool
}

final class GiveBillCardCollectionViewCell: UICollectionViewCell {

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
        v.adjustsFontForContentSizeCategory = true
        v.text = "줄돈"

        v.textAlignment = .center
        return v
    }()
    lazy var amountLabel: UILabel = {
        let v = UILabel()
        v.textColor = .designSystem(.white)
        v.font = .designSystem(weight: .heavy, size: ._20)
        v.adjustsFontForContentSizeCategory = true
        v.textAlignment = .center
        return v
    }()

    var viewModel: GiveBillCardCellViewModel? {
        didSet {
            self.nickNameLabel.text = viewModel?.nickName
            self.amountLabel.text = viewModel?.amount
            profileImageView.setWhenNilImageBasicProfileImage(with: viewModel?.imageURL)
            if (viewModel?.isCompleted ?? false) { self.addCompleteView() }
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

        self.wholeStackView.addArrangedSubview(self.profileStackView)
        self.wholeStackView.addArrangedSubview(self.descriptionStackView)
        self.profileStackView.addArrangedSubview(self.profileImageView)
        self.profileStackView.addArrangedSubview(self.nickNameLabel)
        self.descriptionStackView.addArrangedSubview(self.descriptionLabel)
        self.descriptionStackView.addArrangedSubview(self.amountLabel)

        self.wholeStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.bottom.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        self.profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(76)
        }

        self.profileImageView.roundCorners(38)
        self.contentView.roundCorners(8)
        self.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.4).cgColor)
    }

}
