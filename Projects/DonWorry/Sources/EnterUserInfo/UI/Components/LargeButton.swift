//
//  LargeButton.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

public enum LargeButtonType {
    case next   // 다음
    case done   // 완료
    case hurry  // 재촉하기
    case enter  // 정산방 참가하기
    case update // Payment 수정하기
}

public final class LargeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public convenience init(type: LargeButtonType) {
        self.init()
        switch(type) {
        case .next:
            self.setTitle("다음", for: .normal)
        case .done:
            self.setTitle("완료", for: .normal)
        case .hurry:
            self.setTitle("재촉하기", for: .normal)
        case .enter:
            self.setTitle("정산방 참가하기", for: .normal)
        case .update:
            self.setTitle("수정하기", for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension LargeButton {
    private func configure() {
//        self.isEnabled = false
        self.titleLabel?.font = .designSystem(weight: .heavy, size: ._15)
        self.backgroundColor = isEnabled ? .designSystem(.mainBlue) : .designSystem(.grayC5C5C5)
        self.layer.cornerRadius = 25
    }
}
