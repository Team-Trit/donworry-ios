//
//  ParticipantListCollectionViewCell.swift
//  DonWorry
//
//  Created by Woody on 2022/09/20.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import SnapKit
import DonWorryExtensions
import DesignSystem


struct ParticipantListCellViewModel {
    let users: [ParticipantCellViewModel]
}

final class ParticipantListCollectionViewCell: UICollectionViewCell {

    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = .designSystem(weight: .heavy, size: ._15)
        v.textColor = .designSystem(.black)
        v.text = "현재 참가자 : 0명"
        return v
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 17
        layout.estimatedItemSize = .init(width: 48, height: 60)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        v.register(ParticipantCollectionViewCell.self)
        v.backgroundColor = .clear
        v.delegate = self
        v.dataSource = self
        return v
    }()

    var viewModel: ParticipantListCellViewModel? {
        didSet {
            titleLabel.text = "현재 참가자 : \(viewModel?.users.count ?? 0)명"
            collectionView.reloadData()
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
        self.backgroundColor = .designSystem(.grayF6F6F6)
        self.roundCorners(20)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(collectionView)

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
}

// MARK: UICollectionViewDataSource

extension ParticipantListCollectionViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.users.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ParticipantCollectionViewCell.self, for: indexPath)
        cell.crownImageView.isHidden = indexPath.item != 0
        cell.viewModel = viewModel?.users[indexPath.item]
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ParticipantListCollectionViewCell: UICollectionViewDelegateFlowLayout {

}
