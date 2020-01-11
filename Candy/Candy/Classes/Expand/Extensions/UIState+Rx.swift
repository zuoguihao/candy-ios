//
//  UIState+Rx.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/11.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import RxSwift

enum UIState {
    case idle
    case loading(String?)
    case success(String?)
    case failure(String?)

    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    var isFailure: Bool {
        switch self {
        case .failure:
            return true
        default:
            return false
        }
    }
}

enum LoadingType {
    case none
    case start(String?)
}

struct UIStateToken<E>: Disposable {

    private let _source: Observable<E>

    init(source: Observable<E>) {
        _source = source
    }

    func asObservable() -> Observable<E> {
        return _source
    }

    func dispose() {}
}

extension ObservableConvertibleType {

    func trackState(_ relay: PublishRelay<UIState>,
                    loading: LoadingType = .start(nil),
                    success: String? = nil,
                    failure: @escaping (Error) -> String? = { $0.message }) -> Observable<Element> {
        return Observable.using({ () -> UIStateToken<Element> in
            switch loading {
            case .none:
                break
            case .start(let message):
                relay.accept(.loading(message))
            }

            return UIStateToken(source: self.asObservable())
        }, observableFactory: {
            return $0.asObservable().do(onNext: { _ in
                relay.accept(.success(success))
            }, onError: {
                relay.accept(.failure(failure($0)))
            }, onCompleted: {
                relay.accept(.success(nil))
            })
        })
    }
}

extension Error {

    var message: String {
        return self.localizedDescription
    }
}
