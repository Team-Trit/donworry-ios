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

struct ParticipantCellViewModel: Hashable {
    let id: Int
    let imageURL: String?
    let nickname: String
}

final class ParticipantCollectionViewCell: UICollectionViewCell {

    lazy var crownImageView: UIImageView = {
        let v = UIImageView(image: UIImage(.ic_crown))
        v.isHidden = true
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
        v.textColor = .black
        v.numberOfLines = 2
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
        contentView.addSubview(profileImageView)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(crownImageView)
        
        crownImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(profileImageView.snp.top).offset(10)
        }
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        profileImageView.roundCorners(24)
    }
}
