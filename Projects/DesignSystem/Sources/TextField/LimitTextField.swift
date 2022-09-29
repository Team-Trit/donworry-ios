//
//  LimitTextField.swift
//  DesignSystem
//
//  Created by 김승창 on 2022/08/19.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import SnapKit

public enum LimitTextFieldType {
    case nickName   // 닉네임을 입력해주세요, limit : 8, 한글과 영어, 숫자만 입력
    case holder     // 예금주명을 입력해주세요, limit : 10, 한글만 입력
    case account    // 계좌번호를 입력해주세요, 숫자만 입력
    
    case roomCode  // 정산방 코드를 입력해주세요, 숫자와 영어와 '-'만 입력
    case roomName  // 정산방 이름을 입력하세요, limit : 12, 한글과 영어와 숫자만 입력
    
    case paymentTitle  // 정산하고자 하는 항목을 입력하세요, limit : 12, 한글과 영어와 숫자만 입력
}

final public class LimitTextField: UIView {
    var type: LimitTextFieldType
    public lazy var textField: PaddedTextField = {
        let v = PaddedTextField()
        v.clearButtonMode = .whileEditing
        v.delegate = self
        v.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return v
    }()
    private lazy var line: UILabel = {
        let v = UILabel()
        v.backgroundColor = textField.text!.isEmpty ? .designSystem(.grayC5C5C5) : .designSystem(.mainBlue)
        return v
    }()
    var descriptionLabel: UILabel?
    private var limit: Int?
    private var limitLabel: UILabel?
    
    public init(frame: CGRect, type: LimitTextFieldType) {
        self.type = type
        super.init(frame: frame)
        configure()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper
extension LimitTextField {
    private func configure() {
        var placeholder = ""
        switch type {
        case .nickName:
            placeholder = "닉네임을 입력해주세요"
            self.limit = 8
            self.descriptionLabel = UILabel()
            descriptionLabel?.text = "영문 + 숫자 + 한글을 사용하여 8자 이내 조합"
            descriptionLabel?.textColor = .designSystem(.grayC5C5C5)
            descriptionLabel?.font = .designSystem(weight: .regular, size: ._9)
        case .holder:
            placeholder = "예금주명을 입력해주세요"
            self.limit = 10
        case .account:
            placeholder = "계좌번호를 입력해주세요"
            textField.keyboardType = .decimalPad
        case .roomCode:
            placeholder = "정산방 코드를 입력해주세요"
        case .roomName:
            placeholder = "정산방 이름을 입력하세요"
            self.limit = 10
        case .paymentTitle:
            placeholder = "정산하고자 하는 항목을 입력하세요"
            self.limit = 10
        }
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: UIFont.designSystem(weight: .regular, size: ._13)])
        
        if let limit = limit {
            limitLabel = UILabel()
            limitLabel!.text = "0/\(limit)"
            limitLabel!.textColor = .designSystem(.grayC5C5C5)
            limitLabel!.font = .designSystem(weight: .regular, size: ._9)
        }
    }
    
    private func setUI() {
        addSubview(textField)
        addSubview(line)
        
        textField.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        line.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        if limit != nil {
            addSubview(limitLabel!)
            limitLabel!.snp.makeConstraints { make in
                make.top.equalTo(line.snp.bottom).offset(10)
                make.trailing.equalToSuperview()
            }
        }
        
        if type == .nickName {
            addSubview(descriptionLabel!)
            descriptionLabel!.snp.makeConstraints { make in
                make.top.equalTo(line.snp.bottom).offset(10)
                make.leading.equalToSuperview()
            }
        }
    }
}

// MARK: - Interaction Functions
extension LimitTextField {
    @objc private func textFieldDidChange(_ sender: UITextField) {
        line.backgroundColor = .designSystem(sender.text?.count == 0 ? .grayC5C5C5 : .mainBlue)
        guard let limit = limit else { return }
        
        if (sender.text?.count)! >= limit {
            let text = textField.text!
            let index = text.index(text.startIndex, offsetBy: limit)
            let newString = text[text.startIndex..<index]
            textField.text = String(newString)
        }
        let count = (sender.text?.count)!
        limitLabel?.text = "\(count)/\(limit)"
        
        if self.type == .nickName {
            descriptionLabel?.isHidden = count > 0 ? true : false
        }
    }
}

// MARK: - UITextFieldDelegate
extension LimitTextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var pattern = ""
        
        switch type {
        case .nickName:
            pattern = "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ]*$"
            
        case .holder:
            pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣ]*$"
            
        case .account:
            pattern = "^[0-9]*$"
            
        case .roomCode:
            pattern = "^[a-zA-Z0-9-]*$"
            
        case .roomName, .paymentTitle:
            pattern = "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]*$"
        }
        
        guard let _ = string.range(of: pattern, options: .regularExpression) else { return false }
        return true
    }
}
