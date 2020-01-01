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
        static let disabled = UIColor.init(hexString: "d4d4d6")
        /// 分割线、轮播点
        static let line = UIColor.init(hexString: "#CCCCCC")
        /// 遮罩层，有透明度
        static let mask = UIColor(hexString: "#2D3553").withAlphaComponent(0.13)
        /// 警示红点
        static let warn = UIColor.init(hexString: "#f26333")
        /// 消息数量【红色】
        static let newsRed = UIColor(hexString: "#F5222D")
        
        /// 项目主色调
        static let master = UIColor(r: 255, g: 85, b: 85)
        /// APP 绿色
        static let green = UIColor(hexString: "1ABB97")
        
        /**************bg**************/
        static let bg = UIColor(hexString: "#FFFFFF")//UIColor.groupTableViewBackground
        static let bg_FFFFFF = UIColor(hexString: "#FFFFFF")
        static let bg_F2F4F7 = UIColor(hexString: "#F2F4F7")
        static let bg_2D3553 = UIColor(hexString: "#2D3553")
        static let bg_E2E4E8 = UIColor(hexString: "#E2E4E8")
        static let bg_2B3555 = UIColor(hexString: "#2B3555")
        static let bg_9BA4B3 = UIColor(hexString: "#9BA4B3")
        
        static let bg_424964 = UIColor(hexString: "#424964")
        static let bg_383F5C = UIColor(hexString: "#383F5C")
        static let bg_FFFCF7 = UIColor(hexString: "#FFFCF7")
        static let bg_F7F8FA = UIColor(hexString: "#F7F8FA")
        static let bg_667084 = UIColor(hexString: "#667084")
        static let bg_F2F2F2 = UIColor(hexString: "#F2F2F2")
        static let bg_FBEDED = UIColor(hexString: "#FBEDED")
        static let bg_809FD3 = UIColor(hexString: "#809FD3")
        static let bg_F9FAFC = UIColor(hexString: "#F9FAFC")
        static let bg_F6F6F9 = UIColor(hexString: "#F6F6F9")
        
        
        /**************Text**************/
        static let text_2D3553 = UIColor(hexString: "#2D3553")
        static let text_030303 = UIColor(hexString: "030303")
        static let text_30314D = UIColor(hexString: "#30314D")
        static let text_9BA4B3 = UIColor(hexString: "#9BA4B3")
        static let text_667084 = UIColor(hexString: "#667084")
        static let text_182F5C = UIColor(hexString: "#182F5C")
        static let text_626262 = UIColor(hexString: "#626262")
        static let text_1E1E1E = UIColor(hexString: "#1E1E1E")
        static let text_FFFFFF = UIColor(hexString: "#FFFFFF")
        static let text_809FD3 = UIColor(hexString: "#809FD3")
        static let text_E32C2C = UIColor(hexString: "#E32C2C")
        static let text_0D4FE3 = UIColor(hexString: "#0D4FE3")
        static let text_CDCDD0 = UIColor(hexString: "#CDCDD0")
        static let text_3B7CFF = UIColor(hexString: "#3B7CFF")
        static let text_383F5C = UIColor(hexString: "#383F5C")
        static let text_6E7D96 = UIColor(hexString: "#6E7D96")
       
        
        /**************placeholder**************/
        /// #9BA4B3
        static let placeholder = UIColor(hexString: "#9BA4B3")
        
        
        /**************Button**************/
//        static let btn = UIColor(hexString: "#424964")
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
