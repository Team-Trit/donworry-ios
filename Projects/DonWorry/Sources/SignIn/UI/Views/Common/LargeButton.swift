//
//  LargeButton.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public enum LargeButtonType {
    case next   // 다음
    case done   // 완료
    case hurry  // 재촉하기
    case enter  // 정산방 참가하기
    case update // Payment 수정하기
}

protocol LargeButtonDelegate: AnyObject {
    func buttonPressed(_ sender: UIButton)
}

final class LargeButton: UIButton {
    /// UIButton Customize Reference : https://ios-development.tistory.com/43
    weak var delegate: LargeButtonDelegate?
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: LargeButtonType) {
        self.init()
        switch(type) {
        case .next:
            setTitle("다음", for: .normal)
        case .done:
            setTitle("완료", for: .normal)
        case .hurry:
            setTitle("재촉하기", for: .normal)
        case .enter:
            setTitle("정산방 참가하기", for: .normal)
        case .update:
            setTitle("수정하기", for: .normal)
        }
    }
    
    private func commonInit() {
        attributes()
        layout()
    }
}

// MARK: - Configurations
extension LargeButton {
    private func attributes() {
//        isEnabled = false
        titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        backgroundColor = isEnabled ? .designSystem(.mainBlue) : .designSystem(.gray2)
        layer.cornerRadius = 25
        addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    private func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: trailingAnchor),
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Interaction Functions
extension LargeButton {
    @objc private func buttonPressed(_ sender: UIButton) {
        delegate?.buttonPressed(sender)
    }
}
