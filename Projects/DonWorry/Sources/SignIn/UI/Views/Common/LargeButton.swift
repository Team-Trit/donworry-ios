//
//  LargeButton.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

final class LargeButton: UIView {
    private let button = UIButton()
    var text = ""
    var isDisabled = false
    
    init(text: String, isDisabled: Bool) {
        self.text = text
        self.isDisabled = isDisabled
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
extension LargeButton {
    private func attributes() {
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        button.backgroundColor = isDisabled ? .designSystem(.gray2) : .designSystem(.mainBlue)
        button.layer.cornerRadius = 25
    }
    
    private func layout() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
