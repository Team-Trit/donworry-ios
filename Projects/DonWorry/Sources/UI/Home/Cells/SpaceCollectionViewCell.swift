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

struct SpaceCellViewModel {
    var title: String
}

final class SpaceCollectionViewCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 2
        v.font = .designSystem(weight: .bold, size: ._13)
        v.textAlignment = .center
        return v
    }()
    var gradientLayers: [CAGradientLayer] = []
    var viewModel: SpaceCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel.text = viewModel.title
            }
        }
    }

    func selectedAttributes() {
        self.titleLabel.textColor = .designSystem(.white)
        if gradientLayers.isEmpty {
            let layer = self.contentView.addGradientWithOutput(
                startColor: .designSystem(.blueTopGradient)!,
                endColor: .designSystem(.blueBottomGradient)!
            )
            self.gradientLayers.append(layer)
        }
    }

    func initialAttributes() {
        self.titleLabel.textColor = .designSystem(.black)
        self.contentView.backgroundColor = .designSystem(.grayF6F6F6)
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
        self.contentView.roundCorners(self.contentView.bounds.width / 2)
        self.contentView.backgroundColor = .designSystem(.grayF6F6F6)
        self.contentView.addSubview(self.titleLabel)

        self.titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(20)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if gradientLayers.isNotEmpty {
            gradientLayers.forEach { $0.removeFromSuperlayer() }
            gradientLayers = []
        }
    }
}
