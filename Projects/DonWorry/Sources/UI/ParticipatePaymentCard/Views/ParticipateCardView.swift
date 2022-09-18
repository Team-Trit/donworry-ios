//
//  ParticipateCardView.swift
//  DonWorry
//
//  Created by 김승창 on 2022/09/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

import DesignSystem
import SnapKit

final class ParticipateCardView: UIView {
    private let cardShadowView: UIView = {
        $0.backgroundColor = .systemBackground
        $0.addShadowWithRoundedCorners(20.0, shadowColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.5), opacity: 1)
        return $0
    }(UIView())
    let leftCardView: UIView = {
        $0.roundCorners(20)
        $0.clipsToBounds = true
        return $0
    }(UIView())
    let rightCardView: UIView = {
        $0.roundCorners(20)
        $0.clipsToBounds = true
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        return $0
    }(UIView())
    let titleLabel: UILabel = {
        $0.font = .designSystem(weight: .heavy, size: ._15)
        $0.textColor = .designSystem(.white)
        return $0
    }(UILabel())
    
    private let iconContainerView: UIView = {
        $0.backgroundColor = .designSystem(.white)
        $0.roundCorners(5)
        $0.setWidth(width: 33)
        $0.setHeight(height: 33)
        return $0
    }(UIView())
    
    let iconImageView: UIImageView = {
        $0.setWidth(width: 28)
        $0.setHeight(height: 28)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    let totalPriceLabel: UILabel = {
        $0.textColor = .designSystem(.white)
        $0.font = .designSystem(weight: .heavy, size: ._20)
        return $0
    }(UILabel())
    
    let userImageView: UIImageView = {
        $0.setWidth(width: 25)
        $0.setHeight(height: 25)
        $0.roundCorners(12.5)
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    let userNicknameLabel: UILabel = {
        $0.font = .designSystem(weight: .bold, size: ._13)
        $0.textColor = .designSystem(.white)
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())
    
    private let dateContainerView: UIView = {
        $0.roundCorners(11)
        $0.setWidth(width: 40)
        $0.setHeight(height: 24)
        $0.backgroundColor = .designSystem(.grayF6F6F6)?.withAlphaComponent(0.80)
        return $0
    }(UIView())
    
    let dateLabel: UILabel = {
        $0.font = .designSystem(weight: .bold, size: ._9)
        $0.textColor = .designSystem(.white)
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension ParticipateCardView {
    private func setUI() {
        self.addSubviews(cardShadowView, leftCardView, rightCardView)
        
        let width = UIScreen.main.bounds.width
        
        cardShadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        leftCardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(width * 280 / 390)
        }
        
        rightCardView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(width * 69 / 390)
        }
        
        // left
        leftCardView.addSubviews(titleLabel, iconContainerView, iconImageView, totalPriceLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(21)
        }
        
        iconContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalTo(iconContainerView.snp.center)
        }
        
        totalPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconContainerView.snp.trailing)
                .offset(6)
            make.centerY.equalToSuperview()
        }
        
        // right
        rightCardView.addSubviews(userImageView, userNicknameLabel, dateContainerView, dateLabel)
        
        userImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        userNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        dateContainerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.center.equalTo(dateContainerView.snp.center)
        }
    }
}
