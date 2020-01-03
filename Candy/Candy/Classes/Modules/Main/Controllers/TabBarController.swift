//
//  TabBarController.swift
//  RxSwiftDemo
//
//  Created by 左聂荣 on 2019/12/31.
//  Copyright © 2019 左聂荣. All rights reserved.
//

import UIKit
import CleanJSON
import ESTabBarController_swift

class TabBarController: ESTabBarController {
    // MARK: - Property

    // MARK: - LifeCycle
    override var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVCs()
        setupTabBar()
    }

    // MARK: - Action

    // MARK: - Lazy

}

// MARK: - Private Method
private extension TabBarController {

    func addChildVCs() {

        guard let url = Bundle.main.url(forResource: "TabBarConfig.json", withExtension: nil),
            let jsonData = try? Data(contentsOf: url),
            let models = try? CleanJSONDecoder().decode([TabBarItemModel].self, from: jsonData) else {
            return
        }

        var vcs = [UIViewController]()
        for model in models {
            vcs.append(setupChildController(model))
        }
        viewControllers = vcs
    }

    func setupChildController(_ model: TabBarItemModel) -> UIViewController {
        guard let cls = NSClassFromString(Bundle.main.appNameSpace + "." + model.clsName) as? ViewController.Type else {
                return ViewController()
        }
        let vc = cls.init()

//        let itemView = isRegular ? TabBarBasicContentView() : TabBarIrregularityContentView()
        vc.tabBarItem = ESTabBarItem.init(TabBarBasicContentView(),
                                          title: model.title,
                                          image: UIImage.init(named: model.imageName),
                                          selectedImage: UIImage.init(named: model.imageName + "_selected"),
                                          tag: 0)

        vc.title = model.title
        return NavigationController(rootViewController: vc)
    }

    func setupTabBar() {
        if #available(iOS 13.0, *) {
            tabBar.tintColor = UIColor.App.master
            tabBar.unselectedItemTintColor = UIColor.App.text_667084
        } else {
            UITabBarItem.appearance().setTitleTextAttributes([
                .foregroundColor: UIColor.App.text_667084
            ], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([
                .foregroundColor: UIColor.App.master
            ], for: .selected)
        }
    }
}
