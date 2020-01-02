//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RxSwift
import RxCocoa
import Reachability

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
    
    // MARK: - 网络、空页面 相关配置    
    /// 监听网络状态改变
    lazy var reachability: Reachability? = try? Reachability()
    /// 是否正在加载
    let isLoading = BehaviorRelay(value: false)
    /// 当前连接的网络类型
    let reachabilityConnection = BehaviorRelay(value: Reachability.Connection.unavailable)
    /// 数据源 nil 时点击了 view
    let emptyDataSetViewTap = PublishSubject<Void>()
    /// 数据源 nil 时显示的标题，默认 " "
    var emptyDataSetTitle: String = ""
    /// 数据源 nil 时显示的描述，默认 " "
    var emptyDataSetDescription: String = ""
    /// 数据源 nil 时显示的图片
    var emptyDataSetImage = R.image.hg_defaultError()
    /// 没有网络时显示的图片
    var noConnectionImage = R.image.hg_defaultNo_connection()
    /// 没有网络时显示的标题
    var noConnectionTitle: String = R.string.localizable.netNoConnectionTitle()
    /// 没有网络时显示的描述
    var noConnectionDescription: String = R.string.localizable.netNoConnectionDesc()
    /// 数据源 nil 时是否可以滚动，默认 true
    var emptyDataSetShouldAllowScroll: Bool = true
    /// 没有网络时是否可以滚动， 默认 false
    var noConnectionShouldAllowScroll: Bool = false
    /// 垂直方向偏移量
    var verticalOffset: CGFloat = CGFloat.button

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

// MARK: - DZNEmptyDataSetSource
extension ViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {

        var title = ""
        switch reachabilityConnection.value {
        case .none, .unavailable:
            title = noConnectionTitle
        case .cellular:
            title = emptyDataSetTitle
        case .wifi:
            title = emptyDataSetTitle
        }
        return NSAttributedString(string: title)
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {

        var description = ""
        switch reachabilityConnection.value {
        case .none, .unavailable:
            description = noConnectionDescription
        case .cellular:
            description = emptyDataSetDescription
        case .wifi:
            description = emptyDataSetDescription
        }
        return NSAttributedString(string: description)
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {

        switch reachabilityConnection.value {
        case .none, .unavailable:
            return noConnectionImage
        case .cellular:
            return emptyDataSetImage
        case .wifi:
            return emptyDataSetImage
        }
    }

//    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
//        return emptyDataSetImageTintColor.value
//    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .clear
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -verticalOffset
    }
}

extension ViewController: DZNEmptyDataSetDelegate {

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !isLoading.value
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        emptyDataSetViewTap.onNext(())
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {

        switch reachabilityConnection.value {
        case .none, .unavailable:
            return noConnectionShouldAllowScroll
        case .cellular:
            return emptyDataSetShouldAllowScroll
        case .wifi:
            return emptyDataSetShouldAllowScroll
        }
    }
}
