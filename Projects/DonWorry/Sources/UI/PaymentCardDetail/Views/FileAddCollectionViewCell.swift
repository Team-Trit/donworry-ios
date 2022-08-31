//
//  FileAddCollectionViewCell.swift
//  DonWorry
//
//  Created by Hankyu Lee on 2022/08/28.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem

class FileAddCollectionViewCell: UICollectionViewCell {
    
    var currentIdx: Int = -1
    static let cellID = "FileAddCollectionViewCell"
    
    lazy var container = UIView()
    
    lazy var plusMark : UIImageView = {
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
            $0.edges.equalTo(self.contentView)
        }
        plusMark.snp.makeConstraints {
            $0.edges.equalTo(self.contentView).inset(27)
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

