//
//  ProfileTableViewServiceCell.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class ProfileTableViewServiceCell: UITableViewCell {
    static let identifier = "ProfileTableViewServiceCell"
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .regular, size: ._15)
        return v
    }()
    private lazy var chevronImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(systemName: "chevron.right")
        v.tintColor = .designSystem(.black)
        return v
    }()
    var service: ProfileViewModelItem? {
        didSet {
            guard let service = service as? ProfileViewModelServiceItem else { return }
            titleLabel.text = service.label
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension ProfileTableViewServiceCell {
    private func setUI() {
        contentView.addSubviews(titleLabel, chevronImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
    }
}
