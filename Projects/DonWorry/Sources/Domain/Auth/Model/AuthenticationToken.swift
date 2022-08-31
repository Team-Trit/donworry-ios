//
//  AuthenticationToken.swift
//  DonWorry
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

struct AuthenticationToken: Codable {
    var type: String
    var accessToken: String
    var refreshToken: String
}
