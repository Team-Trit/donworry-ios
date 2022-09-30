//
//  UIImage+Utils.swift
//  DonWorryExtensions
//
//  Created by 김승창 on 2022/09/30.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
