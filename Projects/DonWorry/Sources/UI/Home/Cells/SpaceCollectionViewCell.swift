//
//  SpaceCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/08/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit
import DonWorryExtensions
import SkeletonView

struct SpaceCellViewModel: Hashable {
    var id: Int
    var title: String
    var status: SpaceCollectionViewCell.SpaceStatus
    var adminID: Int
    var isAllPaymentCompleted: Bool
    var isSelect: Bool
}

final class SpaceCollectionViewCell: UICollectionViewCell {

    enum SpaceStatus: String {
        case OPEN
        case PROGRESS
        case DONE
    }

    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 2
        v.font = .designSystem(weight: .bold, size: ._13)
        v.textAlignment = .center
        return v
    }()

    func configure(with model: SpaceCellViewModel) {
        let textColor: UIColor? = model.isSelect ? .designSystem(.white) : .designSystem(.black)
        let backgroundColor: UIColor? = model.isSelect ?
        model.status.selectedBackgroundColor :
        model.status.unselectedBackgroundColor

        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = model.title
            self?.titleLabel.textColor = textColor
            self?.contentView.backgroundColor = backgroundColor
        }
    }
    
    var viewModel: SpaceCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel.text = viewModel.title
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected { selectedAttributes() }
            else { unSelectedAttributes() }
        }
    }

    func selectedAttributes() {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.textColor = .designSystem(.white)
            self?.contentView.backgroundColor = self?.viewModel?.status.selectedBackgroundColor
        }
    }

    func unSelectedAttributes() {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.textColor = .designSystem(.black)
            self?.contentView.backgroundColor = self?.viewModel?.status.unselectedBackgroundColor
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
        self.skeletonCornerRadius = Float(self.contentView.bounds.width / 2)
        self.contentView.roundCorners(self.contentView.bounds.width / 2)
        self.contentView.backgroundColor = .designSystem(.grayF6F6F6)
        self.contentView.addSubview(self.titleLabel)

        [self, titleLabel].forEach { [weak self] in
            self?.commonAttribute(of: $0)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(20)
        }
    }

    func startAnimation() {
        self.showAnimatedGradientSkeleton()
        titleLabel.showAnimatedGradientSkeleton()
    }

    func hideAnimation() {
        self.hideSkeleton()
        titleLabel.hideSkeleton()
    }

    private func commonAttribute(of target: UIView) {
        target.isSkeletonable = true
    }
}

extension SpaceCollectionViewCell.SpaceStatus {

    var unselectedBackgroundColor: UIColor? {
        switch self {
        case .OPEN:
            return .designSystem(.grayF6F6F6)
        case .PROGRESS:
            return .designSystem(.blueToast)?.withAlphaComponent(0.2)
        case .DONE:
            return .designSystem(.redToast)?.withAlphaComponent(0.2)
        }
    }

    var selectedBackgroundColor: UIColor? {
        switch self {
        case .OPEN:
            return .designSystem(.black)
        case .PROGRESS:
            return .designSystem(.blueTopGradient)
        case .DONE:
            return .designSystem(.redTopGradient)
        }
    }
}
