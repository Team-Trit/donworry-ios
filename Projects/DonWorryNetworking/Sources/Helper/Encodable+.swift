//
//  Encodable+.swift
//  DonWorryNetworkingTests
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension Encodable {
    var dicationary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        let result = (try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)).flatMap { $0 as? [String: Any] }

        if let result = result {
            return result
        } else {
            return [:]
        }
    }
}
