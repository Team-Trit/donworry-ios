//
//  RecievedMoneyTableViewCell.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import BaseArchitecture

struct RecievingCellViewModel {
    let name: String
    let money: Int
    var isCompleted: Bool = false
}

final class RecievedMoneyTableViewCell: UITableViewCell {
    
    static let identifier: String = "RecievedMoneyTableViewCell"
    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.image = UIImage(named: "profiledefaltimage")
        return profileImage
    }()
    
    private let userName: UILabel = {
        let userName = UILabel()
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.textAlignment = .left
        userName.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return userName
    }()
    
    private let recievedMoney: UILabel = {
        let recievedMoney = UILabel()
        recievedMoney.translatesAutoresizingMaskIntoConstraints = false
        recievedMoney.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        recievedMoney.textAlignment = .right
        return recievedMoney
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        contentView.addSubview(profileImage)
        profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        contentView.addSubview(userName)
        userName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12).isActive = true
        userName.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        contentView.addSubview(recievedMoney)
        recievedMoney.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        recievedMoney.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        recievedMoney.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
    }
    
    func configure(_ content: RecievingCellViewModel) {
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        userName.text = content.name
        recievedMoney.text = numberformatter.string(for: content.money)! + "원"
        if content.isCompleted {
            profileImage.layer.opacity = 0.5
            userName.layer.opacity = 0.5
            recievedMoney.layer.opacity = 0.5
        }
    }
    
}
