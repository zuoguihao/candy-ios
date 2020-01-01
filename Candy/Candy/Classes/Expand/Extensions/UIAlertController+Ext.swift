//
//  UIAlertController+Ext.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func show(title: String?,
                    message: String?,
                    preferredStyle: UIAlertController.Style = .alert,
                    cancelTitle: String? = "取消",
                    cancelHandler: ((UIAlertAction) -> Void)? = nil,
                    confirmTitle: String = "确定",
                    confirmHandler: ((UIAlertAction) -> Void)? = nil) {
        guard let vc = currentVC(), !vc.isKind(of: UIAlertController.classForCoder()) else { return }
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) ? .alert : preferredStyle)
        if let cancelHandler = cancelHandler {
            let action = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
            alertVC.addAction(action)
        } else {
            alertVC.addAction(UIAlertAction(title: "确定", style: .cancel, handler: cancelHandler))
        }
        if let confirmHandler = confirmHandler {
            let action = UIAlertAction(title: confirmTitle, style: .default, handler: confirmHandler)
            action.setValue(UIColor.App.master, forKey: "_titleTextColor")
            alertVC.addAction(action)
        }
        alertVC.pruneNegativeWidthConstraints()
        vc.present(alertVC, animated: true, completion: nil)
    }
    
    /// 解决 Apple 的 actionsheet 样式展示的控制台报错的 bug
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
