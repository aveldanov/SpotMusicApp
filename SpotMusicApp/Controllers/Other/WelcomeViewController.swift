//
//  WelcomeViewController.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 9/12/22.
//

import UIKit

class WelcomeViewController: UIViewController {


    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .cyan
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)

        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "SpotMusic"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        signInButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom ,
                                    width: view.width-40,
                                    height: 50)
    }

    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = {[weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    private func handleSignIn(success: Bool) {
        // login user or yell for error
        guard success else {
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let mainAppTabVC = TabBarViewController()
        mainAppTabVC.modalPresentationStyle = .fullScreen
        present(mainAppTabVC, animated: true, completion: nil)
    }

}
