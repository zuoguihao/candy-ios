//
//  UITextField+Ext.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/9.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation

extension UITextField {

    convenience init(
        placeholder: String?,
        placeholderColor: UIColor? = nil,
        textColor: UIColor?, font: UIFont?,
        clearButtonMode: UITextField.ViewMode = .whileEditing,
        returnKeyType: UIReturnKeyType = .default
    ) {
        self.init()

        self.placeholder = placeholder
        if let placeholderColor = placeholderColor {
            setValue(placeholderColor, forKeyPath: "placeholderLabel.textColor")
        }
        self.textColor = textColor
        self.font = font
        self.clearButtonMode = clearButtonMode
        self.returnKeyType = returnKeyType
        enablesReturnKeyAutomatically = true
    }
}
