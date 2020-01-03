//
//  DefaultKeys.swift
//  DataStorage
//
//  Created by 左聂荣 on 2019/12/10.
//  Copyright © 2019 左聂荣. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    /// 域名枚举
    var hostType: DefaultsKey<Int?> { return .init("hostType") }
    /// APP域名【兼容自定义域名功能】
    var hostAPP: DefaultsKey<String?> { return .init("hostAPP") }
    ///  APP 当前的语言
    var languageID: DefaultsKey<String> { return .init("languageID", defaultValue: "zh-cn") }
}
