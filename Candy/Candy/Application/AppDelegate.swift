//
//  AppDelegate.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit
import XCGLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        LibsManager.shared.setupLibs(with: window)
        configAPPLaunch()

        return true
    }

}
