//
//  RecievedMoneyTableViewCell.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

class RecievedMoneyTableViewCell: BaseTableViewCell {
    
    static let identifier: String = "RecievedMoneyTableViewCell"
    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.image = UIImage(named: "ProfileImage")
        return profileImage
    }()
    
    private let userName: UILabel = {
        let userName = UILabel()
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return userName
    }()
    
    private let recievedMoney: UILabel = {
        let recievedMoney = UILabel()
        recievedMoney.translatesAutoresizingMaskIntoConstraints = false
        recievedMoney.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        return recievedMoney
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        contentView.addSubview(profileImage)
        profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        contentView.addSubview(userName)
        userName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12).isActive = true
        userName.widthAnchor.constraint(equalToConstant: 39).isActive = true
        
        contentView.addSubview(recievedMoney)
        recievedMoney.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        recievedMoney.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        recievedMoney.widthAnchor.constraint(equalToConstant: 61).isActive = true
        
    }
    
    func configure(name: String, money: Int) {
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        userName.text = name
        recievedMoney.text = numberformatter.string(for: money)! + "원"
    }
    
}
