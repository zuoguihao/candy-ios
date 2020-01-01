//
//  UIViewController+Ext.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addBackItem() {
        let image = UIImage(named: "nav_back")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.pop))
    }

    func addEmptyBackItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
    }
    
    func addCloseBackItem() {
        let image = UIImage(named: "nav_close")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(pop))
    }

    func setTitleAttributes() {
        let attr = [
            NSAttributedString.Key.font: UIFont.fontOfDP(ofSize: 17, weight: .semibold)
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attr
        
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }

    func push(controller: UIViewController) {
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }

    func presentFull(_ controller: UIViewController, completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: completion)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 获取当前 APP 的栈顶控制器
    class func currentVC() -> UIViewController? {
        var rootViewController: UIViewController?
        for window in UIApplication.shared.windows where !window.isHidden {
            if let rootVC = window.rootViewController {
                rootViewController = rootVC
                break
            }
        }
        return getTopVC(of: rootViewController)
    }
    
    /// 移除栈中除本页面和根页面以外的其它所有控制器
    func removeControllersFromNav() {
        guard let navController = navigationController, navController.viewControllers.count > 1 else { return }
        
        // 从导航控制器的堆栈中连续移除多个维护的控制器，推荐用这种方法，注意数组越界的问题，因此从最大的开始遍历，逐级往最小的移除
        var tmpControllers = navController.viewControllers
        for i in (1 ..< (tmpControllers.count-1)).reversed() {
            tmpControllers.remove(at: i)
            navigationController?.viewControllers = tmpControllers
        }
    }
    
    /// 移除导航栈里 本页面和指定索引控制器之间的所有控制器
    func removeControllers(from firstIndex: Int) {
        guard let navController = navigationController, navController.viewControllers.count > 1 else { return }
        
        // 从导航控制器的堆栈中连续移除多个维护的控制器，推荐用这种方法，注意数组越界的问题，因此从最大的开始遍历，逐级往最小的移除
        var tmpControllers = navController.viewControllers
        for i in ((firstIndex + 1) ..< (tmpControllers.count-1)).reversed() {
            tmpControllers.remove(at: i)
            navigationController?.viewControllers = tmpControllers
        }
    }
    
    /// 移除导航栈里 本页面和指定控制器之间的所有控制器
    func removeControllersFromFirstIndex(of vc: UIViewController) {
        guard let navController = navigationController, navController.viewControllers.count > 1 else { return }
        
        // 从导航控制器的堆栈中连续移除多个维护的控制器，推荐用这种方法，注意数组越界的问题，因此从最大的开始遍历，逐级往最小的移除
        var tmpControllers = navController.viewControllers
        let firstIndex = tmpControllers.firstIndex(of: vc) ?? 0
        for i in ((firstIndex + 1) ..< (tmpControllers.count-1)).reversed() {
            tmpControllers.remove(at: i)
            navigationController?.viewControllers = tmpControllers
        }
    }
    
    /// 移除指定控制器
    func removeControllerFromNav(vc: UIViewController) {
        guard let navController = navigationController, navController.viewControllers.count > 1 else { return }
        
        var controllers = navController.viewControllers
        // 从导航控制器的堆栈中移除指定的控制器，推荐用这种方法
        for (i, controller) in (controllers.enumerated()).reversed() {
            // 移除除了本VC以外的其他VC
            if controller.isKind(of: vc.classForCoder), i != controllers.count - 1 {
                controllers.remove(at: i)
                navigationController?.viewControllers = controllers
            }
        }
    }
    
}

private extension UIViewController {
    /// Returns the top most view controller from given view controller's stack.
    class func getTopVC(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return getTopVC(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return getTopVC(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return getTopVC(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return getTopVC(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return getTopVC(of: childViewController)
            }
        }
        
        return viewController
    }
}
