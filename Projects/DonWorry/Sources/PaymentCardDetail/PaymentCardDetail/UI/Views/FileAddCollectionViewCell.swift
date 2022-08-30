//
//  FIleAddCollectionViewCell.swift
//  DonWorry
//
//  Created by Hankyu Lee on 2022/08/28.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

class FileAddCollectionViewCell: UICollectionViewCell {
    
    var currentIdx: Int = -1
    static let cellID = "FIleAddCollectionViewCell"
    
    lazy var container : UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    lazy var plusMark : UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "plus")
        $0.tintColor = .white
        return $0
    }(UIImageView())

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.roundCorners(15)
        self.backgroundColor = UIColor(hex: "#BDBDBDFF")
        
        self.contentView.addSubview(self.container)
        self.container.addSubview(self.plusMark)
        container.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top)
            $0.left.equalTo(self.contentView.snp.left)
            $0.bottom.equalTo(self.contentView.snp.bottom)
            $0.right.equalTo(self.contentView.snp.right)
        }
        plusMark.snp.makeConstraints {
            $0.top.equalTo(self.container.snp.top).inset(27)
            $0.left.equalTo(self.container.snp.left).inset(27)
            $0.bottom.equalTo(self.container.snp.bottom).inset(27)
            $0.right.equalTo(self.container.snp.right).inset(27)
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

