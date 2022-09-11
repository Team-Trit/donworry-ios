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
            let item = AlertMessageInfomations(recievedDate: element.createdDate, senderName: element.title, spaceName: element.message, messageType: changeType(from: element.type))
            array.append(item)
        }
        return array
    }
    
    private func changeType(from serverType: String) -> AlertType {
        if serverType == "PAYMENT_START" {
            return .startAlert
        } else if serverType == "PAYMENT_END" {
            return .completedAlert
        } else if serverType == "PAYMENT_PUSH" {
            return .hurriedAlert
        }
        return .hurriedAlert
    }
    
    func removeAlarms() -> Observable<AlarmModels.Empty> {
        let api = RemoveAlarmsAPI()
        return network.request(api)
            .compactMap { [weak self] in
                self?.convertToRemoveAlarm($0) as? AlarmModels.Empty
            }.asObservable()
    }
    
    private func convertToRemoveAlarm(_ dto: DTO.Empty) -> AlarmModels.Empty {
        return AlarmModels.Empty()
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
