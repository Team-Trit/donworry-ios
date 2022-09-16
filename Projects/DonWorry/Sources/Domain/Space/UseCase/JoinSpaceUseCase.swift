//
//  JoinSpaceUseCase.swift
//  DonWorry
//
//  Created by Woody on 2022/09/16.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift

protocol JoinSpaceUseCase {
    func joinSpace(shareID: String) -> Single<SpaceModels.JoinSpace.Response>
}

final class JoinSpaceUseCaseImpl: JoinSpaceUseCase {
    private let spaceRepository: SpaceRepository

    init(
        _ spaceRepository: SpaceRepository = SpaceRepositoryImpl())
    {
        self.spaceRepository = spaceRepository
    }

    func joinSpace(shareID: String) -> Single<SpaceModels.JoinSpace.Response> {
        spaceRepository.joinSpace(shareID: shareID)
    }

}
