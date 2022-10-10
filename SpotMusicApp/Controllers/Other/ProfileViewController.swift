//
//  ProfileViewController.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 9/12/22.
//

import SDWebImage
import UIKit

class ProfileViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private var models = [String]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.addSubview(tableView)
        fetchProfile()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }


    // MARK: - Helpers
    private func fetchProfile() {
        APICaller.shared.getUserProfile {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    print("[ProfileViewController] user profile", model)
                    self?.updateUI(with: model)
                case .failure(let error):
                    print("[ProfileViewController] Profile error: \(error.localizedDescription)")
                    self?.failedToGetProfile()
                }
            }
        }
    }

    private func updateUI(with model: UserProfile) {
        tableView.isHidden = false
        // configure table models

        models.append("Full name: \(model.display_name)")
        models.append("Email: \(model.email)")
        models.append("User ID: \(model.id)")
        models.append("Tier: \(model.product)")

        createTableHeader(with: model.images.first?.url)

        tableView.reloadData()
    }

    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }

    private func createTableHeader(with urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }

        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.width,
                                              height: view.width/1.5))
        let imageSize: CGFloat = headerView.height/2
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: imageSize,
                                                  height: imageSize))

        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize/2



        tableView.tableHeaderView = headerView
    }
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none

        return cell
    }



}
