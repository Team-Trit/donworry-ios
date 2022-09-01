//
//  Space.swift
//  DonWorry
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

enum Entity {}

extension Entity {
    struct Space {
        let id: Int
        let adminID: Int
        let title, status, shareID: String
        let isTaker: Bool
        let payments: [SpacePayment]
    }
}
