//
//  UIFont+Ext.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation

/// 项目常用字号
extension UIFont {
    
    static let system_11 = fontOfDP(ofSize: 11)
    static let system_12 = fontOfDP(ofSize: 12)
    static let system_13 = fontOfDP(ofSize: 13)
    static let system_14 = fontOfDP(ofSize: 14)
    static let system_15 = fontOfDP(ofSize: 15)
    static let system_16 = fontOfDP(ofSize: 16)
    static let system_17 = fontOfDP(ofSize: 17)
    static let system_18 = fontOfDP(ofSize: 18)
    static let system_19 = fontOfDP(ofSize: 19)
    
    static let largeTitle = UIFont.fontOfDP(ofSize: 19, weight: .semibold)
}

extension UIFont {
    
    /// 新方法，设置字体，单位：像素【兼容 iOS8.0~iOS8.2】
    ///
    /// - Parameters:
    ///   - fontSize: 字号
    ///   - weight: 字体 weight
    class func fontOfPX(ofSize fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let pt = (fontSize*0.5)
        
        return fontOfDP(ofSize: pt, weight: weight)
    }
    
    /// 新方法，设置字体，单位：点【兼容 iOS8.0~iOS8.2】
    ///
    /// - Parameters:
    ///   - fontSize: 字号
    ///   - weight: 字体 weight
    class func fontOfDP(ofSize fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        // 默认为 iPhone 6s、其它未知尺寸
        var size = fontSize
        
        if UIDevice.isIPhone4 || UIDevice.isIPhone5 {// iPhone 4s、iPhone 5
            size = size - 0.5
        } else if UIDevice.isIPhone6P || UIDevice.isFullScreen {// iPhone 6sp
            size = size + 0.5
        }
        if #available(iOS 8.2, *) {
            return systemFont(ofSize: size, weight: weight)
        } else {
            if weight == .regular {
                return systemFont(ofSize: size)
            } else {
                return boldSystemFont(ofSize: size)
            }
        }
    }
}

// MARK: All Fonts
extension UIFont {

    static func allSystemFontsNames() -> [String] {
        var fontsNames = [String]()
        let fontFamilies = UIFont.familyNames
        for fontFamily in fontFamilies {
            let fontsForFamily = UIFont.fontNames(forFamilyName: fontFamily)
            for fontName in fontsForFamily {
                fontsNames.append(fontName)
            }
        }
        return fontsNames
    }
}
