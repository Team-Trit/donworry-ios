//
//  UITableView+Utils.swift
//  DonWorryExtensions
//
//  Created by Woody on 2022/09/05.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(_ cell: T.Type) {
        let identifier: String = String(describing: T.self)
        self.register(T.self, forCellReuseIdentifier: identifier)
    }
    func dequeueReusableCell<T: UITableViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        let identifier: String = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return .init()
        }
        return cell
    }
}

