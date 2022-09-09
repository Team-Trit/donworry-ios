//
//  ProfileTableViewServiceCell.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import RxSwift
import SnapKit

final class ProfileTableViewServiceCell: UITableViewCell {
    static let identifier = "ProfileTableViewServiceCell"
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .regular, size: ._15)
        return v
    }()
    private lazy var chevronImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(systemName: "chevron.right")
        v.tintColor = .designSystem(.gray4B4A4A)
        return v
    }()
    private lazy var separatorLine = SeparatorLine()
    var disposeBag = DisposeBag()
    
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
        contentView.addSubviews(titleLabel, chevronImageView, separatorLine)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.width.equalTo(340)
            make.height.equalTo(1)
        }
    }
}
