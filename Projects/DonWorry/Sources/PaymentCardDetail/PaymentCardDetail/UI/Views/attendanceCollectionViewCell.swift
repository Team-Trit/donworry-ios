//
//  attendanceCollectionViewCell.swift
//  DonWorry
//
//  Created by Hankyu Lee on 2022/08/28.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import Models
import DesignSystem

class attendanceCollectionViewCell: UICollectionViewCell {
    
    
    static let cellID = "attendanceCollectionViewCell"
    
    var user: User? {
        didSet {
            guard let user = user else {
                return
            }
            if let url = URL(string: user.image) {
                userImageView.load2(url: url)
            }

        }
    }
    
    fileprivate let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setWidth(width: 48)
        imageView.setHeight(height: 48)
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleToFill //
        imageView.clipsToBounds = true
        return imageView
    }()

    fileprivate let userNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .regular, size: ._13)
        label.text = "정산자"//todo
        label.textColor = .designSystem(.gray818181)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        contentView.addSubview(userImageView)
        print("qwe",contentView.bounds.width)
        
        let stackView = UIStackView(arrangedSubviews: [userImageView, userNicknameLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        
        contentView.addSubview(stackView)
        stackView.alignment = .center
        stackView.anchor2(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
}
