//
//  DetailImageViewController.swift
//  DonWorry
//
//  Created by Hankyu Lee on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Kingfisher
import UIKit

class DetailImageViewController: UIViewController {
    
    let container : UIImageView = {
        $0.contentMode = .scaleToFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    var imageUrl: String? {
        didSet {
            let url = URL(string: imageUrl ?? "")
            container.kf.indicatorType = .activity
            container.kf.setImage(with: url,
                                  options: [.forceTransition])
            //reload
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .designSystem(.grayF6F6F6)
        view.addSubview(container)
        container.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    
}
