//
//  NetworkService.swift
//  Networking
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxMoya

public protocol NetworkServable {
    func request<API>(_ api: API) -> Single<API.Response> where API : ServiceAPI
}

public final class NetworkService: NetworkServable {


    public func request<API>(_ api: API) -> Single<API.Response> where API : ServiceAPI {
        return self._request(api)
            .compactMap { $0.data }
            .asSingle()
    }

    private func _request<API>(_ api: API) -> Observable<DonwWorryResponse<API.Response>> where API : ServiceAPI {
        let endpoint = MultiTarget.target(api)
        return provider.rx.request(endpoint)
            .asObservable()
            .map(DonwWorryResponse<API.Response>.self)
            .map { response -> DonwWorryResponse<API.Response> in
                guard let statusCode = response.statusCode else { throw DonWorryNetworkError.unknown(-100, response.message) }
                guard statusCode == 500 else { throw DonWorryNetworkError.serverError }
                guard statusCode >= 400 && statusCode < 500 else { throw DonWorryNetworkError.denyAuthentication }
                guard statusCode < 400 else { throw DonWorryNetworkError.unknown(statusCode, response.message) }

                return response
            }
        
    }
    public init() {}

    private let provider = DonWorryProvider<MultiTarget>()
}

enum DonWorryNetworkError: Error {
    case hasNoAuthenticationToken
    case accessTokenInvalidate
    case denyAuthentication
    case serverError
    case unknown(_ code: Int, _ message: String?)
}
