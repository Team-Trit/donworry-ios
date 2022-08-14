//
//  UserStorage.swift
//  DonWorry
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation
import RxSwift
import Models
import DonWorryExtensions

enum UserDefaultsKey: String {
    case token
    case user
}

protocol LocalStorage {
    func read<T>(key: UserDefaultsKey) -> Observable<T?>
    func write<T>(_ data: T, key: UserDefaultsKey) -> Observable<Void>
    func remove(key: UserDefaultsKey) -> Observable<Void>
    func writeCodable<T: Encodable>(_ object: T, key: UserDefaultsKey)
    func readCodable<T: Decodable>(key: UserDefaultsKey) -> Observable<T?>
}

extension UserDefaults: LocalStorage {

    func read<T>(key: UserDefaultsKey) -> Observable<T?> {
        let data = UserDefaults.standard.object(forKey: key.rawValue) as? T
        return .just(data)
    }
    func write<T>(_ data: T, key: UserDefaultsKey) -> Observable<Void> {
        UserDefaults.standard.setValue(data, forKey: key.rawValue)
        return .just(())
    }
    func remove(key: UserDefaultsKey) -> Observable<Void> {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        return .just(())
    }
    func writeCodable<T: Encodable>(_ object: T, key: UserDefaultsKey) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key.rawValue)
        } catch let error {
            print("Error encoding: \(error)")
        }
    }
    func readCodable<T: Decodable>(key: UserDefaultsKey) -> Observable<T?> {
        do {
            guard let data = UserDefaults.standard.data(forKey: key.rawValue) else {
                return .just(nil)
            }
            return .just(try JSONDecoder().decode(T.self, from: data))
        } catch let error {
            print("Error decoding: \(error)")
            return .just(nil)
        }
    }
}
