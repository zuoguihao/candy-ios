//
//  LibsManager.swift
//  RxSwiftDemo
//
//  Created by 左聂荣 on 2019/12/31.
//  Copyright © 2019 左聂荣. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Kingfisher
import Toast_Swift
import Bugly
import XCGLogger

/// The manager class for configuring all libraries used in app.
class LibsManager: NSObject {
    
    // MARK: - Property
    static let shared = LibsManager()
    private override init() {
        
    }
    
    // MARK: - LifeCycle
    func setupLibs(with window: UIWindow? = nil) {

        let libsManager = LibsManager.shared
        libsManager.setupKeyboardManager()
        libsManager.setupActivityView()
        libsManager.setupToast()
        libsManager.setupBugly()
    }
}

private extension LibsManager {
    
    func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.registerTextFieldViewClass(YYTextView.self, didBeginEditingNotificationName: NSNotification.Name.YYTextViewTextDidBeginEditing.rawValue, didEndEditingNotificationName: NSNotification.Name.YYTextViewTextDidEndEditing.rawValue)
    }
    
    func setupActivityView() {
        
    }
    
    ///  Toast 设置
    func setupToast() {
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.position = .top
        var style = ToastStyle()
        style.backgroundColor = UIColor.red
        style.messageColor = UIColor.white
        style.imageSize = CGSize(width: 30, height: 30)
        ToastManager.shared.style = style
    }
    
    /// Bugly 设置
    func setupBugly() {
        Bugly.start(withAppId: Configs.Keys.bugly)
    }
    
}
