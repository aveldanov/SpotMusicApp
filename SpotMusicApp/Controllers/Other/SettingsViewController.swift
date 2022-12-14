//
//  SettingsViewController.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 9/12/22.
//

import UIKit

class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()


    private var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        configureModels()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds

    }

    // MARK: - Helpers

    private func configureModels() {
        sections.append(Section(title: "Profile", options: [Option(title: "View your profile", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))

        sections.append(Section(title: "Account", options: [Option(title: "Sign out", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
        })]))
    }


    private func viewProfile() {
        let vc = ProfileViewController()
        vc.title = "Profile"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)

    }

    private func signOutTapped() {
        //TODO: implement sign out
    }

}

// MARK: - tableView

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        //Call handler for cell
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }



}
