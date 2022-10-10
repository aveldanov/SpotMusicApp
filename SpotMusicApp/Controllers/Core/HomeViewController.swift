//
//  ViewController.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 9/12/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .orange
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings))

        fetchData()
    }

//    private func fetchData() {
//        APICaller.shared.getNewReleases { result in
//            switch result {
//            case .success(let model):
//                print("[HomeViewController] model", model)
//                break
//            case .failure(let error):
//                print("[HomeViewController] error", error.localizedDescription)
//                break
//            }
//        }
//    }


    private func fetchData() {
        APICaller.shared.getFeaturedPlaylists { result in
            switch result {
            case .success(let model):
                print("[HomeViewController] model", model)
                break
            case .failure(let error):
                print("[HomeViewController] error", error.localizedDescription)
                break
            }
        }
    }

    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

