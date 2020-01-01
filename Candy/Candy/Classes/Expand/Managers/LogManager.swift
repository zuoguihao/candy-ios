//
//  LogManager.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation
import XCGLogger

let log: XCGLogger = {
    let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: true)
    
    log.levelDescriptions[.verbose] = "🗯"
    log.levelDescriptions[.debug] = "🔹"
    log.levelDescriptions[.info] = "ℹ️"
    log.levelDescriptions[.notice] = "✳️"
    log.levelDescriptions[.warning] = "⚠️"
    log.levelDescriptions[.error] = "‼️"
    log.levelDescriptions[.severe] = "💣"
    log.levelDescriptions[.alert] = "🛑"
    log.levelDescriptions[.emergency] = "🚨"
        
    // 【注意】这里使用了三方默认的 destination，无需再次添加 log 形式的 destination
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:MM"
    dateFormatter.locale = Locale.current
    log.dateFormatter = dateFormatter
            
    // 开始启用
    log.logAppDetails()
    
    #if DEBUG
        log.setup(level: .debug, showLogIdentifier: false, showFunctionName: true, showThreadName: false, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: nil, fileLevel: nil)
    #else
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let url = urls[urls.endIndex - 1]
        let logPath: URL = url.appendingPathComponent(Bundle.main.appName + "Log.txt")
        
        log.setup(level: .debug, showLogIdentifier: false, showFunctionName: true, showThreadName: false, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: logPath, fileLevel: .error)
    #endif
    
    return log
}()

public extension XCGLogger {
    
    /// 自定义打印=================
    func shortLine(_ file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let lineString = "======================================"
        print("\((file as NSString).pathComponents.last!):\(line) \(function): \(lineString)")
        #endif
    }

    /// 自定义打印+++++++++++++++++++
    func plusLine(_ file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let lineString = "+++++++++++++++++++++++++++++++++++++"
        print("\((file as NSString).pathComponents.last!):\(line) \(function): \(lineString)")
        #endif
    }
}
