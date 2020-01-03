//
//  UserCenterController.swift
//  RxSwiftDemo
//
//  Created by 左聂荣 on 2020/1/1.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit

class UserCenterController: ViewController {
    // MARK: - Property
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
    
    // MARK: - Action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let testVC = TestController()
        navigationController?.pushViewController(testVC, animated: true)
    }
    
    // MARK: - Lazy
    
}

// MARK: - Private Method
private extension UserCenterController {
    
    func makeUI() {
        
    }
}
