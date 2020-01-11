//
//  LoginViewModel.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/10.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation
import Validator

typealias State = PublishRelay<UIState>

struct LoginViewModel {

    let disposeBag = DisposeBag()

    struct Input {
        let phone: Observable<String>
        let verifyCode: Observable<String>
        let verifyBtnTap: ControlEvent<Void>
        let loginBtnTap: ControlEvent<Void>
    }

    struct Output {
        let loginEnable: Driver<Bool>
    }
}

extension LoginViewModel: ViewModelable {

    func transform(input: LoginViewModel.Input) -> LoginViewModel.Output {

//        input.phone.map { $0.validate(rule: LoginValidate.phoneRule()) }.bind(to: BehaviorSubject<ValidationResult>.init(value: .valid)).disposed(by: disposeBag)

        let loginEnable = input.verifyLoginBtn()

        return Output(loginEnable: loginEnable)
    }
}

private extension LoginViewModel.Input {

    func verifyLoginBtn() -> Driver<Bool> {
        return Observable.combineLatest(phone.map { $0.isEmpty }, verifyCode.map { $0.isEmpty }) { !$0 && !$1 }
            .asDriver(onErrorJustReturn: false)
    }
}
