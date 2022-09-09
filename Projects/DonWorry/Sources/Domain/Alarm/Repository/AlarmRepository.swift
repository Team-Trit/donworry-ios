//
//  AlarmRepository.swift
//  DonWorry
//
//  Created by uiskim on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift
import Models
import DonWorryNetworking

final class AlarmRepositoryImpl: AlarmRepository {
    
    
    // 이건 그냥 가져와서 쓰면됨
    private let network: NetworkServable
    
    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }
    
    func getAlarms() -> Observable<[AlertMessageInfomations]> {
        let api = GetAlarmsAPI()
        
        return network.request(api)
            .compactMap { [weak self] in
                self?.convertToAlarm($0) as? [AlertMessageInfomations]
            }.asObservable()
    }
    
    private func convertToAlarm(_ dto: [DTO.GetAlarmsDTO]) -> [AlertMessageInfomations] {
        var array: [AlertMessageInfomations] = []
        dto.forEach { element in
            let item = AlertMessageInfomations(recievedDate: element.createdDate, senderName: element.title, spaceName: element.message, messageType: .hurriedAlert, isCompleted: element.isRead)
            array.append(item)
        }
        
        return array
    }
}


// parameter가 있는 이유 -> request의 body가 있어서
//func postUser(provider: String,
//              nickname: String,
//              email: String,
//              bank: String,
//              bankNumber: String,
//              bankHolder: String,
//              isAgreeMarketing: Bool,
//              accessToken: String) -> Observable<(Models.User, AuthenticationToken)> {
//    let api = PostUserAPI(request: createUserRequest(
//        provider: provider,
//        nickname: nickname,
//        email: email,
//        bank: bank,
//        bankNumber: bankNumber,
//        bankHolder: bankHolder,
//        isAgreeMarketing: isAgreeMarketing
//    ),accessToken: accessToken)
//
//    return network.request(api)
//        .compactMap { [ weak self] in
//            (self?.convertToUser($0), self?.convertToToken($0)) as? (Models.User, AuthenticationToken)
//        }.asObservable()
//}
