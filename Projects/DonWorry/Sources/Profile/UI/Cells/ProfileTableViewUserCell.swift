//
//  ProfileTableViewUserCell.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class ProfileTableViewUserCell: UITableViewCell {
    static let identifier = "ProfileTableViewUserCell"
    private lazy var profileLabel: UILabel = {
        let v = UILabel()
        v.text = "내 정보"
        v.textColor = .designSystem(.black)
        v.font = .designSystem(weight: .heavy, size: ._25)
        return v
    }()
    private lazy var profileImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 25
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()
    private lazy var nickNameLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .bold, size: ._20)
        return v
    }()
    private lazy var nameLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .light, size: ._15)
        return v
    }()
    private lazy var editButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "pencil"), for: .normal)
        v.tintColor = .designSystem(.black)
        //        v.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        return v
    }()
    var user: ProfileViewModelItem? {
        didSet {
            guard let user = user as? ProfileViewModelUserItem else { return }
            profileImageView.image = UIImage(named: user.imageURL)
            nickNameLabel.text = user.nickName
            nameLabel.text = user.name
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
extension ProfileTableViewUserCell {
    private func setUI() {
        contentView.addSubviews(profileLabel, profileImageView, nickNameLabel, nameLabel, editButton)
        
        profileLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).offset(26)
            make.width.height.equalTo(50)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).offset(26)
            make.leading.equalTo(profileImageView.snp.trailing).offset(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(7)
            make.leading.equalTo(profileImageView.snp.trailing).offset(30)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).offset(26)
            make.trailing.equalToSuperview()
        }
    }
}
