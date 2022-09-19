//
//  AlarmService.swift
//  DonWorry
//
//  Created by uiskim on 2022/09/09.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift
import Models

protocol AlarmService {
    func getAlarms() -> Observable<AlarmModels.GetAlarms.Response>
    func clearAlarms() -> Observable<AlarmModels.Empty.Response>
    func pushPayments(request: AlarmModels.PushPayments.Request) -> Observable<AlarmModels.Empty.Response>
}

final class AlarmServiceImpl: AlarmService {

    private let alarmRepository = AlarmRepositoryImpl()

    func getAlarms() -> Observable<AlarmModels.GetAlarms.Response> {
        alarmRepository.getAlarms()
    }

    func clearAlarms() -> Observable<AlarmModels.Empty.Response> {
        alarmRepository.clearAlarms()
    }

    func pushPayments(request: AlarmModels.PushPayments.Request) -> Observable<AlarmModels.Empty.Response> {
        alarmRepository.pushPayments(request: request)
    }
}
