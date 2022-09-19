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

// 서버에 적혀있는 언어로해도됨(이해잘안되도 상관없음)
protocol AlarmRepository {
    func getAlarms() -> Observable<AlarmModels.GetAlarms.Response>
    func clearAlarms() -> Observable<AlarmModels.Empty.Response>
    func pushPayments(request: AlarmModels.PushPayments.Request) -> Observable<AlarmModels.Empty.Response>
}

final class AlarmRepositoryImpl: AlarmRepository {

    private let network: NetworkServable
    
    init(_ network: NetworkServable = NetworkService()) {
        self.network = network
    }
    
    func getAlarms() -> Observable<AlarmModels.GetAlarms.Response> {
        return network.request(GetAlarmsAPI())
            .compactMap { [weak self] response -> AlarmModels.GetAlarms.Response in
                response.compactMap { [weak self] in self?.convertToAlarm($0) }
            }.asObservable()
    }

    func clearAlarms() -> Observable<AlarmModels.Empty.Response> {
        network.request(ClearAlarmsAPI())
            .compactMap { _ in .init() }.asObservable()
    }

    func pushPayments(request: AlarmModels.PushPayments.Request) -> Observable<AlarmModels.Empty.Response> {
        network.request(PushPaymentAPI(request: createPushPayments(request: request)))
            .compactMap { _ in .init() }.asObservable()
    }

    private func createPushPayments(request:  AlarmModels.PushPayments.Request) -> PushPaymentAPI.Request {
        return .init(
            spaceID: request.spaceID,
            payments: request.payments.map {
                .init(
                    id: $0.id,
                    receiverID: $0.receiverID,
                    isCompleted: $0.isCompleted
                )
            }
        )
    }

    private func convertToAlarm(_ dto: DTO.GetAlarmsDTO) -> AlarmModels.GetAlarms.Alarm {
        return .init(
            id: dto.id,
            type: convertAlarmType(from: dto.createdDate),
            title: dto.title,
            message: dto.message,
            createdDate: dto.createdDate
        )

    }

    private func convertAlarmType(from alarmType: String) -> AlarmModels.GetAlarms.Alarm.AlarmType {
        if alarmType == "PAYMENT_START" {
            return .payment_start
        } else if alarmType == "PAYMENT_END" {
            return .payment_end
        } else if alarmType == "PAYMENT_PUSH" {
            return .paymnet_push
        } else if alarmType == "SYSTEM" {
            return .system
        }
        return .system
    }
}
