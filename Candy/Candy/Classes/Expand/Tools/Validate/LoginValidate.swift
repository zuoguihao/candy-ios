//
//  LoginValidate.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/12.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation
import Validator

struct LoginInputLimit {
    static let phoneRange = Range(1...11)
}

struct LoginValidate {

    static func phoneRule() -> ValidationRuleLength {
        return ValidationRuleLength(min: LoginInputLimit.phoneRange.lowerBound, max: LoginInputLimit.phoneRange.upperBound - 1, error: ValidatorError(message: R.string.localizable.loginPhoneFieldPlaceholder()))
    }
}
