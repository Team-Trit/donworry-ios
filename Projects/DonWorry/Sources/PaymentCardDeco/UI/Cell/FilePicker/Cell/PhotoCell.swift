//
//  PhotoCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/24.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

class PhotoCell: UICollectionViewCell {

    lazy var container : UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    lazy var deleteCircle: UIView = {
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                self.backgroundColor = .orange
            }
            else {
                self.backgroundColor = .blue
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.roundCorners(15)
        self.backgroundColor = .blue
        
        self.contentView.addSubview(self.container)
        container.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top)
            $0.left.equalTo(self.contentView.snp.left)
            $0.bottom.equalTo(self.contentView.snp.bottom)
            $0.right.equalTo(self.contentView.snp.right)
        }
        
        
        self.container.addSubview(self.deleteCircle)
        deleteCircle.snp.makeConstraints {
            $0.top.equalTo(self.container.snp.top).inset(8)
            $0.right.equalTo(self.container.snp.right).inset(8)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
