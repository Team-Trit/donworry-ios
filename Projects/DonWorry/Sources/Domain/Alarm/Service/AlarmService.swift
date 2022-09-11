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

// 서버에 적혀있는 언어로해도됨(이해잘안되도 상관없음)
protocol AlarmRepository {
    func getAlarms() -> Observable<[Models.AlertMessageInfomations]>
    func removeAlarms() -> Observable<AlarmModels.Empty>
}

// 사람이 보면 딱 읽을수있게 보이면 좋다
protocol AlarmService {
    func getAlarms() -> Observable<[Models.AlertMessageInfomations]>
    func removeAlarms() -> Observable<AlarmModels.Empty>
}

final class AlarmServiceImpl: AlarmService {
    
    private let alarmRepository = AlarmRepositoryImpl()
    
    func getAlarms() -> Observable<[AlertMessageInfomations]> {
        alarmRepository.getAlarms()
    }
    
    func removeAlarms() -> Observable<AlarmModels.Empty> {
        alarmRepository.removeAlarms()
    }
    
    
}

enum AlarmModels {
    struct Empty {
    }
}


// 서버 -> 레포지토리 -> 서비스 -> 뷰모델 -> 뷰
