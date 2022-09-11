//
//  DetailProgressTableViewCell.swift
//  DonWorry
//
//  Created by uiskim on 2022/09/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

class DetailProgressTableViewCell: UITableViewCell {
    
    static let identifier: String = "DetailProgressTableViewCell"
    
    let seperateLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .designSystem(.grayF6F6F6)
        return line
    }()
    
    let takerName: UILabel = {
        let takerName = UILabel()
        takerName.translatesAutoresizingMaskIntoConstraints = false
        takerName.font = .designSystem(weight: .heavy, size: ._15)
        return takerName
    }()
    
    let myAmount: UILabel = {
        let myAmount = UILabel()
        myAmount.translatesAutoresizingMaskIntoConstraints = false
        myAmount.font = .designSystem(weight: .heavy, size: ._25)
        myAmount.textColor = .designSystem(.mainBlue)
        return myAmount
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = .designSystem(.grayF6F6F6)
        progressView.progressTintColor = .designSystem(.mainBlue)
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 5
        progressView.subviews[1].clipsToBounds = true
        return progressView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        contentView.addSubview(seperateLine)
        seperateLine.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        seperateLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive = true
        seperateLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
        seperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        contentView.addSubview(takerName)
        takerName.topAnchor.constraint(equalTo: seperateLine.bottomAnchor, constant: 20).isActive = true
        takerName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        takerName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        contentView.addSubview(myAmount)
        myAmount.topAnchor.constraint(equalTo: takerName.bottomAnchor, constant: 5).isActive = true
        myAmount.leadingAnchor.constraint(equalTo: takerName.leadingAnchor).isActive = true
        myAmount.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        contentView.addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: myAmount.bottomAnchor, constant: 15).isActive = true
        progressView.leadingAnchor.constraint(equalTo: myAmount.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        
    }
    
    func configure(myData: SendingMoneyProgressInfoViewModel) {
        takerName.text = myData.name + "님께"
        myAmount.attributedText = makeAtrributedString(money: myData.myAmount, fontSize: 20, wonColor: .black)
        progressView.setProgress(Float(myData.myAmount)/Float(myData.totalAmount), animated: false)
    }

}
