//
//  ColorCircleCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import SnapKit

enum CardColor: String {
    case yellow = "#FFA114FF"
    case purple = "#9036B5FF"
    case brown = "#A84E25FF"
    case red = "#B51A00FF"
    case skyblue = "#00A1D8FF"
    case green = "#7EB252FF"
    case pink = "#FF5454FF"
    case navy = "#0042A9FF"
    case blue = "#1C6BFFFF"
    case black = "#000000FF"
}

class ColorCircleCell: UICollectionViewCell {

    lazy var container : UIView = UIView()

    lazy var colorView: UIView = {
        $0.layer.cornerRadius = 15
        return $0
    }(UIView())
    
    
    lazy var innerColorView: UIView = {
        $0.layer.cornerRadius = 12
        return $0
    }(UIView())
    
    override var isSelected: Bool {
        didSet{
            UIView.animate(withDuration: 0.01) {
                if self.isSelected {
                    self.innerColorView.layer.borderColor = UIColor.white.cgColor
                    self.innerColorView.layer.borderWidth = 2
                }
                else {
                    self.innerColorView.layer.borderWidth = 0
                }
            }
        }
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.contentView.addSubview(self.container)
        container.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top)
            $0.left.equalTo(self.contentView.snp.left)
            $0.bottom.equalTo(self.contentView.snp.bottom)
            $0.right.equalTo(self.contentView.snp.right)
        }

        self.container.addSubview(self.colorView)
        colorView.snp.makeConstraints {
            $0.centerX.equalTo(self.container.snp.centerX)
            $0.centerY.equalTo(self.container.snp.centerY)
            $0.width.height.equalTo(30)
        }
        
        self.colorView.addSubview(self.innerColorView)
        innerColorView.snp.makeConstraints {
            $0.centerX.equalTo(self.colorView.snp.centerX)
            $0.centerY.equalTo(self.colorView.snp.centerY)
            $0.width.height.equalTo(24)
        }
        
    }
    
    func configure(with color : CardColor) {
        self.colorView.backgroundColor = UIColor(hex: color.rawValue)
        self.innerColorView.backgroundColor = UIColor(hex: color.rawValue)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
