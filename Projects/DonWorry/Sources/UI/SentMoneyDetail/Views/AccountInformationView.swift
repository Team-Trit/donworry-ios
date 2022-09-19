//
//  AccountInformationView.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

class AccountInformationView: UIView {
    
    private let bankName: UILabel = {
        let bankName = UILabel()
        bankName.translatesAutoresizingMaskIntoConstraints = false
        bankName.font = .designSystem(weight: .regular, size: ._13)
        bankName.textColor = .designSystem(.gray818181)
        return bankName
    }()
    
    private let accountNumber: UILabel = {
        let accountNumber = UILabel()
        accountNumber.translatesAutoresizingMaskIntoConstraints = false
        accountNumber.font = .designSystem(weight: .regular, size: ._13)
        accountNumber.textColor = .designSystem(.gray818181)
        return accountNumber
    }()
    
    private let realName: UILabel = {
        let realName = UILabel()
        realName.translatesAutoresizingMaskIntoConstraints = false
        realName.font = .designSystem(weight: .regular, size: ._13)
        realName.textColor = .designSystem(.gray818181)
        return realName
    }()
    
    private let copyImage: UIImageView = {
        let copyImage = UIImageView()
        copyImage.translatesAutoresizingMaskIntoConstraints = false
        copyImage.image = UIImage(systemName: "doc.on.doc")
        copyImage.tintColor = .designSystem(.gray818181)
        return copyImage
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        addSubview(bankName)
        bankName.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        bankName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        addSubview(accountNumber)
        accountNumber.topAnchor.constraint(equalTo: bankName.bottomAnchor, constant: 7).isActive = true
        accountNumber.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        addSubview(realName)
        realName.centerYAnchor.constraint(equalTo: accountNumber.centerYAnchor).isActive = true
        realName.leadingAnchor.constraint(equalTo: accountNumber.trailingAnchor, constant: 10).isActive = true
        
        addSubview(copyImage)
        copyImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        copyImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        copyImage.widthAnchor.constraint(equalToConstant: 22).isActive = true
        copyImage.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
    }
    
    func configure(bank: String, account: String, name: String) {
        bankName.text = bank
        accountNumber.text = account
        realName.text = "(\(name))"
    }
    

}
