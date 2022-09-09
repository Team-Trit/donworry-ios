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
    }
    static func show(
        message: String,
        subMessage: String? = nil,
        type: ToastType = .information,
        duration: TimeInterval = 3,
        completion: (() -> Void)? = nil
    ) {
        guard let window = UIWindow.current else { return }

        window.subviews
            .filter { $0 is DWToastView }
            .forEach { $0.removeFromSuperview() }

        let toastView = DWToastView(message: message, subTitle: subMessage, backgroundColor: type.color)
        window.addSubview(toastView)

        var topConstaint: Constraint?
        toastView.snp.makeConstraints {
            topConstaint = $0.top.equalTo(window.safeAreaLayoutGuide).offset(-100).constraint
            $0.centerX.equalToSuperview()
        }
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
                withDuration: 0.3,
                animations: {
                    toastView.alpha = 1
                    topConstaint?.update(offset: 12)
                    window.layoutIfNeeded()
                },
                completion: { _ in completion?() }
            )
        }

        func slideDown(completion: (() -> Void)? = nil) {
            toastView.alpha = 1
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    toastView.alpha = 0
                    topConstaint?.update(offset: -100)
                    window.layoutIfNeeded()
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
