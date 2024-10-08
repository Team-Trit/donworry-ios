//
//  ProfileTableViewAccountCell.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import RxSwift
import SnapKit

final class ProfileTableViewAccountCell: UITableViewCell {
    static let identifier = "ProfileTableViewAccountCell"
    private lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.text = "나의 계좌"
        v.font = .designSystem(weight: .heavy, size: ._15)
        return v
    }()
    private lazy var accountInfoView: UIView = {
        let v = UIView()
        v.backgroundColor = .designSystem(.grayF6F6F6)
        v.layer.cornerRadius = 8
        return v
    }()
    lazy var bankLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .heavy, size: ._13)
        return v
    }()
    lazy var accountLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .regular, size: ._13)
        v.textColor = .designSystem(.gray818181)
        return v
    }()
    lazy var holderLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .regular, size: ._13)
        v.textColor = .designSystem(.gray818181)
        return v
    }()
    lazy var editButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "pencil"), for: .normal)
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
extension ProfileTableViewAccountCell {
    private func setUI() {
        accountInfoView.addSubviews(bankLabel, accountLabel, holderLabel, editButton)
        contentView.addSubviews(descriptionLabel, accountInfoView, separatorLine)

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview()
        }
        
        accountInfoView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
        }
        
        bankLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview().offset(20)
        }
        
        accountLabel.snp.makeConstraints { make in
            make.top.equalTo(bankLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        holderLabel.snp.makeConstraints { make in
            make.leading.equalTo(accountLabel.snp.trailing).offset(5)
            make.centerY.equalTo(accountLabel.snp.centerY)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(accountInfoView.snp.bottom).offset(15)
            make.width.equalTo(340)
            make.height.equalTo(1)
        }
    }
}
