//
//  PaymentCardCollectionView.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DonWorryExtensions

final class BillCardCollectionView: UICollectionView {

    convenience init() {
        let flowLayout = CircularCollectionViewLayout()
        self.init(frame: .zero, collectionViewLayout: flowLayout)
        self.register(TakeBillCardCollectionViewCell.self)
        self.register(GiveBillCardCollectionViewCell.self)
        self.register(StateBillCardCollectionViewCell.self)
        self.register(LeavePaymentRoomBillCardCollectionViewCell.self)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .clear
        self.allowsSelection = true
        self.allowsMultipleSelection = false
        self.decelerationRate = .fast
    }
}

extension BillCardCollectionView: CircularCollectionViewLayoutDelegate {
    private var screenWidth: CGFloat {
        UIApplication.shared.delegate?.window??.windowScene?.screen.bounds.width ?? 0
    }

    var itemSize: CGSize {
        let width: CGFloat = screenWidth - 115 * 2
        let height: CGFloat = width * 215 / 160
        return .init(width: width, height: height)
    }
    func scrollToIndentity() {}

}
