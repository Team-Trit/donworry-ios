//
//  LargeButton.swift
//  DonWorry
//
//  Created by 김승창 on 2022/08/08.
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

protocol LargeButtonDelegate: AnyObject {
    func buttonPressed(_ sender: UIButton)
}

final class LargeButton: UIButton {
    /// UIButton Customize Reference : https://ios-development.tistory.com/43
    private lazy var largeButton: UIButton = {
       let largeButton = UIButton()
        largeButton.isEnabled = false
        largeButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        largeButton.backgroundColor = isEnabled ? .designSystem(.mainBlue) : .designSystem(.gray2)
        largeButton.layer.cornerRadius = 25
        largeButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return largeButton
    }()
    weak var delegate: LargeButtonDelegate?
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    convenience init(type: LargeButtonType) {
        self.init()
        switch(type) {
        case .next:
            largeButton.setTitle("다음", for: .normal)
        case .done:
            largeButton.setTitle("완료", for: .normal)
        case .hurry:
            largeButton.setTitle("재촉하기", for: .normal)
        case .enter:
            largeButton.setTitle("정산방 참가하기", for: .normal)
        case .update:
            largeButton.setTitle("수정하기", for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension LargeButton {
    private func setUI() {
        addSubview(largeButton)
        largeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
    }
}

// MARK: - Interaction Functions
extension LargeButton {
    @objc private func buttonPressed(_ sender: UIButton) {
        delegate?.buttonPressed(sender)
    }
}
