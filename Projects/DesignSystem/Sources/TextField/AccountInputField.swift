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

public protocol AccountInputFieldDelegate: AnyObject {
    // TODO: RxFlow로 수정
    func showBankSelectSheet()
}

final public class AccountInputField: UIView {
    private lazy var chooseBankLabel: UILabel = {
        let v = UILabel()
        
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "chevron.down")?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 8)
        attributedString.append(NSAttributedString(string: "은행 선택   "))
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        
        v.attributedText = attributedString
        v.textColor = .white
        v.font = .designSystem(weight: .regular, size: ._9)
        v.textAlignment = .center
        v.clipsToBounds = true
        v.layer.cornerRadius = 15
        v.backgroundColor = .designSystem(.grayC5C5C5)
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseBankLabelPressed)))
        v.isUserInteractionEnabled = true
        return v
    }()
    private lazy var holderTextField = LimitTextField(frame: .zero, type: .holder)
    private lazy var accountTextField = LimitTextField(frame: .zero, type: .account)
    private var type: AccountInputFieldType
    weak public var delegate: AccountInputFieldDelegate?
    
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
        self.addSubview(chooseBankLabel)
        self.addSubview(holderTextField)
        self.addSubview(accountTextField)
        
        switch type {
        case .EnterUserInfo:
            chooseBankLabel.snp.makeConstraints { make in
                make.top.leading.equalToSuperview()
                make.width.equalTo(90)
                make.height.equalTo(30)
            }
            
            holderTextField.snp.makeConstraints { make in
                make.leading.equalTo(chooseBankLabel.snp.trailing).offset(10)
                make.trailing.equalToSuperview()
            }
            
            accountTextField.snp.makeConstraints { make in
                make.top.equalTo(chooseBankLabel.snp.bottom).offset(35)
                make.leading.trailing.equalToSuperview()
            }
            
        case .PaymentCardDeco:
            chooseBankLabel.snp.makeConstraints { make in
                make.top.leading.equalToSuperview()
                make.width.equalTo(75)
                make.height.equalTo(30)
            }
            
            holderTextField.snp.makeConstraints { make in
                make.leading.equalTo(chooseBankLabel.snp.trailing).offset(10)
                make.trailing.equalToSuperview()
            }
            
            accountTextField.snp.makeConstraints { make in
                make.top.equalTo(chooseBankLabel.snp.bottom).offset(35)
                make.leading.trailing.equalToSuperview()
            }
        }
    }
}

// MARK: - Interaction Functions
extension AccountInputField {
    @objc private func chooseBankLabelPressed(sender: UITapGestureRecognizer) {
        delegate?.showBankSelectSheet()
    }
}
