//
//  TestCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import PhotosUI
import UIKit


class FilePickerCell: UITableViewCell {
    
    #warning("작업중")
//    var delegate: PhotoSelectButtonDelegate?
    
    var imageArray = [UIImage]()
    
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
    
    
    private lazy var pickerCollectionView: UICollectionView = {
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

        // Configure the view for the selected state
    }

    // https://www.youtube.com/watch?v=yBHpKuTvfdA
    @IBAction func buttonDidTap(_ sender: Any) {

        print("select")
//        self.present(phPickerVC, animated: true)
//        delegate?.didSelectAddPhotoButton()
        
    }
    
}

extension FilePickerCell {
    private func setUI() {
        contentView.addSubview(pickerCollectionView)
        bottomView.addSubview(pickerCollectionView)
        pickerCollectionView.delegate = self
        pickerCollectionView.dataSource = self
        pickerCollectionView.backgroundColor = .designSystem(.white2)
        pickerCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")

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
        return imageArray.count
//        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        cell.container.image = imageArray[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TODO: 선택된 셀 다루기
//        print("선택된 셀 : \(colors[indexPath.row])")
    }
    
}


extension FilePickerCell {
    
    func reloadPhotoCell() {
        DispatchQueue.main.async {
            self.pickerCollectionView.reloadData()
        }
    }
    
}
