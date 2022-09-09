//
//  DWToastView.swift
//  DonWorry
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import DonWorryExtensions
import DesignSystem

final class DWToastView: UIView {
    init(message: String, subTitle: String? = nil, backgroundColor: UIColor? = .designSystem(Pallete.black), messageColor: UIColor? = .designSystem(.gray818181), subTitleColor: UIColor? = .designSystem(.black)) {
        super.init(frame: .zero)

        self.messageLabel.textColor = messageColor
        self.subTitleLabel.textColor = subTitleColor
        self.messageLabel.text = message
        self.subTitleLabel.text = subTitle
        self.backgroundColor = backgroundColor
        self.addBlurEffectView(to: self)
        self.setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let messageLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let titleStackView = UIStackView()
}

extension DWToastView {
    private func setUI() {
        self.roundCorners(25)
        self.messageLabel.font = .designSystem(weight: .bold, size: ._13)
        self.subTitleLabel.font = .designSystem(weight: .bold, size: ._13)
        self.messageLabel.textAlignment = .center
        self.subTitleLabel.textAlignment = .center
        self.titleStackView.axis = .vertical
        self.titleStackView.spacing = 0
        self.titleStackView.alignment = .center
        self.titleStackView.distribution = .fill

        self.addSubview(titleStackView)
        self.titleStackView.addArrangedSubviews(messageLabel, subTitleLabel)
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        self.titleStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
    }

    private func addBlurEffectView(to view: UIView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
