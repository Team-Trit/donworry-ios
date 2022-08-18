//
//  RoomCodeStackView.swift
//  DonWorry
//
//  Created by 임영후 on 2022/08/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class RoomCodeTextField: UIStackView {
    
    private lazy var roomCodeTextField = LimitTextField(placeholder: "정산방 코드를 입력해주세요", limit: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension RoomCodeTextField {
    private func setUI() {
        
        addSubview(roomCodeTextField)
        
        roomCodeTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
    }
}
