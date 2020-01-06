//
//  ViewModelable.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/6.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation

protocol ViewModelable {

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
