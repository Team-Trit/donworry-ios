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
    case nickName   // 닉네임을 입력해주세요, limit : 10, 한글과 영어만 입력
    case holder     // 예금주명을 입력해주세요, limit : 20, 한글과 영어만 입력
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
            self.limit = 10
        case .holder:
            placeholder = "예금주명을 입력해주세요"
            self.limit = 20
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
    }
}

// MARK: - UITextFieldDelegate
extension LimitTextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        
        switch type {
        case .nickName, .holder:
            if string.hasCharacters() || isBackSpace == -92 {
                return true
            }
            return false
            
        case .account:
            guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                 return false
            }
            return true
            
        case .roomCode:
            if string.hasAlphabetsNumsHyphens() || isBackSpace == -92 {
                return true
            }
            return false
            
        case .roomName, .paymentTitle:
            if string.hasCharNums() || isBackSpace == -92 {
                return true
            }
            return false
        }
    }
}

// MARK: - String Extension
extension String {
    func hasCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ\\s]$", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        return false
    }
    
    func hasCharNums() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]$", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        return false
    }
    
    func hasAlphabetsNumsHyphens() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9-\\s]$", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        return false
    }
}
