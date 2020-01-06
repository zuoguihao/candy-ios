//
//  UserCenterViewModel.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/6.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation

struct UserCenterViewModel {

    struct Input {

    }

    struct Output {
    }
}

extension UserCenterViewModel: ViewModelable {

    func transform(input: UserCenterViewModel.Input) -> UserCenterViewModel.Output {

        let output = Output()
        return output
    }
}
