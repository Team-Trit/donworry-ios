//
//  SentMoneyTableViewCell.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

class SentMoneyTableViewCell: BaseTableViewCell {
    
    static let identifier: String = "SentMoneyTableViewCell"
    
    private let smallRoundRectangle: UIView = {
        let smallRoundRec = UIView()
        smallRoundRec.translatesAutoresizingMaskIntoConstraints = false
        smallRoundRec.backgroundColor = .designSystem(.white)
        smallRoundRec.clipsToBounds = true
        smallRoundRec.layer.cornerRadius = 10
        smallRoundRec.layer.masksToBounds = false
        smallRoundRec.layer.shadowColor = UIColor.black.cgColor
        smallRoundRec.layer.shadowOffset = CGSize(width: 0, height: 0)
        smallRoundRec.layer.shadowOpacity = 0.5
        smallRoundRec.layer.shadowRadius = 2
        return smallRoundRec
    }()
    
    private let spaceIcon: UIImageView = {
        let spaceIcon = UIImageView()
        spaceIcon.translatesAutoresizingMaskIntoConstraints = false
        return spaceIcon
    }()
    
    private let paymentRoomName: UILabel = {
        let paymentRoomName = UILabel()
        paymentRoomName.translatesAutoresizingMaskIntoConstraints = false
        paymentRoomName.font = .designSystem(weight: .bold, size: ._15)
        paymentRoomName.textColor = .black
        return paymentRoomName
    }()
    
    private let paymentDate: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = .designSystem(weight: .regular, size: ._13)
        date.textColor = .designSystem(.gray1)
        return date
    }()
    
    private let dividedAmountDetail: UILabel = {
        let dividedAmountDetail = UILabel()
        dividedAmountDetail.translatesAutoresizingMaskIntoConstraints = false
        dividedAmountDetail.font = .designSystem(weight: .bold, size: ._13)
        dividedAmountDetail.textColor = .designSystem(.gray1)
        return dividedAmountDetail
    }()
    
    private let dividedAmount: UILabel = {
        let dividedAmount = UILabel()
        dividedAmount.translatesAutoresizingMaskIntoConstraints = false
        dividedAmount.font = .designSystem(weight: .heavy, size: ._15)
        return dividedAmount
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        contentView.addSubview(smallRoundRectangle)
        smallRoundRectangle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        smallRoundRectangle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        smallRoundRectangle.widthAnchor.constraint(equalToConstant: 43).isActive = true
        smallRoundRectangle.heightAnchor.constraint(equalToConstant: 43).isActive = true
        
        smallRoundRectangle.addSubview(spaceIcon)
        spaceIcon.centerYAnchor.constraint(equalTo: smallRoundRectangle.centerYAnchor).isActive = true
        spaceIcon.centerXAnchor.constraint(equalTo: smallRoundRectangle.centerXAnchor).isActive = true
        spaceIcon.widthAnchor.constraint(equalToConstant: 27).isActive = true
        spaceIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        contentView.addSubview(paymentRoomName)
        paymentRoomName.topAnchor.constraint(equalTo: smallRoundRectangle.topAnchor).isActive = true
        paymentRoomName.leadingAnchor.constraint(equalTo: smallRoundRectangle.trailingAnchor, constant: 10).isActive = true

        contentView.addSubview(paymentDate)
        paymentDate.bottomAnchor.constraint(equalTo: smallRoundRectangle.bottomAnchor).isActive = true
        paymentDate.leadingAnchor.constraint(equalTo: smallRoundRectangle.trailingAnchor, constant: 10).isActive = true
        
        contentView.addSubview(dividedAmountDetail)
        dividedAmountDetail.topAnchor.constraint(equalTo: smallRoundRectangle.topAnchor).isActive = true
        dividedAmountDetail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        contentView.addSubview(dividedAmount)
        dividedAmount.topAnchor.constraint(equalTo: dividedAmountDetail.bottomAnchor, constant: 5).isActive = true
        dividedAmount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        
    }

    func configure(icon: String, myPayment: Payment) {
        numberformatter.numberStyle = .decimal
        spaceIcon.image = UIImage(named: "MeatIcon")
        paymentRoomName.text = myPayment.name
        paymentDate.text = myPayment.date
        dividedAmountDetail.attributedText = makeAtrributedString(myPayment: myPayment)
        dividedAmount.text = numberformatter.string(for: myPayment.myAmount)! + "원"
    }
}

func makeAtrributedString(myPayment: Payment) -> NSMutableAttributedString {
    numberformatter.numberStyle = .decimal
    let paymentString = numberformatter.string(for: myPayment.totalAmount)! + "원" + " / " + "\(myPayment.totalUers)" + "명"
    let attributedQuote = NSMutableAttributedString(string: paymentString)
    attributedQuote.addAttribute(.foregroundColor, value: UIColor.designSystem(.mainBlue)!, range: (paymentString as NSString).range(of: " / " + "\(myPayment.totalUers)" + "명"))
    return attributedQuote
}
