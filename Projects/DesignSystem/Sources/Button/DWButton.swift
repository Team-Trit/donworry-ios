//
//  LeftButton.swift
//  DesignSystem
//
//  Created by Woody on 2022/08/17.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import SnapKit

public enum DonWorryButtonType {
    case xlarge58 // weight : 340 , height : 58
    case xlarge50 // weight : 340 , height : 50
    case largeBlue // weight : 262
    case mediumBlue // weight : 222
    case smallBlue // weight : 106
    case halfMainBlue // weight : 162 절반 버튼
    case halfLightBlue // weight : 162 절반 버튼
    case xsmallGray // weight : 70
}

public extension DWButton {

    static func create(_ type: DonWorryButtonType) -> DWButton {
        let button = DWButton(type: .system)
        switch type {
        case .xlarge58:
            button.roundCornersInDesignSystem(25)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.setBackgroundColor(.designSystem(.mainBlue)!, for: .normal)
            button.setBackgroundColor(.designSystem(.grayC5C5C5)!, for: .disabled)
            button.snp.makeConstraints { make in
                make.height.equalTo(58)
            }
        case .xlarge50:
            button.roundCornersInDesignSystem(25)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.setBackgroundColor(.designSystem(.mainBlue)!, for: .normal)
            button.setBackgroundColor(.designSystem(.grayC5C5C5)!, for: .disabled)
            button.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        case .largeBlue:
            button.roundCornersInDesignSystem(29)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.tintColor = .designSystem(.white)
            button.addGradientInDesignSystem(
                startColor: .designSystem(.blueTopGradient)!,
                endColor: .designSystem(.blueBottomGradient)!
            )
            button.snp.makeConstraints { make in
                make.width.equalTo(262)
                make.height.equalTo(58)
            }
        case .mediumBlue:
            button.roundCornersInDesignSystem(29)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.tintColor = .designSystem(.white)
            button.addGradientInDesignSystem(
                startColor: .designSystem(.blueTopGradient)!,
                endColor: .designSystem(.blueBottomGradient)!
            )
            button.snp.makeConstraints { make in
                make.height.equalTo(58)
            }
        case .smallBlue:
            button.roundCornersInDesignSystem(29)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.setBackgroundColor(.designSystem(.grayC5C5C5)!, for: .disabled)
            button.tintColor = .designSystem(.white)
            button.addGradientInDesignSystem(
                startColor: .designSystem(.blueTopGradient)!,
                endColor: .designSystem(.blueBottomGradient)!
            )
            button.snp.makeConstraints { make in
                make.height.equalTo(58)
            }
        case .halfMainBlue:
            button.roundCornersInDesignSystem(25)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.tintColor = .designSystem(.white)
            button.setBackgroundColor(.designSystem(.mainBlue)!, for: .normal)
            button.setBackgroundColor(.designSystem(.grayC5C5C5)!, for: .disabled)
            button.snp.makeConstraints { make in
                make.width.equalTo(162)
                make.height.equalTo(58)
            }
        case .halfLightBlue:
            button.roundCornersInDesignSystem(25)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.mainBlue), for: .normal)
            button.tintColor = .designSystem(.mainBlue)
            button.setBackgroundColor(.designSystem(.lightBlue)!, for: .normal)
            button.setBackgroundColor(.designSystem(.grayC5C5C5)!, for: .disabled)
            button.snp.makeConstraints { make in
                make.width.equalTo(162)
                make.height.equalTo(58)
            }
        case .xsmallGray:
            button.roundCornersInDesignSystem(29)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.tintColor = .designSystem(.white)
            button.backgroundColor = .designSystem(.grayC5C5C5)
            button.snp.makeConstraints { make in
                make.width.equalTo(70)
                make.height.equalTo(58)
            }
        }
        return button
    }


}

public final class DWButton: UIButton {

    public var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    public override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.addGradientInDesignSystem(
                    startColor: .designSystem(.blueTopGradient)!,
                    endColor: .designSystem(.blueBottomGradient)!
                )
            } else {
                self.removeGradientInDesignSystem()
            }
        }
    }
}

extension DWButton {
    public func addGradientInDesignSystem(
        startColor: UIColor,
        endColor: UIColor
    ) {
        self.layoutIfNeeded()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.locations = [0.0 , 1.0]
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = .init(x: 0, y: 0, width: self.frame.width, height: self.frame.height
        )
        self.layer.insertSublayer(gradient, at: 0)
    }
    public func roundCornersInDesignSystem(
      _ radius: CGFloat = 16
    ) {
      self.layer.cornerCurve = .continuous
      self.layer.cornerRadius = radius
      self.clipsToBounds = true
    }

    public func removeGradientInDesignSystem() {
        self.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
    }
}
