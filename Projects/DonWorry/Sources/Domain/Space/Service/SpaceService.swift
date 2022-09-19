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
    func fetchSpace(request: SpaceModels.FetchSpace.Request) -> Observable<SpaceModels.FetchSpace.Response>
    func createSpace(title: String) -> Observable<SpaceModels.CreateSpace.Response>
    func joinSpace(shareID: String) -> Single<SpaceModels.JoinSpace.Response>
    func editSpaceName(id: Int, name: String) -> Observable<SpaceModels.EditSpaceTitle.Response>
    func leaveSpace(request: SpaceModels.LeaveSpace.Request) -> Observable<SpaceModels.Empty.Response>
    func leaveSpaceInProgress(requeset: SpaceModels.LeaveSpaceInProgress.Request) -> Observable<SpaceModels.FetchSpaceList.Response>
    func startPaymentAlogrithm(request: SpaceModels.StartPaymentAlogrithm.Request) -> Observable<SpaceModels.Empty.Response>
}

final class SpaceServiceImpl: SpaceService {
    private let userAccountRepository: UserAccountRepository
    private let spaceRepository: SpaceRepository

    init(
        _ userAccountRepository: UserAccountRepository = UserAccountRepositoryImpl(),
        _ spaceRepository: SpaceRepository = SpaceRepositoryImpl())
    {
        self.userAccountRepository = userAccountRepository
        self.spaceRepository = spaceRepository
    }

    func fetchSpaceList() -> Observable<SpaceModels.FetchSpaceList.Response> {
        spaceRepository.fetchSpaceList()
    }

    func fetchSpace(request: SpaceModels.FetchSpace.Request) -> Observable<SpaceModels.FetchSpace.Response> {
        spaceRepository.fetchSpace(spaceID: request.spaceID)
    }

    func createSpace(title: String) -> Observable<SpaceModels.CreateSpace.Response> {
        spaceRepository.createSpace(title: title)
    }

    func joinSpace(shareID: String) -> Single<SpaceModels.JoinSpace.Response> {
        spaceRepository.joinSpace(shareID: shareID)
    }
    
    func editSpaceName(id: Int, name: String) -> Observable<SpaceModels.EditSpaceTitle.Response> {
        spaceRepository.editSpaceName(id: id, name: name)
    }

    func leaveSpace(request: SpaceModels.LeaveSpace.Request) -> Observable<SpaceModels.Empty.Response> {
        if isAdminAndIsSpaceStatusOpen(request) {
            return spaceRepository.deleteSpace(spaceID: request.spaceID)
        } else {
            return spaceRepository.leaveSpace(spaceID: request.spaceID)
        }
    }

    func leaveSpaceInProgress(requeset: SpaceModels.LeaveSpaceInProgress.Request) -> Observable<SpaceModels.FetchSpaceList.Response> {
        spaceRepository.leaveSpace(spaceID: requeset.spaceID)
            .flatMap { _ in self.spaceRepository.fetchSpaceList() }
    }

    func startPaymentAlogrithm(request: SpaceModels.StartPaymentAlogrithm.Request) -> Observable<SpaceModels.Empty.Response> {
        spaceRepository.startPaymentAlgorithm(request: request)
    }

    // 방장이고 방의 상태가 OPEN 일 경우를 판단해준다. 
    private func isAdminAndIsSpaceStatusOpen(_ request: SpaceModels.LeaveSpace.Request) -> Bool {
        guard let userID = userAccountRepository.fetchLocalUserAccount()?.id else { return false }
        print("isAdminAndIsSpaceStatusOpen는? ", (request.isAdmin == userID) && (request.isStatusOpen))
        return (request.isAdmin == userID) && (request.isStatusOpen)
    }
}
