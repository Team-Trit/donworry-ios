//
//  PaymentIconCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import SnapKit
import DesignSystem

class PaymentIconCell: UICollectionViewCell {
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                contentView.backgroundColor = .designSystem(.grayC5C5C5)
            }
            else {
                contentView.backgroundColor = .designSystem(.grayF6F6F6)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(25)
        }
    }
    
    func configure(with icon : String) {
        self.backgroundColor = .designSystem(.grayF6F6F6)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.imageView.image = .init(Asset(rawValue: icon) ?? .ic_cake)
               
    }
    
}
