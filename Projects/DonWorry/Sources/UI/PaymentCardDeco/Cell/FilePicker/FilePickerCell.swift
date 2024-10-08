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
    func deletePhoto(imageURL: String)
}


// MARK: - 도메인 로직 생기고 교체 예정 | 전역변수 죄송합니다
//var imageArray = [UIImage]()

struct FilePickerCellViewModel {
    var imageURLs: [String]
}

final class FilePickerCell: UITableViewCell {

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

    var viewModel: FilePickerCellViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.pickerCollectionView.reloadData()
            }
        }
    }
    lazy var pickerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
            $0.edges.equalToSuperview().inset(15)
        }
        
    }
    
    func configure(isHidden: Bool) {
        self.bottomView.isHidden = isHidden
        self.chevronImageView.image = UIImage(systemName: isHidden ? "chevron.down" : "chevron.up")
        self.selectionStyle = .none
    }
    
}


// MARK: - CollectionView

extension FilePickerCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        let imageCount = viewModel.imageURLs.count
        return imageCount < 3 ? imageCount + 1 : imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return .init() }
        if viewModel.imageURLs.count > 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
            cell.viewModel = viewModel.imageURLs[indexPath.row]
            cell.photoCellDelegate = self
            cell.deleteCircle.tag = indexPath.row
            return cell
        } else {
            if indexPath.row == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoAddCell", for: indexPath) as? PhotoAddCell else { return UICollectionViewCell() }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
                cell.viewModel = viewModel.imageURLs[indexPath.row - 1]
                cell.photoCellDelegate = self
                cell.deleteCircle.tag = (indexPath.row - 1)
                return cell
            }
        }
    }
}

extension FilePickerCell: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.bounds.width - 20 - 30) / 3
        return .init(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        if viewModel.imageURLs.count < 3 && indexPath.row == 0 {
            filePickerCellCollectionViewDelegate?.selectPhoto()
        }
    }
}

extension FilePickerCell: PhotoCellDelegate {
    
    func deletePhoto(imageURL: String) {
        self.filePickerCellCollectionViewDelegate?.deletePhoto(imageURL: imageURL)
    }
}
