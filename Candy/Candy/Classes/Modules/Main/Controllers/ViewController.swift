//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Navigation 相关设置
    /// 是否允许侧滑返回【注意使用系统的手势时，记得在 viewDidAppear 中禁用，在 viewWillDisappear 方法中开启,；hbd 不需要~】
    var navBarSwipeBackEnabled: Bool = true {
        didSet {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = navBarSwipeBackEnabled
//            hbd_swipeBackEnabled = navBarSwipeBackEnabled
        }
    }
    
    /// 是否隐藏导航栏
    var navBarHidden: Bool = false {
        didSet {
            navigation.bar.isHidden = navBarHidden
//            hbd_barHidden = navBarHidden
        }
    }
    
    var navBarAlpha: CGFloat = 1 {
        didSet {
            navigation.bar.alpha = navBarAlpha
//            navigationController?.navigationBar.alpha = navBarAlpha
        }
    }
    
    var navBarBarTintColor: UIColor? = UIColor.App.navSystem {
        didSet {
            navigation.bar.barTintColor = navBarBarTintColor
            navigation.bar.isTranslucent = true
        }
    }
    
    var navBarPrefersLargeTitles: Bool = false {
        didSet {
            if #available(iOS 11.0, *) {
                navigation.bar.prefersLargeTitles = navBarPrefersLargeTitles
                navigation.bar.largeTitleTextAttributes = [
                    .font: UIFont.fontOfDP(ofSize: 19, weight: .semibold)
                ]
            }
        }
    }
    
    /// 是否隐藏导航栏分割线
    var navBarShowHidden: Bool = false {
        didSet {
            navigation.bar.isShadowHidden = navBarShowHidden
//            hbd_barShadowHidden = navBarShowHidden
        }
    }
    
    var navItemTitle: String? {
        didSet {
            navigation.item.title = navItemTitle
//            title = navigationItem
        }
    }
            
    var navItemLeftBarButtonItem: UIBarButtonItem? {
        didSet {
            navigation.item.leftBarButtonItem = navItemLeftBarButtonItem
//            navigationItem.leftBarButtonItem = navItemLeftBarButtonItem
        }
    }
    
    var navItemLeftBarButtonItems: [UIBarButtonItem]? {
        didSet {
            navigation.item.leftBarButtonItems = navItemLeftBarButtonItems
//            navigationItem.leftBarButtonItems = navItemLeftBarButtonItems
        }
    }
    
    var navItemRightBarButtonItem: UIBarButtonItem? {
        didSet {
            navigation.item.rightBarButtonItem = navItemRightBarButtonItem
//            navigationItem.rightBarButtonItem = navItemRightBarButtonItem
        }
    }
    
    var navItemRightBarButtonItems: [UIBarButtonItem]? {
        didSet {
            navigation.item.rightBarButtonItems = navItemRightBarButtonItems
//            navigationItem.rightBarButtonItems = navItemRightBarButtonItems
        }
    }

    // MARK: - LifeCycle
    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    /// support Dark Mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                autoChangeBarMode()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        log.debug("进入页面：\(classForCoder)")
        
        modalPresentationStyle = .fullScreen
        autoChangeBarMode()
        
        view.backgroundColor = UIColor.random
    }
    
    // MARK: - Action
    /// 取消键盘响应
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Public Method
    // TODO: - ios13 新特性，DarkMode，暂时关闭
    func autoChangeBarMode() {
//        if #available(iOS 13.0, *) {
//            let isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
//            navigation.bar.barTintColor = isDarkMode ? UIColor(r: 28, g: 28, b: 28, alpha: 0.729) : UIColor.App.bg_FFFFFF
//            hbd_barTintColor = isDarkMode ? UIColor(r: 28, g: 28, b: 28, alpha: 0.729) : UIColor(r: 247, g: 247, b: 247, alpha: 0.8)
//        }
    }
    
}
