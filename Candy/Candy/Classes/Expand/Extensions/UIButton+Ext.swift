//
//  UIButton+Ext.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/10.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit

extension UIButton {

    /// 便利构造器，默认值的可以删除不写
    convenience init(
        frame: CGRect,
        title: String?,
        bgColor: UIColor?,
        normalTitleColor: UIColor?,
        highlightedTitleColor: UIColor? = UIColor.lightText,
        target: Any?,
        action: Selector
    ) {
        // 实例化对象
        self.init(frame: frame)
        // 访问属性
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        setTitleColor(normalTitleColor, for: .normal)
        setTitleColor(highlightedTitleColor, for: .highlighted)
        addTarget(self, action: action, for: .touchUpInside)
    }

    /// 便利构造器
    ///
    /// - Parameters:
    ///   - type: btn类型
    ///   - title: 文字
    ///   - normalTitleColor: 常规文字颜色
    ///   - highlightedTitleColor: 高亮文字颜色
    ///   - normalBGColor: 常规背景颜色
    ///   - disableBGColor: 不可点击背景色
    ///   - font: 字号
    convenience init(
        type: UIButton.ButtonType = UIButton.ButtonType.system,
        title: String?,
        image: UIImage?,
        normalTitleColor: UIColor? = nil,
        highlightedTitleColor: UIColor? = nil,
        normalBGColor: UIColor? = nil,
        highlightedBGColor: UIColor? = nil,
        font: UIFont = UIFont.system_17
    ) {
        // 实例化对象
        self.init(type: type)
        // 访问属性
        setTitle(title, for: UIControl.State.normal)
        setTitleColor(normalTitleColor, for: .normal)
        setTitleColor(highlightedTitleColor, for: .highlighted)
        titleLabel?.font = font
        setImage(image, for: .normal)

        if let normalBGColor = normalBGColor {
            setBackgroundImage(UIImage(color: normalBGColor), for: .normal)
        }
        if let highlightedBGColor = highlightedBGColor {
            setBackgroundImage(UIImage(color: highlightedBGColor), for: .highlighted)
        }
    }

    /// 按钮设置圆角和阴影【另一种方法就是直接在 btn 的父视图上添加一个 layer，在 layer 上设置阴影，layer 的 frame 和 btn 保持一致即可】
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角切割半径
    ///   - shadowColor: 阴影颜色
    ///   - shadowRadius: 阴影的扩散范围，相当于blur radius，也是shadow的渐变距离，从外围开始，往里渐变shadowRadius距离
    ///   - shadowOffset: 阴影的大小，x往右和y往下是正
    ///   - shadowOpacity: 阴影的不透明度
    func setupShadow(
        cornerRadius: CGFloat = 0,
        shadowColor: UIColor,
        shadowRadius: CGFloat = 3.0,
        shadowOffset: CGSize = CGSize(width: 0.0, height: -3.0),
        shadowOpacity: Float = 0
    ) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.masksToBounds = false
    }
}
