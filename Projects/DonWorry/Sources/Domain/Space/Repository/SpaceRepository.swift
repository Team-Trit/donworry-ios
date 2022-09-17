//
//  SpaceRepository.swift
//  DonWorryTests
//
//  Created by Woody on 2022/08/31.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import DonWorryNetworking
import RxSwift

protocol SpaceRepository {
    func fetchSpaceList() -> Observable<SpaceModels.FetchSpaceList.Response>
    func createSpace(title: String) -> Observable<SpaceModels.CreateSpace.Response>
    func joinSpace(shareID: String) -> Single<SpaceModels.JoinSpace.Response>
    func editSpaceName(id: Int, name: String) -> Observable<SpaceModels.EditSpaceTitle.Response>
    func leaveSpace(spaceID: Int) -> Observable<SpaceModels.Empty.Response>
    func deleteSpace(spaceID: Int) -> Observable<SpaceModels.Empty.Response>
    func startPaymentAlgorithm(request: SpaceModels.StartPaymentAlogrithm.Request) -> Observable<SpaceModels.Empty.Response>
}

final class SpaceRepositoryImpl: SpaceRepository {
    private let network: NetworkServable

    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }

    func fetchSpaceList() -> Observable<SpaceModels.FetchSpaceList.Response> {
        network.request(GetSpaceListAPI())
            .compactMap { response in response.compactMap { [weak self] in self?.convert(from: $0) }}
            .asObservable()
    }

    func createSpace(title: String) -> Observable<SpaceModels.CreateSpace.Response> {
        network.request(PostSpaceAPI(request: .init(title: title)))
            .compactMap { response -> SpaceModels.CreateSpace.Response in
                    .init(id: response.id, adminID: response.adminID, status: response.status, title: response.title, shareID: response.shareID)
            }.asObservable()
    }

    func joinSpace(shareID: String) -> Single<SpaceModels.JoinSpace.Response> {
        network.request(PostSpaceJoinAPI(request: .init(shareId: shareID)))
            .compactMap { response -> SpaceModels.JoinSpace.Response in
                    .init(id: response.id, adminID: response.adminID, status: response.status, title: response.title, shareID: response.shareID)
            }.catch { [weak self] in
                return .error(self?.judgeJoinSpaceError($0) ?? .undefined)
            }.asObservable().asSingle()
    }

    func editSpaceName(id: Int, name: String) -> Observable<SpaceModels.EditSpaceTitle.Response> {
        network.request(PatchSpaceTitleAPI(request: .init(id: id, title: name)))
            .compactMap { response -> SpaceModels.EditSpaceTitle.Response in
                    .init(id: response.id, adminID: response.adminID, status: response.status, title: response.title, shareID: response.shareID)
            }.asObservable()
    }

    func leaveSpace(spaceID: Int) -> Observable<SpaceModels.Empty.Response> {
        network.request(DeleteSpaceLeaveAPI(spaceId: spaceID))
            .compactMap { _ in .init() }
            .catch { [weak self] in
                .error(self?.judgeLeaveAndDeleteSpaceError($0) ?? .undefined)
            }.asObservable()
    }

    func deleteSpace(spaceID: Int) -> Observable<SpaceModels.Empty.Response> {
        network.request(DeleteSpaceAPI(spaceId: spaceID))
            .compactMap { _ in .init() }
            .catch { [weak self] in
                .error(self?.judgeLeaveAndDeleteSpaceError($0) ?? .undefined)
            }.asObservable()
    }

    func startPaymentAlgorithm(request: SpaceModels.StartPaymentAlogrithm.Request) -> Observable<SpaceModels.Empty.Response> {
        network.request(PatchSpaceStatusAPI(request: .init(id: request.id, status: request.status.uppercase)))
            .compactMap { _ in .init() }.asObservable()
    }
    
    private func judgeLeaveAndDeleteSpaceError(_ error: Error) -> SpaceError {
        return .undefined
    }

    private func judgeJoinSpaceError(_ error: Error) -> SpaceError {
        guard let error = error as? NetworkError else { return .undefined }
        switch error {
        case .httpStatus(let status):
            if status == 400 { return .shareIDIsNotInvalid }
            else if status == 403 { return .alreadyJoined }
            else if status == 409 { return .alreadyStarted}
        default: break
        }
        return .undefined
    }

    private func convert(from dto: DTO.Space) -> SpaceModels.FetchSpaceList.Space {
        return .init(
            id: dto.id,
            adminID: dto.adminID,
            title: dto.title,
            status: dto.status,
            shareID: dto.shareID,
            isTaker: dto.isTaker,
            isAllPaymentCompleted: dto.isAllPaymentCompleted,
            payments: dto.payments.map { convert(from: $0) }
        )
    }
    private func convert(from dto: DTO.Space.Payment) -> SpaceModels.FetchSpaceList.SpacePayment {
        return .init(id: dto.id, amount: dto.amount, isCompleted: dto.isCompleted, user: convert(from: dto.user))
    }
    private func convert(from dto: DTO.Space.User) -> SpaceModels.FetchSpaceList.SpaceUser {
        return .init(id: dto.id, nickname: dto.nickname, imgURL: dto.imgURL)
    }
}
