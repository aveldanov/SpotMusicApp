//
//  AuthViewController.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 9/12/22.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {

    private let webView: WKWebView = {
        let pref = WKWebpagePreferences()
        let config = WKWebViewConfiguration()
        pref.allowsContentJavaScript = true
        config.defaultWebpagePreferences = pref
        let webView = WKWebView(frame: .zero, configuration: config)

        return webView
    }()

    public var completionHandler: ((Bool)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds

    }
    

}
