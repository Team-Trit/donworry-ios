//
//  LogoutDTO.swift
//  DonWorryNetworking
//
//  Created by 김승창 on 2022/09/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

extension DTO {
    public struct Logout: Codable {
        public let result: String
        public init(_ result: String) {
            self.result = result
        }
    }
}
