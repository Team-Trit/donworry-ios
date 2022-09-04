//
//  SpaceService.swift
//  DonWorryTests
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol SpaceService {
    func fetchSpaceList() -> Observable<SpaceModels.FetchSpaceList.Response>
}

final class SpaceServiceImpl: SpaceService {
    private let spaceRepository: SpaceRepository
    init(
    _ spaceRepository: SpaceRepository = SpaceRepositoryImpl()) {
        self.spaceRepository = spaceRepository
    }

    func fetchSpaceList() -> Observable<SpaceModels.FetchSpaceList.Response> {
        spaceRepository.fetchSpaceList()
    }

}
