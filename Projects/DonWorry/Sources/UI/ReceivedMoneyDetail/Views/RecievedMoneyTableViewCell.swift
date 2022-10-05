//
//  RecievedMoneyTableViewCell.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import DonWorryExtensions
import BaseArchitecture
import Kingfisher

struct RecievingCellViewModel {
    let id: Int
    let name: String
    let money: Int
    let receiverID: Int
    var isCompleted: Bool = false
    let imgURL: String?
}

final class RecievedMoneyTableViewCell: UITableViewCell {
    
    static let identifier: String = "RecievedMoneyTableViewCell"
    
    private let profileImageView: UIImageView = {
        let profileImage = UIImageView()
        profileImage.contentMode = .scaleAspectFill
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        return profileImage
    }()
    
    private let userNameLabel: UILabel = {
        let userName = UILabel()
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.textAlignment = .left
        userName.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return userName
    }()
    
    private let recievedMoneyLabel: UILabel = {
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
        contentView.addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true

        contentView.addSubview(userNameLabel)
        userNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12).isActive = true
        userNameLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        contentView.addSubview(recievedMoneyLabel)
        recievedMoneyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        recievedMoneyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        recievedMoneyLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true

        profileImageView.roundCorners(25)
    }
    
    func configure(_ content: RecievingCellViewModel) {
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        userNameLabel.text = content.name
        profileImageView.kf.indicatorType = .activity
        profileImageView.setBasicProfileImageWhenNilAndEmpty(with: content.imgURL)
        recievedMoneyLabel.text = numberformatter.string(for: content.money)! + "원"
        if content.isCompleted {
            profileImageView.layer.opacity = 0.5
            userNameLabel.layer.opacity = 0.5
            recievedMoneyLabel.layer.opacity = 0.5
        }
    }
    
}
