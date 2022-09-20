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
        let layout = HorizontalCarouselLayout()
        self.init(frame: .zero, collectionViewLayout: layout)
        layout.delegate = self
        self.delegate = self
        self.layer.masksToBounds = false
        self.register(StateBillCardCollectionViewCell.self)
        self.register(TakeBillCardCollectionViewCell.self)
        self.register(GiveBillCardCollectionViewCell.self)
        self.register(LeaveSpaceBillCardCollectionViewCell.self)
        self.contentInset = .init(top: 0, left: collectionViewInset, bottom: 0, right: collectionViewInset)
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = .fast
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension BillCardCollectionView: UICollectionViewDelegateFlowLayout {
    fileprivate var collectionViewInset: CGFloat {
        return 80 // 94
    }

    fileprivate var itemSpacing: CGFloat {
        return -15
    }

    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let itemWidth: CGFloat = UIScreen.main.bounds.width - collectionViewInset * 2
        let cellWidthIncludingSpacing = itemWidth + itemSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)

        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

// MARK: HorizontalCarouselLayoutDelegate

extension BillCardCollectionView: HorizontalCarouselLayoutDelegate {
    public func itemSize(
        _ collectionView: UICollectionView
    ) -> CGSize {
        let width: CGFloat = collectionView.bounds.width - collectionViewInset * 2
        let height: CGFloat = width * 1.33
        return .init(width: width, height: height)
    }

    public func minimumLineSpacing(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout
    ) -> CGFloat {
        return itemSpacing
    }
}
