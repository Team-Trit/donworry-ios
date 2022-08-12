//
//  AccountInputField.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

protocol AccountInputFieldDelegate: AnyObject {
    /// Delegate Pattern Reference : https://kasroid.github.io/posts/ios/20201010-uikit-delegate-pattern/
    func showBankSelectSheet()
}

final class AccountInputField: UIStackView {
    private let bankHolderStack = UIStackView()
    private let chooseBankLabel = UILabel()
    private let holderTextField = LimitTextField(placeholder: "예금주명을 입력해주세요", limit: 20)
    private let accountTextField = LimitTextField(placeholder: "계좌번호를 입력해주세요")
    weak var delegate: AccountInputFieldDelegate?
    
    init() {
        super.init(frame: .zero)
        attributes()
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
extension AccountInputField {
    private func attributes() {
        axis = .vertical
        spacing = 20
        alignment = .leading
        
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "chevron.down")?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 8)
        attributedString.append(NSAttributedString(string: "은행 선택 "))
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        
        chooseBankLabel.attributedText = attributedString
        chooseBankLabel.textColor = .white
        chooseBankLabel.font = .systemFont(ofSize: 12)
        chooseBankLabel.textAlignment = .center
        chooseBankLabel.clipsToBounds = true
        chooseBankLabel.layer.cornerRadius = 15
        chooseBankLabel.backgroundColor = .designSystem(.gray2)
        chooseBankLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseBankLabelPressed)))
        chooseBankLabel.isUserInteractionEnabled = true
        
        bankHolderStack.axis = .horizontal
        bankHolderStack.spacing = 20
        bankHolderStack.alignment = .center
    }
    
    private func layout() {
        bankHolderStack.addArrangedSubview(chooseBankLabel)
        bankHolderStack.addArrangedSubview(holderTextField)
        
        addSubview(bankHolderStack)
        chooseBankLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chooseBankLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            chooseBankLabel.widthAnchor.constraint(equalToConstant: 90),
            chooseBankLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        holderTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            holderTextField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addArrangedSubview(bankHolderStack)
        setCustomSpacing(40, after: bankHolderStack)
        addArrangedSubview(accountTextField)
        
        accountTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountTextField.topAnchor.constraint(equalTo: bankHolderStack.bottomAnchor, constant: 90),
            accountTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            accountTextField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Interaction Functions
extension AccountInputField {
    @objc private func chooseBankLabelPressed(sender: UITapGestureRecognizer) {
        delegate?.showBankSelectSheet()
    }
}
