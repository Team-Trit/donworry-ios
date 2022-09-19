//
//  DonWorrySession.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/09/20.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

class DonWorrySesssion: Session {
    static let shared: DonWorrySesssion = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest  = 30
        configuration.timeoutIntervalForResource = 30
        configuration.requestCachePolicy         = .useProtocolCachePolicy
        return DonWorrySesssion(configuration: configuration)
    }()
}
