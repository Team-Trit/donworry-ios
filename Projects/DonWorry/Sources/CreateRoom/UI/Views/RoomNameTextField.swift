//
//  NickNameStackView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class RoomNameTextField: UIStackView {
    
    private lazy var roomNameTextField = LimitTextField(placeholder: "정산방 이름을 입력하세요.", limit: 20)
    public convenience init(type: Int) {
        self.init()
        switch (type) {
        case 0:
            roomNameTextField = LimitTextField(placeholder: "정산방 이름을 입력하세요.", limit: 20)
        case 1:
            roomNameTextField = LimitTextField(placeholder: "정산방 이름을 입력하세요.", limit: 20)
        case 2:
            roomNameTextField = LimitTextField(placeholder: "수정할 닉네임을 입력해주세요.", limit: 20)
        default:
            break
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension RoomNameTextField {
    private func setUI() {
        addSubview(roomNameTextField)
        
        roomNameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
    }
}
