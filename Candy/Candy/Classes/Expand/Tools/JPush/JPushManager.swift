//
//  JPushManager.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation
import UserNotifications

class JPushManager: NSObject {
    /// 标记是否在前台已经计算了消息数量
    private var isMSGCalculated: Bool = false
    // MARK: LifeCycle
    static let shared = JPushManager()
    private override init() {}
    
    deinit {
        kNotiCenter.removeObserver(self)
    }
    
    // MARK: - Public Method
    /// 注册推送
    func register(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard UIDevice.deviceName != "Simulator" else { return }
        
        /// 注册远程通知
        let entity = JPUSHRegisterEntity()
        if #available(iOS 10, *) {
            entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
                NSInteger(UNAuthorizationOptions.sound.rawValue) |
                NSInteger(UNAuthorizationOptions.badge.rawValue)
        } else if #available(iOS 8, *) {
            entity.types = NSInteger(UIUserNotificationType.alert.rawValue) |
                NSInteger(UIUserNotificationType.sound.rawValue) |
                NSInteger(UIUserNotificationType.badge.rawValue)
        }
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        // 启动推送
        JPUSHService.setup(withOption: launchOptions, appKey: Configs.Keys.jpush, channel: global_isReleaseVersion() ? "App Store" : "beta", apsForProduction: true, advertisingIdentifier: Keychains.uuid)
        
        let noti = NotificationCenter.default
        noti.addObserver(self, selector: #selector(networkDidSetup(_:)), name: NSNotification.Name.jpfNetworkDidSetup, object: nil)
        noti.addObserver(self, selector: #selector(networkDidRegister(_:)), name: NSNotification.Name.jpfNetworkDidRegister, object: nil)
        noti.addObserver(self, selector: #selector(networkDidLogin(_:)), name: NSNotification.Name.jpfNetworkDidLogin, object: nil)
        noti.addObserver(self, selector: #selector(networkDidReceiveMessage(_:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        
        JPUSHService.setLogOFF()
        clearBadge()
    }
    
    /// 注册 token 标识
    func register(deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    /// 处理 iOS10 之前的推送
    func handlePushBeforeiOS10(_ application: UIApplication, userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        
        handlePush(isAPPActive: application.applicationState == .active, userInfo: userInfo, withCompletionHandler: nil)
    }
    
    /// 设置推送标识（tag、alias）
    func setupNotiAlias(isLogin: Bool) {
        /**
         - tags: 不能设置 nil 或者空集合（[NSSet set]），集合成员类型要求为 NSString 类型
         - alias: 不能设置 nil 或者空字符串 @""，每次调用设置有效的别名，覆盖之前的设置
         */
        let appVersion = global_isReleaseVersion() ? Bundle.main.appVersion : ("beta")
        let systemVersion = UIDevice.current.systemVersion
        let tags: Set<String> = [appVersion, systemVersion]
        let alias: String = "notLogin"
        
//        if isLogin {// 登录用户
//            alias = RAUserManager.shared.userAccount.user.userPhone
//        }
        
        // 上传推送地区
//        YXLocationTool.shared.requestLocation(isReGeocode: true) { (location, regeocode, error) in
//            if let regeocode = regeocode {// 如果有编码结果，更新编码结果
//                tags += [regeocode.province, regeocode.city, regeocode.citycode]
//            }
        
            JPUSHService.setTags(tags, completion: { (code, iTags, seq) in
                log.debug("极光回调：tags 绑定成功：\(iTags?.description ?? "")")
            }, seq: 1)
            JPUSHService.setAlias(alias, completion: { (code, iAlias, seq) in
                log.debug("极光回调：alias 绑定成功：\(iAlias?.description ?? "")")
            }, seq: 1)
//        }
    }
    
    // MARK: - Action
    /// 建立连接
    @objc private func networkDidSetup(_ notification: Notification) {
        log.debug("建立连接")
    }
    
    /// 注册成功
    @objc private func networkDidRegister(_ notification: Notification) {
        log.debug("注册成功过")
    }
    
    /// 登录成功，极光建议在此通知方法中设置别名等
    @objc private func networkDidLogin(_ notification: Notification) {
        // 移除所有展示的推送
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        } else {
            
        }
        
        // 更新推送 tag、alias
//        setupNotiAlias(isLogin: RAUserManager.shared.isUserLogin)
    }
    
    /// 收到极光专有的自定义消息（非APNS）
    @objc private func networkDidReceiveMessage(_ notification: Notification) {
        
    }
    
    /// 拨打客服
    @objc private func phone() {
//        global_phone(with: YXHomeMenuData.baseDataModel?.tel ?? kTitle.customerServicePhoneNumber, isShowActionSheet: false)
    }
    
}

// MARK: - Private Method
private extension JPushManager {
    /// 处理前台、后台、杀死状态下的推送内容
    func handlePush(isAPPActive: Bool, userInfo: [AnyHashable: Any], withCompletionHandler completionHandler: ((Int) -> Void)?) {
//        let push = getPushType(userInfo)
//        let rootVC = UIViewController.currentVC()
//        setupMessageCount(isAPPActive: isAPPActive, isAdd: true)
        
        // 根据推送类型进行跳转处理
        
    }
    
    /// 处理极光专有自定义推送内容
    func handleCustomPush(_ model: JPushModel) {
        
    }
    /*
    /// 获取推送类型【用于界面跳转】
    func getPushType(_ userInfo: [AnyHashable: Any]) -> YXJPushContentType {
        
    }
    */
    
    /// 设置推送触发方式
    func setupCompletion(completionHandler: ((Int) -> Void)?) {
        guard let completionHandler = completionHandler else { return }
        if #available(iOS 10.0, *) {
            completionHandler(NSInteger(UNAuthorizationOptions.alert.rawValue) |
                NSInteger(UNAuthorizationOptions.sound.rawValue))
        } else {
            completionHandler(NSInteger(UIUserNotificationType.sound.rawValue) |
                NSInteger(UIUserNotificationType.alert.rawValue))
        }
    }
    
    /// 清除角标
    func clearBadge() {
        JPUSHService.resetBadge()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    /// 跳转至指定页面
    func pushVC(rootVC: UIViewController?, vc: UIViewController) {
        rootVC?.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: 处理订单相关
    /// 加载订单详情数据，返回订单状态
    func getOrderStatus(orderNo: String, completion: @escaping ((_ orderStatus: OrderStatusEnum) -> Void)) {
        NetworkTool.ds_request(.orderDetail(orderNo: orderNo), isShowError: true, type: YXOrderDetailModel.self, atKeyPath: "res", isCache: false, progress: nil, success: { (model) in
            
            completion(model.orderStatus)
            
        }) { (error) in
            
        }
    }
    */
    // MARK: APP 内部的消息数量处理
    /// 处理消息数量
    func setupMessageCount(isAPPActive: Bool, isAdd: Bool) {
//        if !isMSGCalculated {
//            isAdd ? (Defaults[.newMessageCount] += 1) : (Defaults[.newMessageCount] -= 1)
//            kNotiCenter.post(name: .kNewMessageCount, object: nil)
//        }
    }
}

extension JPushManager {
    // TODO: - 暂时没时间看更新了什么~
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        
    }
}

// MARK: - JPUSHRegisterDelegate【iOS10专用】
@available(iOS 10.0, *)
extension JPushManager: JPUSHRegisterDelegate {
    // iOS 12 Support
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        if let trigger = notification?.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.classForCoder()) {//从通知界面直接进入应用
            
        } else {//从通知设置界面进入应用
            
        }
    }
    
    /// 新特性，前台收到推送后调用该方法
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        // Required
        if let trigger = notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.classForCoder()) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        isMSGCalculated = false
        handlePush(isAPPActive: true, userInfo: userInfo, withCompletionHandler: completionHandler)
        isMSGCalculated = true
    }
    
    /// 新特性，后台和杀死状态下点击推送后调用该方法
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        center.removeAllDeliveredNotifications()// 移除通知中心的所有展示的推送
//        center.removeDeliveredNotifications(withIdentifiers: [response.actionIdentifier])// 移除点击的推送，其它展示的不移除
        
        let userInfo = response.notification.request.content.userInfo
        // Required
        if let trigger = response.notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.classForCoder()) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        handlePush(isAPPActive: false, userInfo: userInfo, withCompletionHandler: nil)
        isMSGCalculated = false
        completionHandler()// 系统要求执行这个方法
    }
    
}
