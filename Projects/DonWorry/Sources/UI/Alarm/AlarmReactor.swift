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
        let sortedAlarmModels = alarmModels.sorted { first, second in
            Formatter.fullDateFormatter.date(from: first.createdDate)! >= Formatter.fullDateFormatter.date(from: second.createdDate)!
        }
        let alarmModels: [AlarmCellViewModel] = convertToAlarmModelList(sortedAlarmModels)
        var result: [(DateString, [AlarmCellViewModel])] = []
        var tempAlarmModels: [AlarmCellViewModel] = []
        var currentDate: String = ""
        var index: Int = 0
        while index < alarmModels.count {
            let currentAlarmModel = alarmModels[index]
            if currentAlarmModel.date == currentDate {
                tempAlarmModels.append(currentAlarmModel)
            } else {
                if tempAlarmModels.isNotEmpty { result.append((currentDate, tempAlarmModels)) }
                tempAlarmModels = [currentAlarmModel]
                currentDate = currentAlarmModel.date
            }
            index += 1
        }
        result.append((currentDate, tempAlarmModels))
        return result
    }

    private func convertToAlarmModelList(_ alarmModels: Response) -> [AlarmCellViewModel] {
        return alarmModels.map { converAlarm(alarm: $0) }
    }

    private func converAlarm(alarm: AlarmModels.GetAlarms.Alarm) -> AlarmCellViewModel {
        // MARK: 서버 수정 API 대응
        return .init(
            title: alarm.title,
            message: alarm.message,
            type: convertAlarmType(alarmType: alarm.type),
            spaceID: Int(alarm.data?.spaceID ?? "-1") ?? -1,
            paymentID: Int(alarm.data?.paymentID ?? "-1") ?? -1,
            date: convertDateType(alarm.createdDate),
            imgURL: alarm.data?.senderImgURL ?? ""
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

    private func convertDateType(_ date: String) -> String {
        let currentDate = Formatter.fullDateFormatter.date(from: date) ?? Date()
        return Formatter.alarmDateFormatter.string(from: currentDate)
    }

    private let alarmService: AlarmService
}
