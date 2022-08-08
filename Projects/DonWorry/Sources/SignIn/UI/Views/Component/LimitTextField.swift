//
//  LimitTextField.swift
//  DonWorryTests
//
//  Created by 김승창 on 2022/08/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final class LimitTextField: UIView {
    var placeholder: String?
    var limit: Int?
    var textCount = 0
    private let textField = UITextField()
    private let line = UILabel()
    private let limitLabel = UILabel()
    
    init(placeholder: String, limit: Int) {
        self.placeholder = placeholder
        self.limit = limit
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        attributes()
        layout()
    }
}

// MARK: - Configurations
extension LimitTextField {
    private func attributes() {
        guard let placeholder = placeholder, let limit = limit else { return }
        setTextField(placeholder: placeholder)
        setLine()
        setLimitLabel(limit: limit)
    }
    
    private func layout() {
        setTextFieldLayout()
        setLineLayout()
        setLimitLabelLayout()
    }
    
    // MARK: - Attibutes Helper
    private func setTextField(placeholder: String) {
        /// clear button reference : https://woongsios.tistory.com/315
        textField.placeholder = placeholder
        textField.clearButtonMode = .whileEditing
        addSubview(textField)
    }
    
    private func setLine() {
        line.backgroundColor = textCount == 0 ? .designSystem(.gray2) : .designSystem(.mainBlue)
        addSubview(line)
    }
    
    private func setLimitLabel(limit: Int) {
        limitLabel.text = "\(textCount)/\(limit)"
        limitLabel.textColor = .designSystem(.gray2)
        limitLabel.font = .systemFont(ofSize: 10)
        addSubview(limitLabel)
    }
    
    // MARK: - Layout Helper
    private func setTextFieldLayout() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setLineLayout() {
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 1),
            line.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10)
        ])
    }
    
    private func setLimitLabelLayout() {
        limitLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            limitLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            limitLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 10)
        ])
    }
}
