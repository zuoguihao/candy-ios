//
//  RegisterController.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/7.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit

class RegisterController: ViewController {
    // MARK: - Property

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }

    // MARK: - Action

    // MARK: - Lazy

}

// MARK: - Private Method
private extension RegisterController {

    func makeUI() {
        navItemTitle = R.string.localizable.registerNavTitle()
    }
}
