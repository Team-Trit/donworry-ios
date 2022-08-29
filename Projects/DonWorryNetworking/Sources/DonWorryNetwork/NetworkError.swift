//
//  NetworkError.swift
//  DonWorryNetworking
//
//  Created by Woody on 2022/08/29.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case hasNoAuthenticationToken // 토큰 없이 요청한 경우
    case accessTokenInvalidate // 토큰이 만료된 경우
    case denyAuthentication // 토큰이 맞지 않는 경우
    case objectMapping // 일반 데이터 파싱에서 오류가 나는 경우
    case errorCodeMappingError // 에러 코드 파싱에서 오류가 나는 경우
    case httpStatus(Int) // statusCode가 200...299 밖에 나오는 경우
    case unknown(_ code: Int, _ message: String?)
}
