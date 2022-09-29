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

struct ParticipantListCellViewModel: Hashable {
    let users: [ParticipantCellViewModel]
}

final class ParticipantListCollectionViewCell: UICollectionViewCell {

    typealias Section = SpaceJoinSection
    typealias DataSource = SpaceJoinUserDiffableDataSource

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
        layout.minimumInteritemSpacing = 17
        layout.minimumLineSpacing = 17
        layout.estimatedItemSize = .init(width: 48, height: 78)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        v.register(ParticipantCollectionViewCell.self)
        v.backgroundColor = .clear
        return v
    }()

    lazy var dataSource = DataSource(collectionView: collectionView)

    func configure(with model: ParticipantListCellViewModel) {
        apply(items: model.users)

        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = "현재 참가자 : \(model.users.count)명"
            self?.collectionView.reloadData()
        }
    }

    func apply(items: [ParticipantCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Section.Item>()
        snapshot.appendSections([.users(items: [])])
        snapshot.sectionIdentifiers.forEach { section in
            snapshot.appendItems(items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
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
            make.bottom.equalToSuperview()
        }

        collectionView.dataSource = dataSource
    }
}

enum SpaceJoinSection: Hashable {
    typealias Item = ParticipantCellViewModel
    case users(items: [Item])
}

final class SpaceJoinUserDiffableDataSource: UICollectionViewDiffableDataSource<SpaceJoinSection, SpaceJoinSection.Item> {
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(ParticipantCollectionViewCell.self, for: indexPath)
            cell.crownImageView.isHidden = indexPath.item != 0
            cell.configure(with: itemIdentifier)
            return cell
        }
    }
}
