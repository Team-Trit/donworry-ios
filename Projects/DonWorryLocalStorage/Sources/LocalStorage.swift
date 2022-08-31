//
//  UserStorage.swift
//  DonWorry
//
//  Created by Woody on 2022/08/13.
//  Copyright © 2022 Tr-iT. All rights reserved.
//

import Foundation

public protocol LocalStorage {
    func readToken() -> String?
    func read<T>(key: UserDefaultsKey, type: T.Type) -> T?
    func write<T>(_ data: T, key: UserDefaultsKey) -> Void
    func remove(key: UserDefaultsKey) -> Void
    func writeCodable<T: Encodable>(_ object: T, key: UserDefaultsKey) -> Bool
    func readCodable<T: Decodable>(key: UserDefaultsKey, type: T.Type) -> T?
}

extension UserDefaults: LocalStorage {

    public func readToken() -> String? {
        UserDefaults.standard.string(forKey: UserDefaultsKey.accessToken.rawValue)
    }
    public func read<T>(key: UserDefaultsKey, type: T.Type) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
    public func write<T>(_ data: T, key: UserDefaultsKey) -> Void {
        UserDefaults.standard.setValue(data, forKey: key.rawValue)
    }
    public func remove(key: UserDefaultsKey) -> Void {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    public func writeCodable<T: Encodable>(_ object: T, key: UserDefaultsKey) -> Bool {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key.rawValue)
            return true
        } catch let error {
            print("Error encoding: \(error)")
            return false
        }
    }
    public func readCodable<T: Decodable>(key: UserDefaultsKey, type: T.Type) -> T? {
        do {
            guard let data = UserDefaults.standard.data(forKey: key.rawValue) else {
                return nil
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            print("Error decoding: \(error)")
            return nil
        }
    }
}
