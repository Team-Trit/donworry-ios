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

    public init() {}

    public func request<API>(_ api: API) -> Single<API.Response> where API : ServiceAPI {
        let endpoint = MultiTarget.target(api)
        return provider.rx.request(endpoint)
            .flatMap { response in
                do {
                    // statusCode 검사하기
                    try self.httpProcess(response: response)

                    return .just(try response.map(API.Response.self))
                } catch NetworkError.httpStatus(let statusCode) {
                    return .error(NetworkError.httpStatus(statusCode))
                }
            }
    }

    private func httpProcess(response: Response) throws {
        guard 200...299 ~= response.statusCode else {
            let statusCode = try parsingErrorCode(response: response)
            throw NetworkError.httpStatus(statusCode)
        }
    }

    private func parsingErrorCode(response: Response) throws -> Int {
        do {
            let response = try response.map(ErrorResponse.self)
            return response.status
        } catch {
            throw NetworkError.errorCodeMappingError
        }
    }

    private let provider = DonWorryProvider<MultiTarget>()
}
