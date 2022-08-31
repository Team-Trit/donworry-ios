//
//  UIImageView+.swift
//  DonWorryExtensions
//
//  Created by Hankyu Lee on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit
public extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
