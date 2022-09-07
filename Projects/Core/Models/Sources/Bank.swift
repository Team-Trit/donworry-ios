//
//  Bank.swift
//  Models
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public enum Bank: String, CaseIterable, Codable {
    case bankGYEONGNAM
    case bankGWANGJU
    case bankKB
    case bankIBK
    case bankNH
    case bankDAEGU
    case bankBUSAN
    case bankSANLIM
    case bankSANUP
    case bankSAEMAEUL
    case bankSUHYUP
    case bankSHINHAN
    case bankSINHYEOP
    case bankWOORI
    case bankEPOST
    case bankJEOCHOOK
    case bankJEONBOOK
    case bankJEJU
    case bankKAKAO
    case bankK
    case bankTOSS
    case bankHANA
    case bankCITI
    case bankHANTOO
    case bankKBSEC
    case bankNONGTOO
    case bankSC
    
    public var koreanName: String {
        switch self {
        case .bankGYEONGNAM: return "경남은행"
        case .bankGWANGJU: return "광주은행"
        case .bankKB: return "국민은행"
        case .bankIBK: return "기업은행"
        case .bankNH: return "농협은행"
        case .bankDAEGU: return "대구은행"
        case .bankBUSAN: return "부산은행"
        case .bankSANLIM: return "산림조합중앙회"
        case .bankSANUP: return "산업은행"
        case .bankSAEMAEUL: return "새마을금고"
        case .bankSUHYUP: return "수협은행"
        case .bankSHINHAN: return "신한은행"
        case .bankSINHYEOP: return "신협중앙회"
        case .bankWOORI: return "우리은행"
        case .bankEPOST: return "우체국"
        case .bankJEOCHOOK: return "저축은행"
        case .bankJEONBOOK: return "전북은행"
        case .bankJEJU: return "제주은행"
        case .bankKAKAO: return "카카오뱅크"
        case .bankK: return "케이뱅크"
        case .bankTOSS: return "토스뱅크"
        case .bankHANA: return "하나은행"
        case .bankCITI: return "한국씨티은행"
        case .bankHANTOO: return "한국투자증권"
        case .bankKBSEC: return "KB증권"
        case .bankNONGTOO: return "NH투자증권"
        case .bankSC: return "SC제일은행"
        }
    }
}
