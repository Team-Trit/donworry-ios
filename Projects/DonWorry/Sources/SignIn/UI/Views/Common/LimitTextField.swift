//
//  LimitTextField.swift
//  DonWorryTests
//
//  Created by 김승창 on 2022/08/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final class LimitTextField: UIView {
    private let textField = UITextField()
    private let line = UILabel()
    private let limitLabel = UILabel()
    private var limit: Int?
    private var textCount = 0
    
    init(placeholder: String) {
        super.init(frame: .zero)
        commonInit()
        textField.placeholder = placeholder
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init(placeholder: String, limit: Int) {
        self.init(placeholder: placeholder)
        self.limit = limit
        setLimitLabel()
        setLimitLabelLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        attributes()
        layout()
    }
}

// MARK: - Configurations
extension LimitTextField {
    private func attributes() {
        setTextField()
        setLine()
    }
    
    private func layout() {
        setTextFieldLayout()
        setLineLayout()
    }
    
    // MARK: - Attibutes Helper
    private func setTextField() {
        /// clear button reference : https://woongsios.tistory.com/315
        textField.clearButtonMode = .whileEditing
    }
    
    private func setLine() {
        line.backgroundColor = textCount == 0 ? .designSystem(.gray2) : .designSystem(.mainBlue)
    }
    
    private func setLimitLabel() {
        guard let limit = limit else { return }
        limitLabel.text = "\(textCount)/\(limit)"
        limitLabel.textColor = .designSystem(.gray2)
        limitLabel.font = .systemFont(ofSize: 10)
    }
    
    // MARK: - Layout Helper
    private func setTextFieldLayout() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setLineLayout() {
        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 1),
            line.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10)
        ])
    }
    
    private func setLimitLabelLayout() {
        addSubview(limitLabel)
        limitLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            limitLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            limitLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 10)
        ])
    }
}
