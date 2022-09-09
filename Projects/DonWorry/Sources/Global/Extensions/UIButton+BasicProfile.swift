//
//  UIButton+BasicProfile.swift
//  DonWorry
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
import Kingfisher
import DesignSystem

extension UIButton {
    func setWhenNilImageBasicProfileImage(with urlString: String?) {
        if let urlString = urlString,
           !urlString.isEmpty {
            let url = URL(string: urlString)
            self.kf.setImage(with: url, for: .normal)
        } else {
            self.backgroundColor = .designSystem(Pallete.grayF6F6F6)
            self.setImage(UIImage(.ic_basic_profile_image), for: .normal)
        }
    }
}
