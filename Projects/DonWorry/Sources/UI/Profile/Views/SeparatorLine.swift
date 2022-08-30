//
//  SeparatorLine.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/25.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem

final class SeparatorLine: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper
extension SeparatorLine {
    private func configure() {
        self.backgroundColor = .designSystem(.grayF6F6F6)
    }
}
