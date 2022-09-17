//
//  ParticipatePaymentNavigationBar.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class ParticipatePaymentNavigationBar: UIView {
    lazy var dismissButton: UIButton = {
        $0.setTitle("취소", for: .normal)
        $0.tintColor = .designSystem(.black)
        $0.titleLabel?.font = .designSystem(weight: .regular, size: ._17)
        $0.setTitleColor(.designSystem(.black), for: .normal)
        return $0
    }(UIButton())
    
    private lazy var titleLabel: UILabel = {
        $0.text = "참석확인"
        $0.font = .designSystem(weight: .heavy, size: ._20)
        $0.textColor = .designSystem(.black)
        return $0
    }(UILabel())
    
    lazy var selectedCardNumberLabel: UILabel = {
        $0.font = .designSystem(weight: .bold, size: ._17)
        $0.textColor = .designSystem(.mainBlue)
        return $0
    }(UILabel())
    
    lazy var deselectButton: UIButton = {
        $0.setTitle("선택해제", for: .normal)
        $0.tintColor = .designSystem(.black)
        $0.titleLabel?.font = .designSystem(weight: .regular, size: ._17)
        $0.setTitleColor(.designSystem(.black), for: .normal)
        return $0
    }(UIButton())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension ParticipatePaymentNavigationBar {
    private func setUI() {
        self.addSubviews(dismissButton, titleLabel, selectedCardNumberLabel, deselectButton)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        selectedCardNumberLabel.snp.makeConstraints { make in
            make.trailing.equalTo(deselectButton.snp.leading).offset(-5)
            make.centerY.equalToSuperview()
        }
        
        deselectButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
}
