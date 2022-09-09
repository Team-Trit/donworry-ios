//
//  UploadImageDTO.swift
//  DonWorryNetworkingTests
//
//  Created by Woody on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct UploadImage: Codable {
        public let imgUrl: String
        public init(_ imgURL: String) {
            self.imgUrl = imgURL
        }
    }
}
