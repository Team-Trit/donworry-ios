//
//  RenameTextField.swift
//  DonWorry
//
//  Created by 임영후 on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class RenameTextField: UIStackView {
    
    private lazy var renameTextField = LimitTextField(placeholder: "수정할 닉네임을 입력해주세요.", limit: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension RenameTextField {
    private func setUI() {
        addSubview(renameTextField)
        
        renameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
    }
}
