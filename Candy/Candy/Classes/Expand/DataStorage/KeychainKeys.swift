//
//  KeychainKeys.swift
//  DataStorage
//
//  Created by 左聂荣 on 2019/12/10.
//  Copyright © 2019 左聂荣. All rights reserved.
//

import Foundation
import KeychainSwift

struct Keychains {
    
    static let bundleID = Bundle.main.appBundleID
    
    private init () {}
    
    private static let keychain = KeychainSwift()
    
    /// APP唯一标识。结合Keychain保证UUID的唯一性
    static var uuid: String {
        let key = bundleID + "uuid"
        if let uuid = keychain.get(key) {
            return uuid
        } else {
            let uuid = UUID().uuidString
            keychain.set(uuid, forKey: key)
            return uuid
        }
    }
}
