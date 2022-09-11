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

struct PaymentIconCellViewModel {
    var id: Int
    var imageName: String
    var imageURL: String
}

final class PaymentIconCell: UICollectionViewCell {
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                UIView.animate(withDuration: 0.1) {

                }
            }
            else {
                UIView.animate(withDuration: 0.1) {
                    self.contentView.backgroundColor = .designSystem(.grayF6F6F6)
                }
            }
        }
    }

    var viewModel: PaymentIconCellViewModel?

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(25)
        }
    }
    
    func configure(with viewModel: PaymentIconCellViewModel) {
        self.viewModel = viewModel
        self.backgroundColor = .designSystem(.grayF6F6F6)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.imageView.image = UIImage(assetName: viewModel.imageName)
    }

    func setBackgroundColor(isSelected: Bool) {
        let color: UIColor? = isSelected ? .designSystem(.grayC5C5C5) : .designSystem(.grayF6F6F6)
        UIView.animate(withDuration: 0.1) {
            self.contentView.backgroundColor = color
        }
    }
}
