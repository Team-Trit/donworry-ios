//
//  TestCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import PhotosUI
import UIKit

import DesignSystem

protocol FilePickerCellCollectionViewDelegate: AnyObject {
    func selectPhoto()
}


// MARK: - 도메인 로직 생기고 교체 예정 | 전역변수 죄송합니다
var imageArray = [UIImage]()

class FilePickerCell: UITableViewCell {

    weak var filePickerCellCollectionViewDelegate: FilePickerCellCollectionViewDelegate?
    
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var bottomDescriptionLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.isHidden = true
        }
    }

    lazy var pickerCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCollecionViewLayout())
        cv.isScrollEnabled = false
        return cv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topTitleLabel.textColor = UIColor(hex: "#606060FF")
        self.containerStackView.layer.cornerRadius = 10
        self.containerStackView.layer.masksToBounds = true
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension FilePickerCell {
    private func setUI() {
        bottomView.addSubview(pickerCollectionView)
        pickerCollectionView.delegate = self
        pickerCollectionView.dataSource = self
        pickerCollectionView.backgroundColor = .designSystem(.white2)
        pickerCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        pickerCollectionView.register(PhotoAddCell.self, forCellWithReuseIdentifier: "PhotoAddCell")

        pickerCollectionView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.edges.equalToSuperview().inset(10)
        }
        
    }
    
    func configure(isHidden: Bool) {
        self.bottomView.isHidden = isHidden
        self.chevronImageView.image = UIImage(systemName: isHidden ? "chevron.down" : "chevron.up")
        self.selectionStyle = .none
    }
    
}


// MARK: - CollectionView

extension FilePickerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func createCollecionViewLayout() -> UICollectionViewCompositionalLayout{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(84), heightDimension: .absolute(84))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(84))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if imageArray.count == 0 {
            return 1
        } else if imageArray.count == 3 {
            return 3
        } else {
            return imageArray.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if imageArray.count > 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
            cell.photoCellDelegate = self
            cell.container.image = imageArray[indexPath.row]
            cell.deleteCircle.tag = indexPath.row
            return cell
        } else {
            if indexPath.row == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoAddCell", for: indexPath) as? PhotoAddCell else { return UICollectionViewCell() }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
                cell.photoCellDelegate = self
                cell.container.image = imageArray[(indexPath.row - 1)]
                cell.deleteCircle.tag = (indexPath.row - 1)
                return cell
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imageArray.count < 3 && indexPath.row == 0 {
            filePickerCellCollectionViewDelegate?.selectPhoto()
        }

    }
    
}


extension FilePickerCell: PhotoUpdateDelegate, PhotoCellDelegate {

    func updatePhotoCell(img: [UIImage]) {
        imageArray = img
        DispatchQueue.main.async {
            self.pickerCollectionView.reloadData()
        }
    }
    
    func deletePhoto() {
        DispatchQueue.main.async {
            self.pickerCollectionView.reloadData()
        }
    }

}
