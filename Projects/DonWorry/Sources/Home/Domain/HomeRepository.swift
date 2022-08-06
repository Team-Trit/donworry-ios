//
//  HomeRepository.swift
//  DonWorry
//
//  Created by Woody on 2022/08/04.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeRepository {
    func allRooms() -> Observable<[String]>
}

final class HomeRepositoryImpl: HomeRepository {

    init() {}

    func allRooms() -> Observable<[String]> {
        return .just(dummy)
    }
}

extension HomeRepositoryImpl {
    private var dummy: [String] {
        return ["MC2 번개모임", "떱떱해", "트라잇", "밤샘코딩", "문샷"]
    }
}
