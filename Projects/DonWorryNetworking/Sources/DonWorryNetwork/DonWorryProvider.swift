//
//  DonWorryProvider.swift
//  Networking
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

final class DonWorryProvider<Target: TargetType>: MoyaProvider<Target> {

    init(
        plugins: [PluginType] = [],
        stubClosure: @escaping StubClosure = MoyaProvider.neverStub
    ) {
        super.init(
            stubClosure: stubClosure,
            plugins: plugins + [loggin]
        )
    }

    private let loggin = NetworkLogging()
}
