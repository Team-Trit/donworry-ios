//
//  Environment.swift
//  Networking
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

struct Environment {
    var network: NetworkServable
}

extension Environment {
    static let current = Environment(network: NetworkService())
}
