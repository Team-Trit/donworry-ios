//
//  ButtonStackView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class ButtonStackView: UIStackView {
    private lazy var buttonStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 10
        return v
    }()
    private lazy var logoutButton: UIButton = {
        let v = UIButton()
        v.setTitle("로그아웃", for: .normal)
        v.titleLabel?.font = .designSystem(weight: .regular, size: ._13)
        v.setTitleColor(.designSystem(.gray818181), for: .normal)
        return v
    }()
    private lazy var borderLabel: UILabel = {
        let v = UILabel()
        v.text = "|"
        v.font = .designSystem(weight: .regular, size: ._13)
        v.textColor = .designSystem(.gray818181)
        return v
    }()
    
    private lazy var deleteButton: UIButton = {
        let v = UIButton()
        v.setTitle("회원탈퇴", for: .normal)
        v.titleLabel?.font = .designSystem(weight: .regular, size: ._13)
        v.setTitleColor(.designSystem(.gray818181), for: .normal)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension ButtonStackView {
    private func setUI() {
        buttonStackView.addArrangedSubviews(logoutButton, borderLabel, deleteButton)
        addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
