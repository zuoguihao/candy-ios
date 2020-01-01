//
//  UIDevice+Ext.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit

extension UIDevice {
    /// 是否是 pad
    static let isPad: Bool = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
    ///  是否是iPhone
    static let isPhone: Bool = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone)
    /// 是否是 4.3 英寸手机
    static let isIPhone4: Bool = UIDevice.isPhone && UIScreen.height < 568
    /// 是否是 4.3 英寸手机
    static let isIPhone5: Bool = UIDevice.isPhone && UIScreen.height ~= 568
    /// 是否是 4.7 英寸手机
    static let isIPhone6: Bool = UIDevice.isPhone && UIScreen.height ~= 667
    /// 是否是 5.5 英寸手机
    static let isIPhone6P: Bool = UIDevice.isPhone && UIScreen.height ~= 736
    /// 是否是全面屏
    static var isFullScreen: Bool {
        var isIPhoneXSeries: Bool = false
        if #available(iOS 11.0, *), isPhone {
            if let window = UIApplication.shared.delegate?.window as? UIWindow,
                window.safeAreaInsets.bottom > CGFloat(0) {
                isIPhoneXSeries = true
            }
        }
        return isIPhoneXSeries
    }
    
    /// 设备名
    static var deviceName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
                   
        ///iphone
        case "iPhone1,1":                           return "iPhone 1G"
        case "iPhone1,2":                           return "iPhone 3G"
        case "iPhone2,1":                           return "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1":                           return "iPhone 4S"
        case "iPhone5,1", "iPhone5,2":              return "iPhone 5"
        case "iPhone5,3","iPhone5,4":               return "iPhone 5C"
        case "iPhone6,1", "iPhone6,2":              return "iPhone 5S"
        case "iPhone7,1":                           return "iPhone 6 Plus"
        case "iPhone7,2":                           return "iPhone 6"
        case "iPhone8,1":                           return "iPhone 6s"
        case "iPhone8,2":                           return "iPhone 6s Plus"
        case "iPhone8,4":                           return "iPhone SE"
        case "iPhone9,1","iPhone9,3":               return "iPhone 7"
        case "iPhone9,2","iPhone9,4":               return "iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":             return "iPhone 8"
        case "iPhone10,2","iPhone10,5":             return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":             return "iPhone X"
        case "iPhone11,8":                          return "iPhone XR"
        case "iPhone11,2":                          return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":            return "iPhone XS Max"
        case "iPhone12,1":                          return "iPhone 11"
        case "iPhone12,3":                          return "iPhone 11Pro"
        case "iPhone12,5":                          return "iPhone 11Pro Max"
            
        ///iPad
        case "iPad1,1":                             return "iPad"
        case "iPad1,2":                             return "iPad 3G"
        case "iPad2,1":                             return "iPad 2 (WiFi)"
        case "iPad2,2":                             return "iPad 2"
        case "iPad2,3":                             return "iPad 2 (CDMA)"
        case "iPad2,4":                             return "iPad 2"
        case "iPad2,5":                             return "iPad Mini (WiFi)"
        case "iPad2,6":                             return "iPad Mini"
        case "iPad2,7":                             return "iPad Mini (GSM+CDMA)"
        case "iPad3,1":                             return "iPad 3 (WiFi)"
        case "iPad3,2":                             return "iPad 3 (GSM+CDMA)"
        case "iPad3,3":                             return "iPad 3"
        case "iPad3,4":                             return "iPad 4 (WiFi)"
        case "iPad3,5":                             return "iPad 4"
        case "iPad3,6":                             return "iPad 4 (GSM+CDMA)"
        case "iPad4,1":                             return "iPad Air (WiFi)"
        case "iPad4,2":                             return "iPad Air (Cellular)"
        case "iPad4,4":                             return "iPad Mini 2 (WiFi)"
        case "iPad4,5":                             return "iPad Mini 2 (Cellular)"
        case "iPad4,6":                             return "iPad Mini 2"
        case "iPad4,7":                             return "iPad Mini 3"
        case "iPad4,8":                             return "iPad Mini 3"
        case "iPad4,9":                             return "iPad Mini 3"
        case "iPad5,1":                             return "iPad Mini 4 (WiFi)"
        case "iPad5,2":                             return "iPad Mini 4 (LTE)"
        case "iPad5,3":                             return "iPad Air 2"
        case "iPad5,4":                             return "iPad Air 2"
        case "iPad6,3":                             return "iPad Pro 9.7"
        case "iPad6,4":                             return "iPad Pro 9.7"
        case "iPad6,7":                             return "iPad Pro 12.9"
        case "iPad6,8":                             return "iPad Pro 12.9"
        case "iPad6,11":                            return "iPad 5 (WiFi)"
        case "iPad6,12":                            return "iPad 5 (Cellular)"
        case "iPad7,1":                             return "iPad Pro 12.9 inch 2nd gen (WiFi)"
        case "iPad7,2":                             return "iPad Pro 12.9 inch 2nd gen (Cellular)"
        case "iPad7,3":                             return "iPad Pro 10.5 inch (WiFi)"
        case "iPad7,4":                             return "iPad Pro 10.5 inch (Cellular)"
        case "iPad7,5","iPad7,6":                   return "iPad (6th generation)"
        case "iPad8,1","iPad8,2",
             "iPad8,3","iPad8,4":                   return "iPad Pro (11-inch)"
        case "iPad8,5","iPad8,6",
             "iPad8,7","iPad8,8":                   return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad11,1","iPad11,2":                 return "iPad mini 5"
        case "iPad11,3","iPad11,4":                 return "iPad Air 3"
            
        ///iPod touch
        case "iPod1,1":                             return "iPod Touch 1G"
        case "iPod2,1":                             return "iPod Touch 2G"
        case "iPod3,1":                             return "iPod Touch 3G"
        case "iPod4,1":                             return "iPod Touch 4G"
        case "iPod5,1":                             return "iPod Touch 5G"
        case "iPod7,1":                             return "iPod touch 6G"
        case "iPod9,1":                             return "iPod touch 7G"
            
        ///Apple Watch
        case "Watch1,1","Watch1,2":                 return "Apple Watch (1st generation)"
        case "Watch2,6","Watch2,7":                 return "Apple Watch Series 1"
        case "Watch2,3","Watch2,4":                 return "Apple Watch Series 2"
        case "Watch3,1","Watch3,2",
             "Watch3,3","Watch3,4":                 return "Apple Watch Series 3"
        case "Watch4,1","Watch4,2",
             "Watch4,3","Watch4,4":                 return "Apple Watch Series 4"
        case "Watch5,1","Watch5,2",
             "Watch5,3","Watch5,4":                 return "Apple Watch Series 5"
            
        ///AppleTV
        case "AppleTV2,1":                          return "Apple TV 2"
        case "AppleTV3,1":                          return "Apple TV 3"
        case "AppleTV3,2":                          return "Apple TV 3"
        case "AppleTV5,3":                          return "Apple TV 4"
        case "AppleTV6,2":                          return "Apple TV 4K"
            
        ///AirPods
        case "AirPods1,1":                          return "AirPods"
        case "AirPods2,1":                          return "AirPods 2"

        ///HomePod
        case "AudioAccessory1,1",
             "AudioAccessory1,2":                   return "HomePod"
            
        ///Simulator
        case "i386":                                return "iPhone"//"Simulator"
        case "x86_64":                              return "iPhone"//"Simulator"
            
        default:                                    return "iPhone"
        }
    }
}
