//
//  DonWorryResponse.swift
//  Networking
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

struct DonwWorryResponse<DTO: Decodable>: Decodable {
    let statusCode: Int?
    let message: String?
    let data: DTO?
}
