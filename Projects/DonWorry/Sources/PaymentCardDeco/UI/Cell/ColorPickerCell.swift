//
//  ColorPickerCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/18.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

class ColorPickerCell: UITableViewCell {
    
    private var colors: [cardColor] = [.yellow, .purple, .brown, .red, .skyblue,
                                   .green, .pink, .navy, .blue1, .black]
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.isHidden = true
        }
    }
    
    private lazy var colorCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCollecionViewLayout())
        cv.isScrollEnabled = false
        return cv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerStackView.layer.cornerRadius = 10
        self.containerStackView.layer.masksToBounds = true
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension ColorPickerCell {
    private func setUI() {
        contentView.addSubview(colorCollectionView)
        bottomView.addSubview(colorCollectionView)
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.backgroundColor = .designSystem(.white2)
        colorCollectionView.register(ColorCircleCell.self, forCellWithReuseIdentifier: "ColorCircleCell")

        colorCollectionView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.edges.equalToSuperview().inset(10)
        }

    }
}


// MARK: - CollectionView

extension ColorPickerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func createCollecionViewLayout() -> UICollectionViewCompositionalLayout{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(50), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCircleCell", for: indexPath) as? ColorCircleCell else { return UICollectionViewCell() }
        cell.configure(with: colors[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TODO: 선택된 셀 다루기
        print("선택된 셀 : \(colors[indexPath.row])")
    }
    
}
