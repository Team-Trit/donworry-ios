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
    case xlargeBlue
    case xlargeGray
    case largeBlue // 262
    case mediumBlue // 222
    case smallBlue // 106
    case halfMainBlue // 162
    case halfGray // 162
    case halfLightBlue
    case xsmallGray // 70
}

public extension DWButton {

    static func create(_ type: DonWorryButtonType) -> DWButton {
        let button = DWButton(type: .system)
        switch type {
        case .xlargeBlue:
            button.roundCorners(25)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.addGradient(
                startColor: .designSystem(.blueTopGradient)!,
                endColor: .designSystem(.blueBottomGradient)!
            )
            button.snp.makeConstraints { make in
                make.width.equalTo(320)
                make.height.equalTo(50)
            }
        case .xlargeGray:
            button.roundCorners(25)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.backgroundColor = .designSystem(.grayC5C5C5)
            button.snp.makeConstraints { make in
                make.width.equalTo(320)
                make.height.equalTo(50)
            }
        case .largeBlue:
            button.roundCorners(29)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.tintColor = .designSystem(.white)
            button.addGradient(
                startColor: .designSystem(.blueTopGradient)!,
                endColor: .designSystem(.blueBottomGradient)!
            )
            button.snp.makeConstraints { make in
                make.width.equalTo(262)
                make.height.equalTo(58)
            }
        case .mediumBlue:
            button.roundCorners(29)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.tintColor = .designSystem(.white)
            button.addGradient(
                startColor: .designSystem(.blueTopGradient)!,
                endColor: .designSystem(.blueBottomGradient)!
            )
            button.snp.makeConstraints { make in
                make.width.equalTo(222)
                make.height.equalTo(58)
            }
        case .smallBlue:
            button.roundCorners(29)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.tintColor = .designSystem(.white)
            button.addGradient(
                startColor: .designSystem(.blueTopGradient)!,
                endColor: .designSystem(.blueBottomGradient)!
            )
            button.snp.makeConstraints { make in
                make.width.equalTo(106)
                make.height.equalTo(58)
            }
        case .halfMainBlue:
            button.roundCorners(25)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.tintColor = .designSystem(.white)
            button.backgroundColor = .designSystem(.mainBlue)
            button.snp.makeConstraints { make in
                make.width.equalTo(162)
                make.height.equalTo(58)
            }
        case .halfGray:
            button.roundCorners(25)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.white), for: .normal)
            button.tintColor = .designSystem(.white)
            button.backgroundColor = .designSystem(.grayC5C5C5)
            button.snp.makeConstraints { make in
                make.width.equalTo(162)
                make.height.equalTo(58)
            }
        case .halfLightBlue:
            button.roundCorners(25)
            button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
            button.setTitleColor(.designSystem(.mainBlue), for: .normal)
            button.tintColor = .designSystem(.mainBlue)
            button.backgroundColor = .designSystem(.lightBlue)
            button.snp.makeConstraints { make in
                make.width.equalTo(162)
                make.height.equalTo(58)
            }
        case .xsmallGray:
            button.roundCorners(29)
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
}

extension UIButton {
    fileprivate func addGradient(
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
    fileprivate func roundCorners(
      _ radius: CGFloat = 16
    ) {
      self.layer.cornerCurve = .continuous
      self.layer.cornerRadius = radius
      self.clipsToBounds = true
    }
}
