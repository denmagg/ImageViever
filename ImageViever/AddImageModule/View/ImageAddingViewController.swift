//
//  ImageAddingViewController.swift
//  ImageViever
//
//  Created by Denis Medvedev on 11/02/2022.
//  Copyright © 2022 Denis Medvedev. All rights reserved.
//

import UIKit

final class ImageAddingViewController: UIViewController {
    
    //MARK: properties
    
    var presenter: ImageAddingPresenterProtocol!
    
    //MARK: private properties
    
    private var tableView = UITableView()
    
    private enum Consts {
        enum NavigationBar {
            enum NavigationItem {
                static let title = "Add New Image"
                enum RightBarButtonItem {
                    static let title = "Save"
                }
            }
        }
        
        enum ByUrlCell {
            static let titleForHeader = "By URL:"
            static let placeholder = "Enter image URL"
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
    
    //MARK: viewDidLoad helpers
    
    private func setupSubviews() {
        self.view.addSubview(tableView)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    private func configurateTableView() {
        tableView.backgroundColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        
        tableView.register(ImageAddingViewCell.self, forCellReuseIdentifier: String(describing: ImageAddingViewCell.self))
    }
    
    private func configurateNavigationBar() {
        navigationItem.title = Consts.NavigationBar.NavigationItem.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Consts.NavigationBar.NavigationItem.RightBarButtonItem.title, style: .done, target: self, action: #selector(didTapSaveButton))
    }
    
    private func configurateView() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: Actions
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func didTapSaveButton() {
        print("Saving...")
    }
}

//MARK: extension UITableViewDelegate

extension ImageAddingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            break
        default:
            break
        }
    }
}

//MARK: extension UITableViewDataSource

extension ImageAddingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Consts.ByUrlCell.titleForHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageAddingViewCell.self), for: indexPath) as! ImageAddingViewCell
        switch indexPath.row {
        case 0:
            cell.textField.placeholder = Consts.ByUrlCell.placeholder
        default:
            break
        }
        return cell
    }
}

//MARK: extension ImageAddingViewProtocol

extension ImageAddingViewController: ImageAddingViewProtocol {
    
}
