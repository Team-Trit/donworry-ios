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
        guard let bundle = Bundle(identifier: "com.TriT.DesignSystem") else {
            return nil
        }
        self.init(named: asset.rawValue, in: bundle, with: nil)
    }
}
