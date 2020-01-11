//
//  AppConfigs.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation

/// 标记打包时，如果本地没有存储host 的默认 host
//var kHost: HostType = HostType(rawValue: Defaults.hostType ?? HostType.dev.rawValue)!

struct Configs {

    struct URL {

    }

    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        static let Tmp = NSTemporaryDirectory()
    }

    /// 各种key
    struct Keys {
        /// iTunesconnect 上面的 APPID
        static let appID = ""
        /// Int 类型版本号标识
        static let versioncode: Decimal = Decimal(string: (Bundle.main.appVersion as NSString).replacingOccurrences(of: ".", with: "0")) ?? 0
        /// 极光推送正式版本
        static let jpush = ""
        /// 极光推送测试包
        static let jpushBeta = ""
        /// 友盟平台
        static let uMeng = ""
        /// Bugly
        static let bugly = ""
    }
}

extension UIScreen {
    /// 屏幕高度
    static let height: CGFloat = UIScreen.main.bounds.height
    /// 屏幕宽度
    static let width: CGFloat = UIScreen.main.bounds.width
}

/// 全局尺寸
extension CGFloat {
    /// 状态栏高度
    static let status: CGFloat = UIApplication.shared.statusBarFrame.height
    /// 导航栏+状态栏 高度
    static let navBar: CGFloat = 44 + .status
    /// 导航栏+状态栏 自动高度
    static var navBarAuto: CGFloat {
        var height: CGFloat = 44
        if #available(iOS 11.0, *),
            let nav = UIViewController.currentVC()?.navigationController,
            nav.navigationBar.prefersLargeTitles {
            height += 52
        }
        height += .status
        return height
    }
    /// TabBar 高度
    static let tabBar: CGFloat = 49 + safeArea.bottom
    /// 底部安全距离
    static var safeArea: UIEdgeInsets {
        if #available(iOS 11.0, *), let safeArea = UIApplication.shared.keyWindow?.safeAreaInsets {
            return safeArea
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    /// 文本距离边框内间距
    static let inset: CGFloat = 15
    /// 圆角值
    static let cornerRadius: CGFloat = 4
    static let borderWidth: CGFloat = 1
    /// 按钮高度
    static let button: CGFloat = 40
    /// textField 高度
    static let textField: CGFloat = 44
    /// tableView cell 高度
    static let tableRow: CGFloat = 45
    /// 分页器高度
    static let segmentedControl: CGFloat = 36
    /// 分割线高度
    static let line: CGFloat = 0.4

    static let d08: CGFloat = 8
    static let d10: CGFloat = 10
    static let d18: CGFloat = 18
    static let d25: CGFloat = 25
    static let d30: CGFloat = 30
    static let d32: CGFloat = 32
    static let d40: CGFloat = 40
    static let d60: CGFloat = 60
}

struct KTime {
    /// 0.1秒
    static let sec01: TimeInterval = 0.1
    /// 动画时长：0.25秒
    static let duration: TimeInterval = 0.25
    /// 1秒
    static let sec1: TimeInterval = 1
    /// 一天
    static let day1: TimeInterval = 60 * 60 * 24
    /// 延时1秒
    static let afterSec1 = DispatchTime.now() + .seconds(1)
    /// 延时0.25秒
    static let afterDuration = DispatchTime.now() + 0.25
}
