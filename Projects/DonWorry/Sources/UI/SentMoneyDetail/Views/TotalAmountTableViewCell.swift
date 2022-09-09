//
//  TotalAmountTableViewCell.swift
//  DonWorry
//
//  Created by uiskim on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

class TotalAmountTableViewCell: UITableViewCell {
    
    static let identifier: String = "TotalAmountTableViewCell"
    
    let cellTtitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .right
        title.text = "나의 정산 총액"
        title.font = .designSystem(weight: .heavy, size: ._15)
        title.textColor = .black
        return title
    }()
    
    let amount: UILabel = {
        let amount = UILabel()
        amount.translatesAutoresizingMaskIntoConstraints = false
        amount.textAlignment = .right
        amount.textColor = .designSystem(.mainBlue)
        amount.font = .designSystem(weight: .heavy, size: ._20)
        return amount
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        contentView.addSubviews(cellTtitle, amount)
        cellTtitle.bottomAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        cellTtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
        cellTtitle.widthAnchor.constraint(equalToConstant: 165).isActive = true
        cellTtitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        amount.topAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        amount.trailingAnchor.constraint(equalTo: cellTtitle.trailingAnchor).isActive = true
        amount.widthAnchor.constraint(equalToConstant: 165).isActive = true
        amount.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
 
    }
    
    func configure(totalAmount: Int) {
        amount.attributedText = makeAtrributedString(money: totalAmount, fontSize: 15, wonColor: .designSystem(.mainBlue)!)
    }

}
