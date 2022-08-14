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

struct PaymentCardCellDdipUser: Equatable {
    var id: Int
    var nickName: String
    var imageURL: String
}

struct PaymentCardCellViewModel: Equatable {
    var id: Int
    var name: String
    var amount: Int
    var number: Int
    var payer: PaymentCardCellDdipUser
    var participatedUserList: [PaymentCardCellDdipUser]
    var dateString: String
}

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
        self.roundCorners(20)
        self.layer.borderColor = UIColor.designSystem(.white)?.cgColor
        self.layer.borderWidth = 1
        self.addShadowWithRoundedCorners(20, shadowColor: UIColor.designSystem(.black)!.cgColor, opacity: 0.6)
        self.contentView.addSubview(self.paymentCardView)

        self.paymentCardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.paymentCardView.layer.masksToBounds = true
    }

}
