//
//  AccountInputField.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

#warning("나중에 디자인시스템 공용컴포넌트로 교체예정")

import UIKit

import DesignSystem
import SnapKit

protocol AccountInputFieldDelegate: AnyObject {
    func showBankSelectSheet()
}

final class AccountInputField: UIStackView {
    private lazy var accountInputField: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 40
        v.alignment = .leading
        return v
    }()
    private lazy var bankHolderStack: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 20
        v.alignment = .center
        return v
    }()
    private lazy var chooseBankLabel: UILabel = {
        let v = UILabel()
        
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "chevron.down")?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 8)
        attributedString.append(NSAttributedString(string: "은행 선택 "))
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        
        v.attributedText = attributedString
        v.textColor = .white
        v.font = .designSystem(weight: .regular, size: ._13)
        v.textAlignment = .center
        v.clipsToBounds = true
        v.layer.cornerRadius = 15
        v.backgroundColor = .designSystem(.gray2)
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseBankLabelPressed)))
        v.isUserInteractionEnabled = true
        return v
    }()
    private lazy var holderTextField = LimitTextField(placeholder: "예금주명을 입력해주세요", limit: 20)
    private lazy var accountTextField = LimitTextField(placeholder: "계좌번호를 입력해주세요")
    weak var delegate: AccountInputFieldDelegate?
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension AccountInputField {
    private func setUI() {
        bankHolderStack.addArrangedSubviews(chooseBankLabel, holderTextField)
        accountInputField.addArrangedSubviews(bankHolderStack, accountTextField)
        addSubview(accountInputField)
        
        bankHolderStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        chooseBankLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        
        holderTextField.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
        
        accountTextField.snp.makeConstraints { make in
            make.top.equalTo(bankHolderStack.snp.bottom).offset(400)
            make.leading.trailing.equalToSuperview()
        }
        
        accountInputField.snp.makeConstraints { make in
            make.top.equalTo(bankHolderStack).offset(40)
            make.leading.trailing.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
}

// MARK: - Interaction Functions
extension AccountInputField {
    @objc private func chooseBankLabelPressed(sender: UITapGestureRecognizer) {
//        delegate?.showBankSelectSheet()
    }
}
