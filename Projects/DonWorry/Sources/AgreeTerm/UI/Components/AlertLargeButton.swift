//
//  LargeButton.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/17.
//  Copyright © 2022 Tr-iT. All rights reserved.

import UIKit

import DesignSystem
import SnapKit

public enum AlertLargeButtonType {
    case next   // 다음
    case done   // 완료
    case hurry  // 재촉하기
    case enter  // 정산방 참가하기
    case update // Payment 수정하기
}

public final class AlertLargeButton: UIButton {
    private lazy var alertLargeButton: UIButton = {
       let v = UIButton()
        v.isEnabled = false
        v.titleLabel?.font = .designSystem(weight: .heavy, size: ._15)
        v.backgroundColor = isEnabled ? .designSystem(.mainBlue) : .designSystem(.grayC5C5C5)
        v.layer.cornerRadius = 25
        return v
    }()

    init() {
        super.init(frame: .zero)
        setUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    public convenience init(type: LargeButtonType) {
        self.init()
        switch(type) {
        case .next:
            alertLargeButton.setTitle("다음", for: .normal)
        case .done:
            alertLargeButton.setTitle("완료", for: .normal)
        case .hurry:
            alertLargeButton.setTitle("재촉하기", for: .normal)
        case .enter:
            alertLargeButton.setTitle("정산방 참가하기", for: .normal)
        case .update:
            alertLargeButton.setTitle("수정하기", for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension AlertLargeButton {
    private func setUI() {
        addSubview(alertLargeButton)

        alertLargeButton.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
