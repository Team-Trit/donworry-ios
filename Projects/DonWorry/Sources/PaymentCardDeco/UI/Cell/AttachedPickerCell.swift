//
//  AttachedPickerCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import PhotosUI

import DesignSystem

class AttachedPickerCell: UITableViewCell {
    
    static let cellID = "CellId"
    
    lazy var containerStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.spacing = 0
        $0.axis = .vertical
//        $0.roundCorners(10)
        return $0
    }(UIStackView())
    
    lazy var topView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .designSystem(.mainBlue)
        return $0
    }(UIView())
    
    lazy var bottomView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .designSystem(.white)
        $0.isHidden = true
        return $0
    }(UIView())
    
    lazy var topTitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "파일 추가 (선택)"
        $0.font = .designSystem(weight: .bold, size: ._13)
        $0.textAlignment = .left
        $0.textColor = UIColor(hex: "#606060FF")
        return $0
    }(UILabel())
    
    lazy var chevronImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "chevron.down")
        return $0
    }(UIImageView())
    
    lazy var imgView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "chicken")
        return $0
    }(UIImageView())
    
    
    
    // 코드로 작성할 경우 초기화 해야함 (스토리보드는 안해도됨)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func layout() {
        
        self.addSubviews(containerStackView)
//        PaymentCardView()
        containerStackView.addArrangedSubviews(topView, bottomView, topTitleLabel, imgView)
        
        containerStackView.layer.cornerRadius = 10
        containerStackView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7.5),
            containerStackView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -7.5),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
            topView.bottomAnchor.constraint(equalTo: containerStackView.bottomAnchor),
            topView.heightAnchor.constraint(equalToConstant: 48+15),
            
            topTitleLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 14),
            topTitleLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -14),
            topTitleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            topTitleLabel.heightAnchor.constraint(equalToConstant:  48+15),
            
            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: containerStackView.bottomAnchor),
            
//            imgView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 14),
//            imgView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
//            imgView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
//            imgView.widthAnchor.constraint(equalToConstant: 50),
//            imgView.heightAnchor.constraint(equalToConstant: 200),
            
        ])
        
        
        

        
    }
    
}
