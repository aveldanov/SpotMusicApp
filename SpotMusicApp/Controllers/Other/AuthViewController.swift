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
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds

    }


    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }

        // Exchange the code from the url for access token
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code" })?.value else {
            print("[AuthViewController] ISSUE")
            return
        }
        webView.isHidden = true

        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            print("[AuthViewController] success code: ", code)
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
    }
}
