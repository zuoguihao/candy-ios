//
//  UIColor+Ext.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit

/// 项目常用到色值
public extension UIColor {

    struct App {
        /// 导航栏-系统
        static let navSystem: UIColor? = nil
        /// 导航栏-白色
        static let navWhite = UIColor.white.withAlphaComponent(0.98)
        /// 不可交互色
        static let disabled = UIColor(hexString: "d4d4d6")
        /// 分割线、轮播点
        static let line = UIColor(hexString: "#CCCCCC")
        static let lineActive = UIColor(r: 255, g: 85, b: 85)
        /// 遮罩层，有透明度
        static let mask = UIColor(hexString: "#2D3553").withAlphaComponent(0.13)
        /// 消息数量【红色】
        static let newMessage = UIColor(hexString: "#F5222D")

        /// 项目主色调
        static let master = UIColor(r: 255, g: 85, b: 85)

        /**************bg**************/
        static let bg = UIColor.groupTableViewBackground
        static let bg_FFFFFF = UIColor(hexString: "#FFFFFF")

        /**************Text**************/
        static let text_dark = UIColor.darkText
        static let text_EFEFEF = UIColor(hexString: "#EFEFEF")
        static let text_CE9728 = UIColor(hexString: "#CE9728")
        static let text_FFFFFF = UIColor(hexString: "#FFFFFF")

        /**************placeholder**************/
        static let placeholder = UIColor(hexString: "#9BA4B3")

        /**************Button**************/
        static let btn_disable = UIColor(hexString: "#E2E4E8")

        /**************Cell**************/
        static let cell_F2F4F7 = UIColor(hexString: "#F2F4F7")
    }
}

public extension UIColor {
    
    /// 扩展随机色
    class var random: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
    
    /// 扩展 rgba 颜色
    ///
    /// - Parameters:
    ///   - r: red（0~256）
    ///   - g: green（0 ~ 256）
    ///   - b: blue（0 ~ 256）
    ///   - alpha: 透明度
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 扩展十六进制颜色（格式：##cccccc、#cccccc、0Xcccccc、0xcccccc、cccccc）
    ///
    ///   - hexString: 十六进制颜色值
    convenience init(hexString: String) {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // 如果字符串是 0XFF0022
        if hex.hasPrefix("0X") || hex.hasPrefix("##") {
            hex = String(hex.suffix(hex.count - 2))
        } else if hex.hasPrefix("#") {// 如果字符串是以 # 开头
            hex = String(hex.suffix(hex.count - 1))
        }
        
        // 方法一：
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
            print(#file, #line, "色值错误，请检查~")
        }
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
}
