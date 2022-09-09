//
//  AccountInputField.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import SnapKit

public enum AccountInputFieldType {
    case EnterUserInfo
    case PaymentCardDeco
}

final public class AccountInputField: UIView {
    public lazy var chooseBankButton: UIButton = {
        let v = UIButton()
        v.setTitle("은행 선택", for: .normal)
        v.setTitleColor(.designSystem(.white), for: .normal)
        v.titleLabel?.font = .designSystem(weight: .regular, size: ._10)
        v.titleLabel?.textAlignment = .center
        v.layer.cornerRadius = 15
        v.backgroundColor = .designSystem(.grayC5C5C5)
        return v
    }()
    public lazy var holderTextField = LimitTextField(frame: .zero, type: .holder)
    public lazy var accountTextField = LimitTextField(frame: .zero, type: .account)
    private var type: AccountInputFieldType
    
    public init(frame: CGRect, type: AccountInputFieldType) {
        self.type = type
        super.init(frame: frame)
        setUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper
extension AccountInputField {
    private func setUI() {
        self.addSubview(chooseBankButton)
        self.addSubview(holderTextField)
        self.addSubview(accountTextField)
    
        self.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        switch type {
        case .EnterUserInfo:
            chooseBankButton.snp.makeConstraints { make in
                make.top.leading.equalToSuperview()
                make.width.equalTo(90)
                make.height.equalTo(30)
            }
            
            holderTextField.snp.makeConstraints { make in
                make.leading.equalTo(chooseBankButton.snp.trailing).offset(10)
                make.trailing.equalToSuperview()
            }
            
            accountTextField.snp.makeConstraints { make in
                make.top.equalTo(chooseBankButton.snp.bottom).offset(35)
                make.leading.trailing.equalToSuperview()
            }
            
        case .PaymentCardDeco:
            chooseBankButton.snp.makeConstraints { make in
                make.top.leading.equalToSuperview()
                make.width.equalTo(75)
                make.height.equalTo(30)
            }
            
            holderTextField.snp.makeConstraints { make in
                make.leading.equalTo(chooseBankButton.snp.trailing).offset(10)
                make.trailing.equalToSuperview()
            }
            
            accountTextField.snp.makeConstraints { make in
                make.top.equalTo(chooseBankButton.snp.bottom).offset(35)
                make.leading.trailing.equalToSuperview()
            }
        }
    }
}
