//
//  WebController.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/2.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import UIKit
import WebKit

public enum WebType {
    case url(url: URL)
    case urlStr(urlStr: String)
    case body(body: String)
}

class WebController: ViewController {
    // MARK: - Property
    public var maskColor: UIColor = UIColor.App.master {
        didSet {
            view.setNeedsDisplay()
        }
    }

    private let type: WebType

    // MARK: - LifeCycle
    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    public init(type: WebType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable, message: "不能使用 nib 初始化!")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

//        addCloseBackItem()
        makeUI()
        loadURL()
        // 监听加载进度
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
//        webView.observe(\.estimatedProgress) { [unowned self] obj, change in
//            if self.progressView.progress != 1.0 {
//                self.progressView.setProgress(Float(change.newValue ?? 0), animated: true)
//            }
//        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var originY: CGFloat = UIApplication.shared.statusBarFrame.height
        if navigationController != nil {
            originY = UIApplication.shared.statusBarFrame.height + 44
        }
        webView.frame = view.bounds
        progressView.frame = CGRect(x: 0, y: originY, width: view.frame.width, height: 2)

        webView.scrollView.contentInset = UIEdgeInsets(top: originY, left: 0, bottom: 0, right: 0)
    }

    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }

    // MARK: - Action
    /// 设置进度条
    // swiftlint:disable:next block_based_kvo
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress), progressView.progress != 1.0 {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }

    // MARK: - Lazy
    /// webView
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())

        webView.allowsBackForwardNavigationGestures = true
        webView.sizeToFit()

        webView.navigationDelegate = self

        return webView
    }()
    /// 懒加载进度条
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = maskColor
        progressView.trackTintColor = UIColor.clear
//        progressView.progress = 0.01
        progressView.transform = CGAffineTransform.init(scaleX: 1.0, y: 2.0)

        return progressView
    }()
}

// MARK: - Private Method
private extension WebController {

    func makeUI() {
        view.backgroundColor = .white
        if #available(iOS 11, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        view.addSubview(webView)
        view.addSubview(progressView)
    }

    func loadURL() {
        switch type {
        case .urlStr(let urlStr):
            guard let url = URL(string: urlStr) else {
                debugPrint("Invalid URL address")
                return
            }
            log.debug("加载 URL :" + urlStr)
            webView.load(URLRequest(url: url))
        case .url(let url):
            log.debug("加载 URL :" + url.absoluteString)
            webView.load(URLRequest(url: url))
        case .body(let body):
            let htmlhead = "<html lang=\"zh-cn\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, nickName-scalable=no\"></meta><style>img{max-width: 100%; width:auto; height:auto;}</style></head><body>"
            let htmlEnd = "</body></html>"
            let content = htmlhead + body + htmlEnd

            webView.loadHTMLString(content, baseURL: nil)
        }
    }
}

// MARK: - WKUIDelegate, WKNavigationDelegate
extension WebController: WKUIDelegate, WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.progress = 0.0
        progressView.isHidden = false
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        progressView.progress = 1.0
        UIView.animate(withDuration: 0.5,
                       animations: {
            self.progressView.transform = CGAffineTransform(scaleX: 1.0, y: 1.5)
        }, completion: { _ in
            self.progressView.isHidden = true
        })
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        progressView.progress = 0.0
        progressView.isHidden = true
    }

    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        debugPrint("didCommit")
    }
}
