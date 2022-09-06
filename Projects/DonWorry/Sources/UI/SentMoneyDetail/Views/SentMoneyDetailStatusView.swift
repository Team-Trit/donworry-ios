//
//  SentMoneyDetailStatusView.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

class SentMoneyDetailStatusView: UIView {
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .designSystem(weight: .heavy, size: ._25)
        title.textColor = UIColor.black
        return title
    }()
    
    private let nameSubTitle: UILabel = {
        let nameSubTitle = UILabel()
        nameSubTitle.translatesAutoresizingMaskIntoConstraints = false
        nameSubTitle.text = "님께"
        nameSubTitle.font = .designSystem(weight: .regular, size: ._15)
        nameSubTitle.textColor = .designSystem(.gray818181)
        return nameSubTitle
    }()
    
    private let leftSmallTitle: UILabel = {
        let leftSmallTitle = UILabel()
        leftSmallTitle.translatesAutoresizingMaskIntoConstraints = false
        leftSmallTitle.text = "송금할 금액"
        leftSmallTitle.font = .designSystem(weight: .heavy, size: ._15)
        leftSmallTitle.textColor = UIColor.black
        return leftSmallTitle
    }()
    
    let paymentAmountLabel: UILabel = {
        let paymentAmount = UILabel()
        paymentAmount.translatesAutoresizingMaskIntoConstraints = false
        paymentAmount.font = .designSystem(weight: .heavy, size: ._25)
        paymentAmount.textColor = .designSystem(.mainBlue)
        return paymentAmount
    }()
    
    let totalAmountDescriptionLabel: UILabel = {
        let totalAmountLabel = UILabel()
        totalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAmountLabel.text = "총 정산 내역"
        totalAmountLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        totalAmountLabel.textColor = .black
        totalAmountLabel.layer.opacity = 0.2
        return totalAmountLabel
    }()

    private lazy var totalAmountLabel: UILabel = {
        let totalAmount = UILabel()
        totalAmount.translatesAutoresizingMaskIntoConstraints = false
        totalAmount.textColor = .designSystem(.mainBlue)
        totalAmount.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        totalAmount.layer.opacity = 0.2
        totalAmount.attributedText = makeAtrributedString(money: 120000)
        return totalAmount
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = .designSystem(.white)
        progressView.progressTintColor = .designSystem(.mainBlue)
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 5
        progressView.subviews[1].clipsToBounds = true
        return progressView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(nameSubTitle)
        nameSubTitle.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        nameSubTitle.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5).isActive = true
        
        addSubview(leftSmallTitle)
        leftSmallTitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        leftSmallTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        
        addSubview(paymentAmountLabel)
        paymentAmountLabel.topAnchor.constraint(equalTo: leftSmallTitle.bottomAnchor, constant: 0).isActive = true
        paymentAmountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        addSubview(totalAmountDescriptionLabel)
        totalAmountDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        totalAmountDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        
        addSubview(totalAmountLabel)
        totalAmountLabel.topAnchor.constraint(equalTo: totalAmountDescriptionLabel.bottomAnchor).isActive = true
        totalAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true

        
        addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: paymentAmountLabel.bottomAnchor, constant: 15).isActive = true
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 8).isActive = true
    }

    func configure(recievedUser: String?, payment: Int, totalAmount: Int) {
        titleLabel.text = recievedUser
        paymentAmountLabel.attributedText = makeAtrributedString(money: payment)
        progressView.setProgress(Float(payment)/Float(totalAmount), animated: true)
    }
    
    func makeAtrributedString(money: Int) -> NSMutableAttributedString {
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        let paymentString = numberformatter.string(for: money)! + "원"
        let attributedQuote = NSMutableAttributedString(string: paymentString)
        attributedQuote.addAttribute(.foregroundColor, value: UIColor.black, range: (paymentString as NSString).range(of: "원"))
        attributedQuote.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .bold), range: (paymentString as NSString).range(of: "원"))
        
        return attributedQuote
    }
}

