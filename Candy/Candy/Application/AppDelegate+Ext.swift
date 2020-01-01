//
//  AppDelegate+Ext.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation

extension AppDelegate {
    
    /// 配置APP启动流程
    func configAPPLaunch() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.App.bg
        window?.tintColor = UIColor.App.master
                
        window?.rootViewController = TabBarController()
        
        window?.makeKeyAndVisible()
    }
    
}

// MARK: - 推送相关
extension AppDelegate {
    /// 注册APNs成功并上报DeviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        log.debug("注册推送成功:\(deviceToken.count)***\(deviceToken)")
        JPushManager.shared.register(deviceToken: deviceToken)
    }
    
    /// 实现注册APNs失败接 (可选)
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.debug("注册通知失败:\(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Required, For systems with less than or equal to iOS 6
        log.debug(userInfo)
        
        JPushManager.shared.handlePushBeforeiOS10(application, userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Required, iOS 7 Support
        log.debug(userInfo)
        if #available(iOS 10.0, *) {// iOS10以上推送语音播报需要单独创建 pushExtension target并单独实现
            
        } else {// iOS10以下推送语音播报
            JPushManager.shared.handlePushBeforeiOS10(application, userInfo: userInfo)
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
}
