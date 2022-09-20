//
//  DetailImageViewController.swift
//  DonWorry
//
//  Created by Hankyu Lee on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import UIKit

class DetailImageViewController: UIViewController {
    
    let imageView : UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    let closeButton: UIButton = {
        $0.tintColor = .designSystem(.white)
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        $0.addTarget(self, action: #selector(sheetClosed), for: .touchUpInside)
        return $0
    }(UIButton())
    
    var imageUrl: String? {
        didSet {
            let url = URL(string: imageUrl ?? "")
            imageView.kf.setImage(with: url)
        }
    }
    
    @objc private func sheetClosed() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .designSystem(.black)
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 0, paddingRight: 0)
        imageView.centerY(inView: view)
        imageView.setHeight(height: UIScreen.main.bounds.height / 2)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 40, paddingLeft: 20)
    }
    
    
}
