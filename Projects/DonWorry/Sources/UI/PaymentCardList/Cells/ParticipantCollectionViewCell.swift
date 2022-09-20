//
//  ParticipantCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/09/20.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import Kingfisher
import DesignSystem
import DonWorryExtensions

struct ParticipantCellViewModel {
    let id: Int
    let imageURL: String?
    let nickname: String
}

final class ParticipantCollectionViewCell: UICollectionViewCell {

    lazy var crownImageView: UIImageView = {
        let v = UIImageView(image: UIImage(.ic_cake))
        v.isHidden = true
        return v
    }()
    lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.alignment = .center
        v.distribution = .fill
        v.axis = .vertical
        v.spacing = 10
        return v
    }()
    lazy var profileImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        return v
    }()
    lazy var nickNameLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .regular, size: ._10)
        v.textColor = .black // .designSystem(.gray818181)
        v.numberOfLines = 1
        v.textAlignment = .center
        return v
    }()

    var viewModel: ParticipantCellViewModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.profileImageView.setBasicProfileImageWhenNilAndEmpty(with: self?.viewModel?.imageURL)
                self?.nickNameLabel.text = self?.viewModel?.nickname
                self?.nickNameLabel.sizeToFit()
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
        contentView.addSubview(crownImageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews(profileImageView,nickNameLabel)

        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
        }
        crownImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(stackView.snp.top)
        }
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(48)
        }

        profileImageView.roundCorners(24)
    }
}
