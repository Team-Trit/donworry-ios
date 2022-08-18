//
//  NetworkLoggin.swift
//  Networking
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import Moya

final class NetworkLogging: PluginType {

    func willSend(_ request: RequestType, target: TargetType) {
#if DEBUG
        guard let urlRequest = request.request else { return }
        print("👉👉👉👉👉 HTTP Request 👈👈👈👈👈")
        print("URL          : \(urlRequest.url?.absoluteString ?? "")")
        print("Header       : \(urlRequest.allHTTPHeaderFields ?? [:])")
        print("Body         : \(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? "")")
#endif
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
#if DEBUG
        switch result {
        case .success(let response):
            guard let urlResponse = response.response else { return }
            print("🌈🌈🌈🌈🌈 HTTP Response 🌈🌈🌈🌈🌈")
            print("URL          : \(urlResponse.url?.absoluteString ?? "")")
            print("StatusCode   : \(urlResponse.statusCode)")
            print("Body         : \(String(data: response.data , encoding: .utf8) ?? "")")
        case .failure(let error):
            print("☠️☠️☠️☠️☠️ HTTP Response ☠️☠️☠️☠️☠️")
            print("Error Message: \(error.localizedDescription)")
            print("URL       : \(error.response?.response?.url?.absoluteString ?? "")")
        }
#endif
    }
}
