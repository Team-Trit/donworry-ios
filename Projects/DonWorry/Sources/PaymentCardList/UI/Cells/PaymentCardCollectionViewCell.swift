//
//  PaymentCardCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/14.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import DonWorryExtensions

final class PaymentCardCollectionViewCell: UICollectionViewCell {
    lazy var paymentCardView = PaymentCardView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setUI()
    }

    private func setUI() {
        self.contentView.addSubview(self.paymentCardView)

        self.paymentCardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
