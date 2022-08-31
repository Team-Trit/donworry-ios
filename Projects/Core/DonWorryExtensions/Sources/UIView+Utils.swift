//
//  UIView+.swift
//  BaseArchitecture
//
//  Created by Woody on 2022/08/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    func addShadow(
        shadowColor: CGColor = UIColor.black.cgColor,
        offset: CGSize = .init(width: 3, height: 3),
        opacity: Float = 0.7,
        radius: CGFloat = 4.0
    ) {
        self.layer.cornerCurve = .continuous
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    func addShadowWithRoundedCorners(
        _ radius: CGFloat = 16,
        shadowColor: CGColor = UIColor.black.cgColor,
        opacity: Float = 0.1
    ) {
        self.layer.cornerCurve = .continuous
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = 2.5
        self.layer.cornerRadius = radius
    }
    func roundCorners(
        _ radius: CGFloat = 16
    ) {
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    func roundCorners(
        _ corners: UIRectCorner,
        radius: CGFloat
    ) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    func addGradient(
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
    func addGradientWithOutput(
        startColor: UIColor,
        endColor: UIColor
    ) -> CAGradientLayer {
        self.layoutIfNeeded()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.locations = [0.0 , 1.0]
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = .init(x: 0, y: 0, width: self.frame.width, height: self.frame.height
        )
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        self.layer.add(animation, forKey: nil)
    }
    
    /* autolayout 하는 코드 */
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {

        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true

        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }

    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}
