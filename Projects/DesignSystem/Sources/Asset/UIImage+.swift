//
//  UIImage+.swift
//  DesignSystem
//
//  Created by Woody on 2022/08/08.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public extension UIImage {
    convenience init?(_ asset: Asset) {
        self.init(named: asset.rawValue, in: Bundle.module, with: nil)
    }

    convenience init?(assetName: String) {
        self.init(named: assetName, in: Bundle.module, with: nil)
    }
}
