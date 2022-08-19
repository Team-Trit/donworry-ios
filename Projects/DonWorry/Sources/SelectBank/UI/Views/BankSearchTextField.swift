//
//  BankSearchTextField.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import SnapKit

final class BankSearchTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper
extension BankSearchTextField {
    private func configure() {
        self.placeholder = "은행검색"
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 7
    
        let leftImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        guard let size = leftImage?.size.width else { return }
        let frameView = UIView(frame: CGRect(x: 0, y: 0, width: size + 20, height: size))
        let leftImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: size, height: size))
        leftImageView.image = leftImage
        leftImageView.tintColor = .systemGray
        frameView.addSubview(leftImageView)
        self.leftView = frameView
        self.leftViewMode = .always
    }
}
