//
//  Helper.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit

/// 根据设计稿的像素值返回实际物理值【以4.7英寸宽(375.0, 667.0)为基准】
///
/// - Parameter value: 像素值
/// - Returns: 实际物理值
func kw(_ value: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.width / 375 * value
//    return CGFloat(Int(UIScreen.main.bounds.width / 375 * value))
}

// MARK: - 全局打电话
/// 全局打电话
///
/// - parameter phoneNumber: 要拨打的电话号码
func global_phone(with phoneNumber: String, isShowActionSheet: Bool = true) {
    // 方式一：
//    let webView = WKWebView()
//    // 判断用户是否登录，未登录，则拨打公司座机，登录，则拨打对应的交易员电话
//    webView.load(URLRequest(url: URL(string: "tel://\(phoneNumber)")!))
//    global_getTopViewController()?.view.addSubview(webView)
    // 方式二：
    if isShowActionSheet {
        UIAlertController.show(title: "拨打电话：", message: nil, preferredStyle: .actionSheet, cancelTitle: "取消", cancelHandler: nil, confirmTitle: phoneNumber) { _ in
            callPhone(phoneNumber: phoneNumber)
        }
    } else {
        callPhone(phoneNumber: phoneNumber)
    }
}

private func callPhone(phoneNumber: String) {
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(URL.init(string: "telprompt://\(phoneNumber)")!, options: [:], completionHandler: nil)
    } else {
        UIApplication.shared.openURL(URL(string: "tel://\(phoneNumber)")!)
    }
}

/// 判断是否是正式包
func global_isReleaseVersion() -> Bool {
//    return !Bundle.main.appBuildVersion.lowercased().contains("beta")
//    return kHost == .prod
    return false
}

public func global_goToAppStore(with urlStr: String) {
    if let url = URL(string: urlStr) {
        UIApplication.shared.open(url, options: [:]) { _ in
        }
    }
}

// MARK: - 全局展示警告框
