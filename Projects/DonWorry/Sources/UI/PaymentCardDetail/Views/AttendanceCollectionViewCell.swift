//
//  AttendanceCollectionViewCell.swift
//  DonWorry
//
//  Created by Hankyu Lee on 2022/08/28.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import Kingfisher
import DesignSystem

struct AttendanceCellViewModel {
    let id: Int
    let name: String
    let imgURL: String?
    
}
class AttendanceCollectionViewCell: UICollectionViewCell {

    static let cellID = "attendanceCollectionViewCell"

    var viewModel: AttendanceCellViewModel? {
        didSet {
            self.userNicknameLabel.text = viewModel?.name
            self.userImageView.setBasicProfileImageWhenNilAndEmpty(with: viewModel?.imgURL)
        }
    }

    fileprivate let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setWidth(width: 48)
        imageView.setHeight(height: 48)
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill //
        imageView.clipsToBounds = true
        return imageView
    }()

    fileprivate let userNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .regular, size: ._13)
        label.textColor = .designSystem(.gray818181)
        return label
    }()
    
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userImageView, userNicknameLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        contentView.addSubview(userImageView)
        contentView.addSubview(stackView)
        stackView.alignment = .center
        stackView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
}

