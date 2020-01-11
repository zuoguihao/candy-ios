//
//  ValidatorError.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/12.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation
import Validator

struct ValidatorError: ValidationError {

    var message: String

    init(message: String) {
        self.message = message
    }
}
