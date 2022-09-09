//
//  SentMoneyTableViewCell.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

public struct SendingMoneyInfoViewModel {
    let name: String
    let date: String
    let totalAmount: Int
    let totalUers: Int
    let myAmount: Int
}

public struct SendingMoneyProgressInfoViewModel {
    let name: String
    let myAmount: Int
    let totalAmount: Int
    
}

let myMoneyInfo: [SendingMoneyInfoViewModel] = [
    SendingMoneyInfoViewModel(name: "우디네당구장", date: "05/25", totalAmount: 184000, totalUers: 4, myAmount: 44000),
    SendingMoneyInfoViewModel(name: "우디네당구장", date: "05/25", totalAmount: 152000, totalUers: 2, myAmount: 76000),
    SendingMoneyInfoViewModel(name: "안녕하세요", date: "03/45", totalAmount: 123000, totalUers: 5, myAmount: 12000),
    SendingMoneyInfoViewModel(name: "졸려죽겟다", date: "03/12", totalAmount: 39000, totalUers: 3, myAmount: 13000)
]

let myMoneyDetailInfo: [SendingMoneyProgressInfoViewModel] = [
    SendingMoneyProgressInfoViewModel(name: "유쓰", myAmount: 20000, totalAmount: 120000),
    SendingMoneyProgressInfoViewModel(name: "애셔", myAmount: 100000, totalAmount: 120000),
    SendingMoneyProgressInfoViewModel(name: "찰리", myAmount: 1000, totalAmount: 10000),
    SendingMoneyProgressInfoViewModel(name: "gg", myAmount: 2140, totalAmount: 2345)
]

class SentMoneyTableViewCell: UITableViewCell {


    public let numberformatter = NumberFormatter()
    
    static let identifier: String = "SentMoneyTableViewCell"
    
    private let smallRoundRectangle: UIView = {
        let smallRoundRec = UIView()
        smallRoundRec.translatesAutoresizingMaskIntoConstraints = false
        smallRoundRec.backgroundColor = .designSystem(.grayF6F6F6)
        smallRoundRec.roundCorners(10)
        return smallRoundRec
    }()
    
    private let spaceIcon: UIImageView = {
        let spaceIcon = UIImageView()
        spaceIcon.translatesAutoresizingMaskIntoConstraints = false
        return spaceIcon
    }()
    
    private let spaceNameLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .designSystem(weight: .bold, size: ._15)
        v.textColor = .black
        return v
    }()
    
    private let paymentDate: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = .designSystem(weight: .regular, size: ._13)
        date.textColor = .designSystem(.gray818181)
        return date
    }()
    
    private let dividedAmountDetail: UILabel = {
        let dividedAmountDetail = UILabel()
        dividedAmountDetail.translatesAutoresizingMaskIntoConstraints = false
        dividedAmountDetail.font = .designSystem(weight: .bold, size: ._13)
        dividedAmountDetail.textColor = .designSystem(.gray818181)
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
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        contentView.addSubview(smallRoundRectangle)
        NSLayoutConstraint.activate([
            smallRoundRectangle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            smallRoundRectangle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
        smallRoundRectangle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        smallRoundRectangle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 27).isActive = true
        smallRoundRectangle.widthAnchor.constraint(equalToConstant: 43).isActive = true
        smallRoundRectangle.heightAnchor.constraint(equalToConstant: 43).isActive = true
        
        smallRoundRectangle.addSubview(spaceIcon)
        spaceIcon.centerYAnchor.constraint(equalTo: smallRoundRectangle.centerYAnchor).isActive = true
        spaceIcon.centerXAnchor.constraint(equalTo: smallRoundRectangle.centerXAnchor).isActive = true
        spaceIcon.widthAnchor.constraint(equalToConstant: 27).isActive = true
        spaceIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        contentView.addSubview(spaceNameLabel)
        spaceNameLabel.topAnchor.constraint(equalTo: smallRoundRectangle.topAnchor).isActive = true
        spaceNameLabel.leadingAnchor.constraint(equalTo: smallRoundRectangle.trailingAnchor, constant: 10).isActive = true

        contentView.addSubview(paymentDate)
        paymentDate.bottomAnchor.constraint(equalTo: smallRoundRectangle.bottomAnchor).isActive = true
        paymentDate.leadingAnchor.constraint(equalTo: smallRoundRectangle.trailingAnchor, constant: 10).isActive = true
        
        contentView.addSubview(dividedAmountDetail)
        dividedAmountDetail.topAnchor.constraint(equalTo: smallRoundRectangle.topAnchor).isActive = true
        dividedAmountDetail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -27).isActive = true
        
        contentView.addSubview(dividedAmount)
        dividedAmount.topAnchor.constraint(equalTo: dividedAmountDetail.bottomAnchor, constant: 5).isActive = true
        dividedAmount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -27).isActive = true
        
        
    }

    func configure(icon: String, myPayment: SendingMoneyInfoViewModel) {
        numberformatter.numberStyle = .decimal
        spaceIcon.image = UIImage(named: "baconImage")
        spaceNameLabel.text = myPayment.name
        paymentDate.text = myPayment.date
        dividedAmountDetail.attributedText = makeAtrributedString(myPayment: myPayment)
        dividedAmount.text = numberformatter.string(for: myPayment.myAmount)! + "원"
    }
    
    func makeAtrributedString(myPayment: SendingMoneyInfoViewModel) -> NSMutableAttributedString {
        numberformatter.numberStyle = .decimal
        let paymentString = numberformatter.string(for: myPayment.totalAmount)! + "원" + " / " + "\(myPayment.totalUers)" + "명"
        let attributedQuote = NSMutableAttributedString(string: paymentString)
        attributedQuote.addAttribute(.foregroundColor, value: UIColor.designSystem(.mainBlue)!, range: (paymentString as NSString).range(of: " / " + "\(myPayment.totalUers)" + "명"))
        return attributedQuote
    }
}


