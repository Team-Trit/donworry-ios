//
//  DWToastFactory.swift
//  DonWorry
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

final class DWToastFactory {
    enum ToastType {
        case error
        case success
        case information

        var color: UIColor? {
            switch self {
            case .error:
                return .designSystem(Pallete.redFF0B0B)?.withAlphaComponent(0.8)
            case .success:
                return .designSystem(Pallete.lightBlue)?.withAlphaComponent(0.8)
            case .information:
                return .designSystem(Pallete.white)?.withAlphaComponent(0.8)
            }
        }

        var messageColor: UIColor? {
            switch self {
            case .error:
                return .designSystem(.white)
            case .success:
                return .designSystem(.lightBlue)
            case .information:
                return .designSystem(.gray818181)
            }
        }
        var subTitleMessageColor: UIColor? {
            switch self {
            case .error:
                return .designSystem(.white)
            case .success:
                return .designSystem(.white)
            case .information:
                return .designSystem(.black)
            }
        }
    }
    
    static func show (
        message: String,
        subMessage: String? = nil,
        type: ToastType = .information,
        duration: TimeInterval = 1.25,
        completion: (() -> Void)? = nil
    ) {
        guard let window = UIWindow.current else { return }

        window.subviews
            .filter { $0 is DWToastView }
            .forEach { $0.removeFromSuperview() }

        let toastView = DWToastView(message: message, subTitle: subMessage, backgroundColor: type.color, messageColor: type.messageColor, subTitleColor: type.subTitleMessageColor)
        window.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        toastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: -100)
        
        
        window.layoutSubviews()
        self.feedbackGenerator.notificationOccurred(.success)
        
        
        slideUp(completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                slideDown(completion: {
                    completion?()
                })
            }
        })
        

        func slideUp(completion: (() -> Void)? = nil) {
            toastView.alpha = 0
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    toastView.alpha = 1
                    toastView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).translatedBy(x: 0, y: 50)
                    
                },
                completion: { _ in completion?() }
            )
        }

        func slideDown(completion: (() -> Void)? = nil) {
            toastView.alpha = 1
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    toastView.alpha = 0
                    toastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: -100)
                },
                completion: { _ in
                    toastView.removeFromSuperview()
                    completion?()
                }
            )
        }

        
    }

    private static let feedbackGenerator = UINotificationFeedbackGenerator()
}

extension UIWindow {

    public static var current: UIWindow? {
        UIApplication.shared.windows.first(where: \.isKeyWindow)
    }

}
