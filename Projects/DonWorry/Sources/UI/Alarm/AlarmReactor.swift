//
//  AlarmViewReactor.swift
//  App
//
//  Created by Woody on 2022/09/14.
//  Copyright (c) 2022 Tr-iT. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum AlarmStep {
    case pop
    case sendDetail
}

final class AlarmReactor: Reactor {
    typealias DateString = String
    typealias Response = AlarmModels.GetAlarms.Response
    typealias Alarms = [AlarmCellViewModel]

    enum Action {
        case viewDidLoad
        case didTapBackButton
        case didTapAlarmClearButton
        case didTapSendDetailButton
    }

    enum Mutation {
        case updateAlarmModels(Response)
        case routeTo(AlarmStep)
    }

    struct State {
        var alarmModels: [(DateString, [AlarmCellViewModel])]
        @Pulse var step: AlarmStep?
    }

    let initialState: State

    init(alarmService: AlarmService = AlarmServiceImpl()) {
        self.initialState = .init(alarmModels: [])
        self.alarmService = alarmService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return alarmService.getAlarms().map { .updateAlarmModels($0) }
        case .didTapBackButton:
            return .just(.routeTo(.pop))
        case .didTapAlarmClearButton:
            return alarmService.clearAlarms().map { _ in .updateAlarmModels([]) }
        case .didTapSendDetailButton:
            return .just(.routeTo(.sendDetail))

        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateAlarmModels(let response):
            newState.alarmModels = formatTo(alarmModels: response)
        case .routeTo(let step):
            newState.step = step
        }
        return newState
    }

    // MARK: Presenter

    private func formatTo(alarmModels: Response) -> [(DateString,[AlarmCellViewModel])] {
        guard alarmModels.isNotEmpty else { return [] }
        var array: [(DateString, [AlarmCellViewModel])] = []
        var cellModel: [AlarmCellViewModel] = []
        var currentDate: String = alarmModels[0].createdDate
        var index: Int = 1
        while index < alarmModels.count {
            let currentAlarmEntity = alarmModels[index]
            let currentAlarmModel = converAlarm(alarm: currentAlarmEntity)
            if currentAlarmEntity.createdDate == currentDate {
                cellModel.append(currentAlarmModel)
            } else {
                array.append((currentDate, cellModel))
                currentDate = alarmModels[index].createdDate
                cellModel = []
            }
            index += 1
        }
        return array
    }

    private func converAlarm(alarm: AlarmModels.GetAlarms.Alarm) -> AlarmCellViewModel {
        // MARK: 서버 수정 API 대응
        return .init(
            title: alarm.title,
            message: alarm.message,
            type: convertAlarmType(alarmType: alarm.type),
            spaceID: -1,
            paymentID: -1
        )
    }
    private func convertAlarmType(alarmType: AlarmModels.GetAlarms.Alarm.AlarmType) -> AlarmCellViewModel.AlarmType {
        switch alarmType {
        case .system:
            return .system
        case .paymnet_push:
            return .payment_push
        case .payment_end:
            return .payment_end
        case .payment_start:
            return .payment_start
        case .space:
            return .payment_start
        }
    }

    private let alarmService: AlarmService
}
