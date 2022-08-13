//
//  Formatter.swift
//  DonWorry
//
//  Created by Woody on 2022/08/10.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

struct Formatter {
    static let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
