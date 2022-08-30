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
    
    private let title: UILabel = {
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
    
    private let paymentAmount: UILabel = {
        let paymentAmount = UILabel()
        paymentAmount.translatesAutoresizingMaskIntoConstraints = false
        paymentAmount.font = .designSystem(weight: .heavy, size: ._25)
        paymentAmount.textColor = .designSystem(.mainBlue)
        return paymentAmount
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
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
        addSubview(title)
        title.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        title.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(nameSubTitle)
        nameSubTitle.bottomAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        nameSubTitle.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 5).isActive = true
        
        addSubview(leftSmallTitle)
        leftSmallTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
        leftSmallTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        
        addSubview(paymentAmount)
        paymentAmount.topAnchor.constraint(equalTo: leftSmallTitle.bottomAnchor, constant: 0).isActive = true
        paymentAmount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true

        
        addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: paymentAmount.bottomAnchor, constant: 15).isActive = true
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 8).isActive = true
    }

    func configure(recievedUser: String, payment: Int, totalAmount: Int) {
        title.text = recievedUser
        paymentAmount.attributedText = makeAtrributedString(money: payment)
        progressView.setProgress(Float(payment)/Float(totalAmount), animated: false)
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

