//
//  UICollectionViewCell+MaterialBlur.swift
//  DonWorry
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

extension UICollectionViewCell {

    func addCompleteView(_ blurWrappedView: UIView = UIView()) {
        blurWrappedView.tag = 100
        self.contentView.addSubview(blurWrappedView)
        blurWrappedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addBlurEffectView(to: blurWrappedView)
    }

    func removeCompleteView() {
        contentView.subviews.filter { $0.tag == 100 }.forEach { $0.removeFromSuperview() }
    }
    private func addBlurEffectView(to view: UIView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addCompleteCheckImageView(to: blurEffectView)
        view.addSubview(blurEffectView)
    }

    private func addCompleteCheckImageView(to superView: UIVisualEffectView) {
        let checkImageView = UIImageView(image: .init(.ic_check_white))
        superView.contentView.addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(36)
        }
    }
}
