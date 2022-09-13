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
                return .designSystem(Pallete.redToast)?.withAlphaComponent(0.15)
            case .success:
                return .designSystem(Pallete.blueToast)?.withAlphaComponent(0.15)
            case .information:
                return .designSystem(Pallete.grayC5C5C5)?.withAlphaComponent(0.15)
            }
        }

        var messageColor: UIColor? {
            switch self {
            case .error:
                return .designSystem(.gray818181)
            case .success:
                return .designSystem(.gray818181)
            case .information:
                return .designSystem(.gray818181)
            }
        }
        var subTitleMessageColor: UIColor? {
            switch self {
            case .error:
                return .designSystem(.black)
            case .success:
                return .designSystem(.black)
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
        
        var toastArea = 50
        if !UIDevice.current.hasNotch {
            toastArea = 20
        }
        
        guard let window = UIWindow.current else { return }

        window.subviews
            .filter { $0 is DWToastView }
            .forEach { $0.removeFromSuperview() }

        let toastView = DWToastView(message: message, subTitle: subMessage, backgroundColor: type.color, messageColor: type.messageColor, subTitleColor: type.subTitleMessageColor)
        window.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        toastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: CGFloat(-toastArea*2))
        
        
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
                    toastView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).translatedBy(x: 0, y: CGFloat(toastArea))
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
                    toastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: CGFloat(-toastArea*2))
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

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            // Fallback on earlier versions
            return false
        }
    }
}
