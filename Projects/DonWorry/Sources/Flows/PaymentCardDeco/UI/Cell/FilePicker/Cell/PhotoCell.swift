//
//  PhotoCell.swift
//  DonWorry
//
//  Created by Chanhee Jeong on 2022/08/24.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import DesignSystem


protocol PhotoCellDelegate: AnyObject {
    func deletePhoto()
}

class PhotoCell: UICollectionViewCell {
    
    weak var photoCellDelegate: PhotoCellDelegate?

    lazy var container: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    lazy var deleteCircle: UIButton = {
        $0.setImage(UIImage(.delete_mark), for: .normal)
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(deletePhoto(_:)), for: .touchUpInside)
        return $0
    }(UIButton())

    @objc private func deletePhoto(_ sender: UIButton) {
        if !imageArray.isEmpty {
            imageArray.remove(at: tag)
            photoCellDelegate?.deletePhoto()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.roundCorners(15)
        
        self.contentView.addSubview(self.container)
        container.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top)
            $0.left.equalTo(self.contentView.snp.left)
            $0.bottom.equalTo(self.contentView.snp.bottom)
            $0.right.equalTo(self.contentView.snp.right)
        }
        
        self.contentView.addSubview(deleteCircle)
        deleteCircle.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.equalTo(container.snp.top).inset(8)
            $0.trailing.equalTo(container.snp.trailing).inset(8)
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
