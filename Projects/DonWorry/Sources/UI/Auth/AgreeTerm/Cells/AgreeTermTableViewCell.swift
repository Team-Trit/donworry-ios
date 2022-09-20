//
//  AgreeTermTableViewCell.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import RxSwift
import SnapKit

final class AgreeTermTableViewCell: UITableViewCell {
    static let identifier = "AgreeTermTableViewCell"
    lazy var checkButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "circle"), for: .normal)
        v.tintColor = .designSystem(.grayC5C5C5)
        return v
    }()
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textColor = .designSystem(.gray818181)
        v.font = .designSystem(weight: .regular, size: ._15)
        return v
    }()
    lazy var linkButton: UIButton = {
        let v = UIButton()
        v.setTitleColor(.designSystem(.gray818181), for: .normal)
        v.titleLabel?.font = .designSystem(weight: .regular, size: ._15)
        return v
    }()
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
extension AgreeTermTableViewCell {
    private func setUI() {
        contentView.addSubviews(checkButton, titleLabel, linkButton)
        
        checkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-3)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        linkButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
