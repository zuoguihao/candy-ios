//
//  Encodable+Ext.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/7.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation

extension Encodable {

    static var className: String {
        return String(describing: self)
    }
}

extension NSObject {

    static var className: String {
        return String(describing: self)
    }
}
