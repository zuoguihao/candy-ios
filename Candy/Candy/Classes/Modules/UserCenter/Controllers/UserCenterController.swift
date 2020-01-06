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
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        setupData()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let testVC = TestController()
        navigationController?.pushViewController(testVC, animated: true)
    }

    // MARK: - Lazy
    /// 懒加载：tableView
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(cellWithClass: UITableViewCell.self)
        tv.rowHeight = CGFloat.tableRow
        tv.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: CGFloat.leastNormalMagnitude)))

        return tv
    }()
    /// 懒加载：dataSource
    private lazy var dataSource: [(String, ViewController.Type)] = {
        [
            (R.string.localizable.userCenterDataSourceLogin(), LoginController.self),
            (R.string.localizable.userCenterDataSourceListEdit(), ListEditController.self),
            (R.string.localizable.userCenterDataSourceQuery(), QueryController.self)
        ]
    }()
}

// MARK: - Private Method
private extension UserCenterController {

    func makeUI() {
        navItemTitle = R.string.localizable.userCenterNavTitle()

        view.addSubview(tableView)

    }

    func setupData() {
        Driver.of(dataSource)
            .drive(tableView.rx.items(cellIdentifier: UITableViewCell.className)) { _, item, cell in
                cell.textLabel?.text = item.0
        }
        .disposed(by: rx.disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: rx.disposeBag)

        tableView.rx.modelSelected((String, ViewController.Type).self)
            .map { $0.1 }
            .bind(to: rx.push)
            .disposed(by: rx.disposeBag)
    }
}
