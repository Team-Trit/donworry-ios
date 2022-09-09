//
//  GetAlarmsAPI.swift
//  DonWorryNetworking
//
//  Created by uiskim on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
//import Models

public struct GetAlarmsAPI: ServiceAPI {
    
    public typealias Response = [DTO.GetAlarmsDTO]
    
    // parameter가 없다(보내는게 없다) 없애야함, REST API 의 body부분
    // public var request: Request
    
    
    // from swagger
    public var path: String = "/alarms"
    
    public var method: Method { .get }
    
    public var task: Task {
        // 파라미터가 없을때
        .requestPlain
        
        // 파라미터가 있을때
        // .requestJSONEncodable(request)
    }
    
    // 그대로쓰면됨
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
    }
    
    // 서버쪽에서 외부에서 받아야하는 무언가(ex)카카오토큰)가 있는 경우는 변수로 만들어서 파라미터를 추가해줘야한다
    public init() {}
}

// request가 없으니까 필요없음
// request body를 quicktype에 넣어서 여기다가 넣어주면됨, public
// 파싱오류(api와 dto사이에서 오류)의 경우 옵셔널처리를 고려해보아야함

//extension GetAlarmsAPI {
//
//    public struct Request: Encodable {
//        public let cardIds: [Int]
//        public init(cardIds: [Int]) {
//            self.cardIds = cardIds
//        }
//    }
//}
