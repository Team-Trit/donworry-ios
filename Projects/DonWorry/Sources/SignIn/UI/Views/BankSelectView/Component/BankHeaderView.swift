//
//  BankHeaderView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import DesignSystem
import UIKit

final class BankHeaderView: UICollectionReusableView {
    static let bankHeaderViewID = "BankHeaderView"
    private let bankTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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

// MARK: - Configuration
extension BankHeaderView {
    private func attributes() {
        bankTextField.placeholder = "은행검색"
        bankTextField.backgroundColor = .systemGray6
        bankTextField.layer.cornerRadius = 7
        let leftImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        guard let size = leftImage?.size.width else { return }
        let frameView = UIView(frame: CGRect(x: 0, y: 0, width: size + 20, height: size))
        let leftImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: size, height: size))
        leftImageView.image = leftImage
        leftImageView.tintColor = .systemGray
        frameView.addSubview(leftImageView)
        bankTextField.leftView = frameView
        bankTextField.leftViewMode = .always
    }
    
    private func layout() {
        addSubview(bankTextField)
        bankTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bankTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            bankTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            bankTextField.topAnchor.constraint(equalTo: topAnchor),
            bankTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
