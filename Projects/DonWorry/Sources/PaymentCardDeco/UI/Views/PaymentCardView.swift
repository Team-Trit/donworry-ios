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

public class PaymentCardView: UIView {
    
    // MARK: - 카드정산날짜포메팅함수
    
    fileprivate func formatPayDate(s: String) -> (String, String) {
        if s.count > 5 {
            return ("", "MM/YY")
        }
        var num = Array(s)
        if s.count <= 4 {
            num.append(contentsOf: Array("MM/YY")[s.count ... 4])
        }
        var s1 = String(num).replacingOccurrences(of: "Y", with: "").replacingOccurrences(of: "M", with: "")
        if s.count < 3 {
            s1 = s1.replacingOccurrences(of: "/", with: "")
        }
        return (s1, String(num).replacingOccurrences(of: s1, with: ""))
    }
    
    //MARK: - Views
    
    private let nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "정산항목"
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .heavy, size: ._15)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())

    private let iconBox: UIStackView = {
        $0.backgroundColor = .designSystem(.white)
        $0.layer.cornerRadius = 5
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())

    private let icon: UIImageView = {
        $0.image = UIImage(named: "chicken")
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let totalAmountLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "총 130,000원"
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .heavy, size: ._20)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let bankLabel: UILabel = {
        let name = NSMutableAttributedString(string: "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ])
        let placeholder = NSMutableAttributedString(string: "은행명", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])
        name.append(placeholder)
        $0.attributedText = name
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .bold, size: ._13)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let accountNumberLabel: UILabel = {
        let name = NSMutableAttributedString(string: "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ])
        let placeholder = NSMutableAttributedString(string: "000-000-000000", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])
        name.append(placeholder)
        $0.attributedText = name
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .regular, size: ._13)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let accountHodlerNameLabel: UILabel = { // 예금주
        let name = NSMutableAttributedString(string: "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ])
        let placeholder = NSMutableAttributedString(string: "(예금주)", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])
        name.append(placeholder)
        $0.attributedText = name
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .regular, size: ._13)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let dateLabel: UILabel = {
        let name = NSMutableAttributedString(string: "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ])
        let placeholder = NSMutableAttributedString(string: "00/00", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])
        name.append(placeholder)
        $0.attributedText = name
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .bold, size: ._9)
        $0.backgroundColor = UIColor(hex: "#F6F6F6CC") // op 80
        $0.textColor = UIColor(hex: "#FF5454FF") // op 100
        $0.textAlignment = .center
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
        return $0
    }(UILabel())
    
    private let userStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    
    private let userImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "profile-sample")
//        $0.layer.borderColor = UIColor.designSystem(.white)?.cgColor
//        $0.layer.borderWidth = 1
        $0.contentMode = .scaleAspectFill
        $0.frame.size.width = 30
        $0.frame.size.height = 30
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())
    
    private let userNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "정산자"
        $0.numberOfLines = 1
        $0.font = .designSystem(weight: .heavy, size: ._15)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let cardSideView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "#FF5454FF")
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return $0
    }(UIView())

    
    
    // MARK: - Store Properties
    
    var bank: String! {
        didSet {
            if bank == "" {
                let name = NSMutableAttributedString(string: "", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                ])
                let placeholder = NSMutableAttributedString(string: "은행명", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.gray,
                ])
                name.append(placeholder)
                bankLabel.attributedText = name
                return
            }
            let name = NSMutableAttributedString(string: bank, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white,
            ])
            bankLabel.attributedText = name
        }
    }
    
    var accountNumber: String! {
        didSet {
            if accountNumber == "" {
                let name = NSMutableAttributedString(string: "", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                ])
                let placeholder = NSMutableAttributedString(string: "000-000-000000", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.gray,
                ])
                name.append(placeholder)
                accountNumberLabel.attributedText = name
                return
            }
            let name = NSMutableAttributedString(string: accountNumber, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white,
            ])
            accountNumberLabel.attributedText = name
        }
    }
    
    var accountHodlerName: String! {
        didSet {
            if accountHodlerName == "" {
                let name = NSMutableAttributedString(string: "", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                ])
                let placeholder = NSMutableAttributedString(string: "(예금주)", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.gray,
                ])
                name.append(placeholder)
                accountHodlerNameLabel.attributedText = name
                return
            }
            let name = NSMutableAttributedString(string: accountHodlerName, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white,
            ])
            accountHodlerNameLabel.attributedText = name
        }
    }
    
    var payDate: String! {
        didSet {
            if payDate == "" {
                let nums = NSMutableAttributedString(string: "", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                ])
                let placeholder = NSMutableAttributedString(string: "MM/YY", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.gray,
                ])
                nums.append(placeholder)
                dateLabel.attributedText = nums
            }
            let formatedStr = formatPayDate(s: payDate)
            let nums = NSMutableAttributedString(string: formatedStr.0, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white,
            ])
            let placeholder = NSMutableAttributedString(string: formatedStr.1, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray,
            ])
            nums.append(placeholder)
            dateLabel.attributedText = nums
        }
    }
    
    
    //MARK: - attributes
    
    func attributes() {
        backgroundColor = UIColor(hex: "#FF5454B8") // op: 72
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
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
            
        ])
        
        userStackView.addArrangedSubviews(userImageView, userNameLabel)
        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: 30),
            userImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
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
    
    
}
