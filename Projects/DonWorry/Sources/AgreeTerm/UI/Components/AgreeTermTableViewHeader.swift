//
//  AgreeTermTableViewHeader.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem

protocol AgreeTermTableViewHeaderDelegate: AnyObject {
    func toggleCheck(_ sender: UIButton)
    func showDetail(_ sender: UIButton)
}

final class AgreeTermTableViewHeader: UITableViewHeaderFooterView {
    static let identifier = "AgreeTermTableViewHeader"
    lazy var checkButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "circle"), for: .normal)
        v.tintColor = .designSystem(.grayC5C5C5)
        v.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
        return v
    }()
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textColor = .designSystem(.gray818181)
        v.font = .designSystem(weight: .regular, size: ._15)
        return v
    }()
    lazy var showDetailButton: UIButton = {
        let v = UIButton()
        v.tintColor = .designSystem(.gray818181)
//        v.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        v.addTarget(self, action: #selector(showDetailButtonPressed(_:)), for: .touchUpInside)
        return v
    }()
    weak var delegate: AgreeTermTableViewHeaderDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension AgreeTermTableViewHeader {
    private func setUI() {
        contentView.backgroundColor = .white

        contentView.addSubviews(checkButton, titleLabel, showDetailButton)
        
        checkButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
        
        showDetailButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Interaction Functions
extension AgreeTermTableViewHeader {
    @objc private func checkButtonPressed(_ sender: UIButton) {
        delegate?.toggleCheck(sender)
    }
    
    @objc private func showDetailButtonPressed(_ sender: UIButton) {
        delegate?.showDetail(sender)
    }
}
