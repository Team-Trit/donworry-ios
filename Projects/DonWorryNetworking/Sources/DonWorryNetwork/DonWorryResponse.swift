//
//  DonWorryResponse.swift
//  Networking
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    let status: Int
    let message: String?
}
