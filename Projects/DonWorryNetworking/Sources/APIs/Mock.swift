//
//  Mock.swift
//  Networking
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

struct MockAPI: ServiceAPI {
    typealias Response = DTO.Empty

    private let query: String

    var path: String = ""
    var method: Method = .get
    var task: Task = .requestPlain

    init(query: String) {
        self.query = query
    }
}
