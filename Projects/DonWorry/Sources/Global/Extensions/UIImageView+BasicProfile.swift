//
//  UIImageView+BasicProfileImage.swift
//  DonWorry
//
//  Created by Woody on 2022/09/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import Kingfisher
import DesignSystem

extension UIImageView {
    func setBasicProfileImageWhenNilAndEmpty(with urlString: String?) {
        if let urlString = urlString, urlString.isEmpty == false {
            self.kf.indicatorType = .activity
            let url = URL(string: urlString)
            self.kf.setImage(with: url,
                             options: [.forceTransition])
        } else {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.backgroundColor = .designSystem(Pallete.grayF6F6F6)
            self.image = UIImage(.ic_basic_profile_image)
        }
    }
    
}
