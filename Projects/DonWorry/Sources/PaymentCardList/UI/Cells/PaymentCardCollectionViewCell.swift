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
    var totalAmount: String
    var number: Int
    var cardIconImageName: String
    var payer: PaymentCardCellDdipUser
    var participatedUserList: [PaymentCardCellDdipUser]
    var dateString: String
    var backgroundColor: String
}

final class PaymentCardCollectionViewCell: UICollectionViewCell {
    lazy var paymentCardInRoomView = PaymentCardInRoomView()

    var viewModel: PaymentCardCellViewModel? {
        didSet {
            self.paymentCardInRoomView.viewModel = viewModel.map { model in
                return PaymentCardInRoomViewModel(
                    id: model.id,
                    name: model.name,
                    cardIconImageName: model.cardIconImageName,
                    totalAmount: model.totalAmount,
                    backgroundColor: model.backgroundColor,
                    date: model.dateString,
                    payer: model.payer,
                    participatedUserList: model.participatedUserList)
            }
        }
    }
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
        self.contentView.addSubview(self.paymentCardInRoomView)

        self.paymentCardInRoomView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.paymentCardInRoomView.layer.masksToBounds = true
    }

}
