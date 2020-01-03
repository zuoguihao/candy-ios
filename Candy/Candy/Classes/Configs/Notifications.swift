//
//  Notifications.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation

// MARK: - Notification
/// 全局快捷获取通知
public let kNotiCenter = NotificationCenter.default

public extension NSNotification.Name {

    /// 用户是否登录
    static let kIsUserLogin = Notification.Name("kIsUserLogin")

}
