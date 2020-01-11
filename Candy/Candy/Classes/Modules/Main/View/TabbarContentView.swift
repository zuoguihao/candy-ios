//
//  TabbarContentView.swift
//  YXJY
//
//  Created by 左得胜 on 2018/11/19.
//  Copyright © 2018 找油网. All rights reserved.
//

import UIKit
import ESTabBarController_swift

/// tabbar 颜色统一设置
struct TabBarColor {

    /// item 文字颜色
    static let text = UIColor.lightGray
    /// item 文字选中颜色
    static let highlightText = UIColor.App.master
    /// item icon 颜色
    static let icon = UIColor.lightGray
    /// item icon 选中颜色
    static let highlightIcon = UIColor.App.master
    /// item 底部背景颜色
    static let backdrop = UIColor.clear
    /// item 底部背景选中颜色
    static let highlightBackdrop = UIColor.clear
}

/// 常规 item 自定义，支持动画小红点、item 点击 scale 动画
class TabBarBasicContentView: ESTabBarItemContentView {

    // MARK: - View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        textColor = TabBarColor.text
        highlightTextColor = TabBarColor.highlightText

        iconColor = TabBarColor.icon
        highlightIconColor = TabBarColor.highlightIcon

        backdropColor = TabBarColor.backdrop
        highlightBackdropColor = TabBarColor.highlightBackdrop
    }

    @available(*, unavailable, message: "不能使用 nib 初始化!")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func selectAnimation(animated: Bool, completion: (() -> Void)?) {
        self.bounceAnimation()
        completion?()
    }

    override func reselectAnimation(animated: Bool, completion: (() -> Void)?) {
        self.bounceAnimation()
        completion?()
    }

    func bounceAnimation() {
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        scale.duration = KTime.duration * 2
        scale.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(scale, forKey: nil)
    }

    // MARK: - Action
    /********小红点动画**********/
    override func badgeChangedAnimation(animated: Bool, completion: (() -> Void)?) {
        super.badgeChangedAnimation(animated: animated, completion: nil)
        notificationAnimation()
    }

    func notificationAnimation() {
        // item icon 动画
        let imageAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        imageAnimation.values = [0.0, -8.0, 4.0, -4.0, 3.0, -2.0, 0.0]
        imageAnimation.duration = KTime.duration * 2
        imageAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(imageAnimation, forKey: nil)
        // badgeView 动画
        let bageAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bageAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bageAnimation.duration = KTime.duration * 2
        bageAnimation.calculationMode = CAAnimationCalculationMode.cubic
        self.badgeView.layer.add(bageAnimation, forKey: nil)
    }
}

/// 中间特大 item 自定义，支持 item 点击 scale 动画
class TabBarIrregularityContentView: ESTabBarItemContentView {

    // MARK: - View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.backgroundColor = TabBarColor.highlightIcon
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.init(white: 235 / 255.0, alpha: 1.0).cgColor
        imageView.layer.cornerRadius = 35
        insets = UIEdgeInsets.init(top: -32, left: 0, bottom: 0, right: 0)
        let transform = CGAffineTransform.identity
        imageView.transform = transform
        superview?.bringSubviewToFront(self)

        textColor = TabBarColor.text
        highlightTextColor = TabBarColor.highlightText

        iconColor = TabBarColor.icon
        highlightIconColor = TabBarColor.highlightIcon

        backdropColor = TabBarColor.backdrop
        highlightBackdropColor = TabBarColor.highlightBackdrop
    }

    @available(*, unavailable, message: "不能使用 nib 初始化!")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let p = CGPoint.init(x: point.x - imageView.frame.origin.x, y: point.y - imageView.frame.origin.y)
        return sqrt(pow(imageView.bounds.size.width / 2.0 - p.x, 2) + pow(imageView.bounds.size.height / 2.0 - p.y, 2)) < imageView.bounds.size.width / 2.0
    }

    override func updateLayout() {
        super.updateLayout()
        self.imageView.sizeToFit()
        self.imageView.center = CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
    }

    public override func selectAnimation(animated: Bool, completion: (() -> Void)?) {
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize(width: 2.0, height: 2.0)))
        view.layer.cornerRadius = 1.0
        view.layer.opacity = 0.5
        view.backgroundColor = UIColor.init(red: 10 / 255.0, green: 66 / 255.0, blue: 91 / 255.0, alpha: 1.0)
        self.addSubview(view)
        playMaskAnimation(animateView: view, target: self.imageView, completion: {
            [weak view] in
            view?.removeFromSuperview()
            completion?()
        })
    }

    public override func reselectAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }

    public override func deselectAnimation(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }

    public override func highlightAnimation(animated: Bool, completion: (() -> Void)?) {
        UIView.beginAnimations("small", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
        self.imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }

    public override func dehighlightAnimation(animated: Bool, completion: (() -> Void)?) {
        UIView.beginAnimations("big", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = CGAffineTransform.identity
        self.imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }

    private func playMaskAnimation(animateView view: UIView, target: UIView, completion: (() -> Void)?) {
        view.center = CGPoint.init(x: target.frame.origin.x + target.frame.size.width / 2.0, y: target.frame.origin.y + target.frame.size.height / 2.0)

        let scale = CABasicAnimation.init(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = 36.0
        scale.beginTime = CACurrentMediaTime()
        scale.duration = 0.3
        scale.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
        scale.isRemovedOnCompletion = true

        let alpha = CABasicAnimation.init(keyPath: "opacity")
        alpha.fromValue = 0.6
        alpha.toValue = 0.6
        alpha.beginTime = CACurrentMediaTime()
        alpha.duration = 0.25
        alpha.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
        alpha.isRemovedOnCompletion = true

        view.layer.add(scale, forKey: "scale")
        view.layer.add(alpha, forKey: "alpha")

        completion?()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion?()
        }
    }
}
