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
    private lazy var bankSearchTextField: UITextField = {
       let v = UITextField()
        v.placeholder = "은행검색"
        v.backgroundColor = .systemGray6
        v.layer.cornerRadius = 7
    
        let leftImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        guard let size = leftImage?.size.width else { return UITextField() }
        let frameView = UIView(frame: CGRect(x: 0, y: 0, width: size + 20, height: size))
        let leftImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: size, height: size))
        leftImageView.image = leftImage
        leftImageView.tintColor = .systemGray
        frameView.addSubview(leftImageView)
        v.leftView = frameView
        v.leftViewMode = .always
    
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension BankSearchTextField {
    private func setUI() {
        addSubview(bankSearchTextField)
        
        bankSearchTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(55)
        }
    }
}
