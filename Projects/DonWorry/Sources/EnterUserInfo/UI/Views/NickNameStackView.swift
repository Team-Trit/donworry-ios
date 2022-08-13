//
//  NickNameStackView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/12.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class NickNameStackView: UIStackView {
    private lazy var nickNameStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 20
        v.alignment = .leading
        return v
    }()
    private lazy var nickNameLabel: UILabel = {
       let v = UILabel()
        v.text = "닉네임"
        v.font = .designSystem(weight: .bold, size: ._18)
        return v
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
