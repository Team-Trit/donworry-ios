//
//  NickNameStackView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/12.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import SnapKit

final class NickNameStackView: UIStackView {
    private lazy var nickNameStackView: UIStackView = {
        let nickNameStackView = UIStackView()
        nickNameStackView.axis = .vertical
        nickNameStackView.spacing = 20
        nickNameStackView.alignment = .leading
        return nickNameStackView
    }()
    private lazy var nickNameLabel: UILabel = {
       let nickNameLabel = UILabel()
        nickNameLabel.text = "닉네임"
        nickNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        return nickNameLabel
    }()
    private lazy var nickNameTextField = LimitTextField(placeholder: "닉네임을 입력해주세요", limit: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension NickNameStackView {
    private func setUI() {
        nickNameStackView.addArrangedSubview(nickNameLabel)
        nickNameStackView.addArrangedSubview(nickNameTextField)
        addSubview(nickNameStackView)
        
        nickNameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        nickNameStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
    }
}
