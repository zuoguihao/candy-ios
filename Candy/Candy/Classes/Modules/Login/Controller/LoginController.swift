//
//  LoginController.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/7.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit
import RxGesture

class LoginController: ViewController {

    // MARK: - Property
    lazy var viewModel = LoginViewModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        makeUI()
        bindViewModel()
    }

    // MARK: - Action
    @objc private func registerItemClick() {
        let registerVC = RegisterController()
        self.navigationController?.pushViewController(registerVC)
    }

    // MARK: - Lazy
    /// 懒加载： 用户名
    private lazy var phoneField: EffectTextField = {
        let field = EffectTextField(placeholder: R.string.localizable.loginPhoneFieldPlaceholder(), textColor: nil, font: UIFont.system_16)
        field.keyboardType = .numberPad
        field.inactiveColor = UIColor.App.line
        field.activeColor = UIColor.App.lineActive
        return field
    }()
    /// 懒加载： 验证码
    private lazy var verifyCodeField: EffectTextField = {
        let field = EffectTextField(placeholder: R.string.localizable.loginVerifyCodeFieldPlaceholder(), textColor: nil, font: UIFont.system_16, clearButtonMode: .whileEditing, returnKeyType: .go)
        field.keyboardType = .numberPad
        field.inactiveColor = UIColor.App.line
        field.activeColor = UIColor.App.lineActive
        return field
    }()
    /// 懒加载：获取验证码
    private lazy var verifyCodeBtn: UIButton = {
        let btn = UIButton(type: .system, title: R.string.localizable.loginVerifyCodeBtnTitle(), image: nil, normalTitleColor: UIColor.App.text_FFFFFF, highlightedTitleColor: nil, normalBGColor: UIColor.App.master, highlightedBGColor: nil, font: UIFont.system_16)
        btn.setBackgroundImage(UIImage(color: UIColor.App.btn_disable), for: .disabled)
        btn.layer.cornerRadius = CGFloat.cornerRadius
        btn.layer.masksToBounds = true
        return btn
    }()
    /// 懒加载：登录按钮
    private lazy var loginBtn: UIButton = {
        let btn = UIButton(type: .system, title: R.string.localizable.loginNavTitle(), image: nil, normalTitleColor: UIColor.App.text_FFFFFF, highlightedTitleColor: nil, normalBGColor: UIColor.App.master, highlightedBGColor: nil, font: UIFont.system_16)
        btn.setBackgroundImage(UIImage(color: UIColor.App.btn_disable), for: .disabled)
        btn.layer.cornerRadius = CGFloat.cornerRadius
        btn.layer.masksToBounds = true
        return btn
    }()
}

// MARK: - Private Method
private extension LoginController {

    func setupNavigation() {
        navItemTitle = R.string.localizable.loginNavTitle()
        navItemRightBarButtonItem = UIBarButtonItem(title: R.string.localizable.registerNavTitle(), style: .plain, target: self, action: #selector(registerItemClick))
    }

    func makeUI() {
        view.addSubview(phoneField)
        view.addSubview(verifyCodeField)
        view.addSubview(verifyCodeBtn)
        view.addSubview(loginBtn)

        phoneField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(131)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(CGFloat.d30)
            make.height.equalTo(CGFloat.textField)
        }
        verifyCodeField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneField.snp.bottom).offset(CGFloat.d10)
            make.left.height.equalTo(phoneField)
            make.right.equalTo(verifyCodeBtn.snp.left).offset(-CGFloat.d08)
        }
        verifyCodeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(verifyCodeField)
            make.right.equalToSuperview().inset(CGFloat.d30)
            make.size.equalTo(CGSize(width: 120, height: 35))
        }
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(verifyCodeField.snp.bottom).offset(CGFloat.d30)
            make.left.right.equalToSuperview().inset(CGFloat.d30)
            make.height.equalTo(CGFloat.button)
        }
    }

    func bindViewModel() {
        let phone = phoneField.rx.text.orEmpty.share()
        let verifyCode = verifyCodeField.rx.text.orEmpty.share()

        phone.map { $0[0..<11] }
            .bind(to: phoneField.rx.text)
            .disposed(by: disposeBag)

        verifyCode.map { $0[0..<6] }
            .bind(to: verifyCodeField.rx.text)
            .disposed(by: disposeBag)

        let input = LoginViewModel.Input(
            phone: phone,
            verifyCode: verifyCode,
            verifyBtnTap: verifyCodeBtn.rx.tap,
            loginBtnTap: loginBtn.rx.tap)
        let output = viewModel.transform(input: input)

        output.loginEnable
            .drive(loginBtn.rx.isEnabled)
        .disposed(by: disposeBag)

        view.rx
            .swipeGesture(.left)
            .when(.recognized)
            .subscribe(onNext: { [weak self] (gesture) in
                guard let `self` = self else { return }
                self.registerItemClick()
            })
            .disposed(by: disposeBag)
    }
}
