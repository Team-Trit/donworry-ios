//
//  RecieveMoneyDetailStatusView.swift
//  DonWorry
//
//  Created by uiskim on 2022/08/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

class RecieveMoneyDetailStatusView: UIView {
    
    private let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "받을 돈"
        title.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        title.textColor = UIColor.black
        return title
    }()
    
    private let leftSmallTitle: UILabel = {
        let leftSmallTitle = UILabel()
        leftSmallTitle.translatesAutoresizingMaskIntoConstraints = false
        leftSmallTitle.text = "정산 금액"
        leftSmallTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        leftSmallTitle.textColor = UIColor.black
        return leftSmallTitle
    }()
    
    private let rightSmallTitle: UILabel = {
        let rightSmallTitle = UILabel()
        rightSmallTitle.translatesAutoresizingMaskIntoConstraints = false
        rightSmallTitle.text = "미정산 금액"
        rightSmallTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        rightSmallTitle.textColor = UIColor.black
        rightSmallTitle.layer.opacity = 0.4
        return rightSmallTitle
    }()
    
    private let paymentAmount: UILabel = {
        let paymentAmount = UILabel()
        paymentAmount.translatesAutoresizingMaskIntoConstraints = false
        paymentAmount.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        paymentAmount.textColor = UIColor.PrimaryBlue
        return paymentAmount
    }()
    
    private let outstandingAmount: UILabel = {
        let outstandingAmount = UILabel()
        outstandingAmount.translatesAutoresizingMaskIntoConstraints = false
        outstandingAmount.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        outstandingAmount.textColor = UIColor.PrimaryBlue
        outstandingAmount.layer.opacity = 0.4
        return outstandingAmount
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = UIColor.SeperateLine
        progressView.progressTintColor = UIColor.PrimaryBlue
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
        addSubviews(title)
        title.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        title.widthAnchor.constraint(equalToConstant: 72).isActive = true
        title.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubviews(leftSmallTitle)
        leftSmallTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
        leftSmallTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        addSubviews(rightSmallTitle)
        rightSmallTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
        rightSmallTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        addSubviews(paymentAmount)
        paymentAmount.topAnchor.constraint(equalTo: leftSmallTitle.bottomAnchor, constant: 0).isActive = true
        paymentAmount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        addSubviews(outstandingAmount)
        outstandingAmount.topAnchor.constraint(equalTo: rightSmallTitle.bottomAnchor, constant: 0).isActive = true
        outstandingAmount.trailingAnchor.constraint(equalTo: rightSmallTitle.trailingAnchor).isActive = true
        
        addSubviews(progressView)
        progressView.topAnchor.constraint(equalTo: paymentAmount.bottomAnchor, constant: 15).isActive = true
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 10).isActive = true

        
        
    }
    
    func configure(payment: Float, outstanding: Float) {
        paymentAmount.attributedText = makeAtrributedString(money: payment)
        outstandingAmount.attributedText = makeAtrributedString(money: outstanding)
        
        progressView.setProgress(payment/outstanding, animated: false)
    }
    
    func makeAtrributedString(money: Float) -> NSMutableAttributedString {
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        let paymentString = numberformatter.string(for: money)! + "원"
        let attributedQuote = NSMutableAttributedString(string: paymentString)
        attributedQuote.addAttribute(.foregroundColor, value: UIColor.black, range: (paymentString as NSString).range(of: "원"))
        attributedQuote.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .bold), range: (paymentString as NSString).range(of: "원"))
        
        return attributedQuote
    }
}
