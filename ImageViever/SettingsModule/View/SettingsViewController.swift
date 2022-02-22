//
//  SettingsViewController.swift
//  ImageViever
//
//  Created by Denis Medvedev on 09/02/2022.
//  Copyright © 2022 Denis Medvedev. All rights reserved.
//

import UIKit
import Nuke

final class SettingsViewController: UIViewController {
    
    //MARK: properties
    
    var presenter: SettingsPresenterProtocol!
    
    var tableView = UITableView()
    
    enum Consts {
        enum NavigationBar {
            enum NavigationItem {
                static let title = "Settings"
            }
        }
        
        enum ClearCacheCell {
            static let text = "Clear cache"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        configurateTableView()
        configurateNavigationBar()
        configurateView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: viewDidLoad helpers

    private func setupSubviews() {
        self.view.addSubview(tableView)
    }
    
    private func configurateTableView() {
        //tableView.frame = self.view.frame
        tableView.backgroundColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(SettingsViewCell.self, forCellReuseIdentifier: String(describing: SettingsViewCell.self))
    }
    
    private func configurateNavigationBar() {
        navigationItem.title = Consts.NavigationBar.NavigationItem.title
    }
    
    private func configurateView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

//MARK: extension UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            presenter.clearCache()
            //FIXME: не эта тейблвью
            tableView.reloadData()
        default:
            break
        }
    }
}

//MARK: extension UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsViewCell.self), for: indexPath) as! SettingsViewCell
        
        cell.textLabel?.text = Consts.ClearCacheCell.text
        cell.detailTextLabel?.text = presenter.getCacheSize()
        
        return cell
    }
}

//MARK: extension SettingsViewProtocol

extension SettingsViewController: SettingsViewProtocol {
    
}
