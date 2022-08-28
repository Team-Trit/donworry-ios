//
//  Bank.swift
//  Models
//
//  Created by Woody on 2022/08/07.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public enum Bank: String, CaseIterable, Codable, CustomStringConvertible {
    case bankGYEONGNAM  = "경남은행"
    case bankGWANGJU    = "광주은행"
    case bankKB         = "국민은행"
    case bankIBK        = "기업은행"
    case bankNH         = "농협은행"
    case bankDAEGU      = "대구은행"
    case bankBUSAN      = "부산은행"
    case bankSANLIM     = "산림조합중앙회"
    case bankSANUP      = "산업은행"
    case bankSAEMAEUL   = "새마을금고"
    case bankSUHYUP     = "수협은행"
    case bankSHINHAN    = "신한은행"
    case bankSINHYEOP   = "신협중앙회"
    case bankWOORI      = "우리은행"
    case bankEPOST      = "우체국"
    case bankJEOCHOOK   = "저축은행"
    case bankJEONBOOK   = "전북은행"
    case bankJEJU       = "제주은행"
    case bankKAKAO      = "카카오뱅크"
    case bankK          = "케이뱅크"
    case bankTOSS       = "토스뱅크"
    case bankHANA       = "하나은행"
    case bankCITI       = "한국씨티은행"
    case bankHANTOO     = "한국투자증권"
    case bankKBSEC      = "KB증권"
    case bankNONGTOO    = "NH투자증권"
    case bankSC         = "SC제일은행"
    
    public var description: String {
        switch self {
        case .bankGYEONGNAM: return "bankGYEONGNAM"
        case .bankGWANGJU: return "bankGWANGJU"
        case .bankKB: return "bankKB"
        case .bankIBK: return "bankIBK"
        case .bankNH: return "bankNH"
        case .bankDAEGU: return "bankDAEGU"
        case .bankBUSAN: return "bankBUSAN"
        case .bankSANLIM: return "bankSANLIM"
        case .bankSANUP: return "bankSANUP"
        case .bankSAEMAEUL: return "bankSAEMAEUL"
        case .bankSUHYUP: return "bankSUHYUP"
        case .bankSHINHAN: return "bankSHINHAN"
        case .bankSINHYEOP: return "bankSINHYEOP"
        case .bankWOORI: return "bankWOORI"
        case .bankEPOST: return "bankEPOST"
        case .bankJEOCHOOK: return "bankJEOCHOOK"
        case .bankJEONBOOK: return "bankJEONBOOK"
        case .bankJEJU: return "bankJEJU"
        case .bankKAKAO: return "bankKAKAO"
        case .bankK: return "bankK"
        case .bankTOSS: return "bankTOSS"
        case .bankHANA: return "bankHANA"
        case .bankCITI: return "bankCITI"
        case .bankHANTOO: return "bankHANTOO"
        case .bankKBSEC: return "bankKBSEC"
        case .bankNONGTOO: return "bankNONGTOO"
        case .bankSC: return "bankSC"
        }
    }
}
