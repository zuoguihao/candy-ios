//
//  Bundle+Ext.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation

class EmptyClass {}

extension Bundle {
    /// 利用计算型属性动态获取命名空间
    var appNameSpace: String {
        return infoDictionary?["CFBundleExecutable"] as? String ?? ""
    }
    
    /// APP的bundleIdentifier
    var appBundleID: String {
        return bundleIdentifier ?? ""
    }
    
    /// app版本（给用户看）
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    /// app build版本（内部开发标识）
    var appBuildVersion: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    /// app名称
    var appName: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    /// 获取当前资源包
    static var current: Bundle? {
        let bundles = Bundle(for: EmptyClass.self).paths(forResourcesOfType: "bundle", inDirectory: nil)
        guard let currentBundle = bundles.first else {
            return nil
        }
        return Bundle(path: currentBundle)
    }
}
