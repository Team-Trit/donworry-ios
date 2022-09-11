//
//  PaymentCardView.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import DonWorryExtensions
import Models
import Kingfisher

struct PaymentCardViewModel {
    public var id: String
    public var name: String
    public var cardIconImageName: String
    public var totalAmount: Int
    public var payer: User
    public var backgroundColor: String
    public var date: Date
    public var bankAccount: BankAccount?
    public var images: [String]?
    public var participatedUserList: [User]

}

struct PaymentCardUserViewModel {
    var imageURL: String?
    var nickName: String
}

public class PaymentCardView: UIView {

    func setColor(by color: CardColor) {
        self.backgroundColor = UIColor(hex: color.rawValue)?.withAlphaComponent(0.72)
        self.cardSideView.backgroundColor = UIColor(hex: color.rawValue)
        self.dateLabel.textColor = UIColor(hex: color.rawValue)
    }

    func setBankAccount(_ bankAccount: BankAccount) {
        self.bankLabel.text = bankAccount.bank
        self.accountNumberLabel.text = bankAccount.accountNumber
        self.accountHodlerNameLabel.text = bankAccount.accountHolderName
    }
    
    var viewModel: PaymentCardUserViewModel? {
        didSet {
            self.userNameLabel.text = "13213sdjaksd"
            userImageView.setBasicProfileImageWhenEmpty(with: viewModel?.imageURL)
        }
    }
    
    // MARK: - Constructors

    override init(frame: CGRect) {
        super.init(frame: frame)
        attributes()
        layout()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Views
    
    lazy var nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "정산항목"
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .heavy, size: ._15)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())

    lazy var iconBox: UIStackView = {
        $0.backgroundColor = .designSystem(.white)
        $0.layer.cornerRadius = 5
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())

    lazy var icon: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    lazy var totalAmountLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "0원"
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .heavy, size: ._20)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())

    lazy var bankLabel: UILabel = {
        $0.text = "은행명"
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .bold, size: ._13)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    
    lazy var accountNumberLabel: UILabel = {
        $0.text = "000-000-000000"
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .regular, size: ._13)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    
    lazy var accountHodlerNameLabel: UILabel = { // 예금주
        $0.text = "(예금주)"
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .regular, size: ._13)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    
    lazy var dateLabel: UILabel = {
        $0.text = "00/00"
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .bold, size: ._9)
        $0.backgroundColor = UIColor(hex: "#F6F6F6FF")?.withAlphaComponent(80) // op 80
        $0.textColor = UIColor(hex: "#FF5454FF") // op 100
        $0.textAlignment = .center
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
        return $0
    }(UILabel())
    
    lazy var userStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    lazy var userImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "profile-sample")
        $0.contentMode = .scaleAspectFill
        $0.frame.size.width = 30
        $0.frame.size.height = 30
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())
    
    lazy var userNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "정산자"
        $0.numberOfLines = 1
        $0.adjustsFontSizeToFitWidth = true
        $0.font = .designSystem(weight: .heavy, size: ._15)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    
    lazy var cardSideView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "#FF5454FF")
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return $0
    }(UIView())

    //MARK: - attributes
    
    func attributes() {
        layer.cornerRadius = 20
    }
    
    //MARK: - layout
    func layout() {
        translatesAutoresizingMaskIntoConstraints = false //autolayout 설정
        widthAnchor.constraint(equalToConstant: 340).isActive = true
        heightAnchor.constraint(equalToConstant: 216).isActive = true
        
        addSubviews(nameLabel, iconBox, totalAmountLabel,bankLabel, accountNumberLabel, accountHodlerNameLabel,cardSideView)
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            iconBox.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            iconBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconBox.widthAnchor.constraint(equalToConstant: 37),
            iconBox.heightAnchor.constraint(equalToConstant: 37),
            
            totalAmountLabel.leftAnchor.constraint(equalTo: iconBox.rightAnchor , constant: 7),
            totalAmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bankLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            bankLabel.bottomAnchor.constraint(equalTo: accountNumberLabel.topAnchor, constant: -10),
            
            accountNumberLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            accountNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            accountHodlerNameLabel.leftAnchor.constraint(equalTo: accountNumberLabel.rightAnchor, constant: 10),
            accountHodlerNameLabel.centerYAnchor.constraint(equalTo: accountNumberLabel.centerYAnchor),
            
            cardSideView.rightAnchor.constraint(equalTo: rightAnchor),
            cardSideView.topAnchor.constraint(equalTo: topAnchor),
            cardSideView.widthAnchor.constraint(equalToConstant: 84),
            cardSideView.heightAnchor.constraint(equalToConstant: 216),
            
        ])
        
        
        iconBox.addSubviews(icon)
        NSLayoutConstraint.activate([
            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        cardSideView.addSubviews(dateLabel, userStackView)
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: cardSideView.centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
            dateLabel.widthAnchor.constraint(equalToConstant: 47),
            dateLabel.heightAnchor.constraint(equalToConstant: 24),
            
            userStackView.centerXAnchor.constraint(equalTo: cardSideView.centerXAnchor),
            userStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            userStackView.leadingAnchor.constraint(equalTo: cardSideView.leadingAnchor, constant: 6),
            userStackView.trailingAnchor.constraint(equalTo: cardSideView.trailingAnchor, constant: -6)
        ])
        
        userStackView.addArrangedSubviews(userImageView, userNameLabel)
        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: 30),
            userImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
}
