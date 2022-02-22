////
////  GalleryViewController.swift
////  ImageViever
////
////  Created by Denis Medvedev on 25/10/2021.
////  Copyright © 2021 Denis Medvedev. All rights reserved.
////
//
//import SnapKit
//import UIKit
//import Nuke
//
//final class GalleryViewController: UIViewController {
//
//    //MARK: properties
//
//    var presenter: GalleryPresenterProtocol!
//
//    //MARK: private properties
//    
//    var tabBar = UITabBar()
//
//    var tableView = UITableView()
//
//    enum Consts {
//        static var nukeOptions = ImageLoadingOptions(
//            placeholder: UIImage(systemName: "photoLight150x150"),
//            transition: .fadeIn(duration: 0.33),
//            failureImage: UIImage(systemName: "goforwardLight150x150"),
//            failureImageTransition: .fadeIn(duration: 0.33),
//            contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
//        )
//
//        static var nukeOptionsLightMode = ImageLoadingOptions(
//            placeholder: UIImage(named: "photoLight150x150"),
//            transition: .fadeIn(duration: 0.33),
//            failureImage: UIImage(named: "goforwardLight150x150"),
//            failureImageTransition: .fadeIn(duration: 0.33),
//            contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
//        )
//
//        static var nukeOptionsDarkMode = ImageLoadingOptions(
//            placeholder: UIImage(named: "photoDark150x150"),
//            transition: .fadeIn(duration: 0.33),
//            failureImage: UIImage(named: "goforwardDark150x150"),
//            failureImageTransition: .fadeIn(duration: 0.33),
//            contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
//        )
//
//        enum BackButton {
//            static let title = ""
//        }
//
//        enum NavigationItem {
//            static let title = "Gallery APP"
//        }
//
//        enum Alert {
//            static let title = "Error"
//            static let actionTitle = "OK"
//        }
//
//        enum TabBarItems {
//            static let photosTabBarItem = UITabBarItem(title: "Photos", image: UIImage(systemName: "photo.fill.on.rectangle.fill"), tag: 0)
//            static let likedTabBarItem = UITabBarItem(title: "Liked", image: UIImage(systemName: "heart.fill"), tag: 1)
//            static let settingsTabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
//        }
//    }
//
//    //MARK: lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupSubviews()
//        configurateNavigationBar()
//        configurateTabBar()
//        configurateTableView()
//        configurateView()
//        setupConstraints()
//        updateUserInterfaceStyle()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.view.layoutIfNeeded()
//        self.view.updateConstraintsIfNeeded()
//    }
//
//
//
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        updateUserInterfaceStyle()
//    }
//
//    //MARK: viewDidLoad helpers
//
//    private func setupSubviews() {
//        self.view.addSubview(tableView)
//        self.view.addSubview(tabBar)
//    }
//
//    private func configurateTableView() {
//        //tableView.frame = self.view.frame
//        tableView.backgroundColor = UIColor.clear
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        tableView.register(GalleryViewCell.self, forCellReuseIdentifier: String(describing: GalleryViewCell.self))
//    }
//
//    private func configurateNavigationBar() {
//        let backButton = UIBarButtonItem()
//        backButton.title = Consts.BackButton.title
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
//        navigationItem.title = Consts.NavigationItem.title
//    }
//
//    private func configurateTabBar() {
//        tabBar.delegate = self
//
//        tabBar.setItems([Consts.TabBarItems.photosTabBarItem, Consts.TabBarItems.likedTabBarItem, Consts.TabBarItems.settingsTabBarItem], animated: false)
//    }
//
//    private func configurateView() {
//        self.view.isMultipleTouchEnabled = false
//        view.backgroundColor = .systemBackground
//    }
//
//    private func setupConstraints() {
//        tableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        tabBar.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(self.view.snp.bottomMargin)
//        }
//    }
//
//    private func configureAppearenceNavigationBar() {
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        let barAppearance = UINavigationBarAppearance()
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.standardAppearance = barAppearance
//        navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
//    }
//
//    //MARK: private methods
//
//    private func updateUserInterfaceStyle() {
//        switch traitCollection.userInterfaceStyle {
//        case .light, .unspecified:
//            Consts.nukeOptions = Consts.nukeOptionsLightMode
//            print("light mode detected")
//        case .dark:
//            Consts.nukeOptions = Consts.nukeOptionsDarkMode
//            print("dark mode detected")
//        @unknown default:
//            print("unknown interface mode detected")
//        }
//    }
//
//    @objc func didTapOnImageButton(button: CustomButton) {
//        print(button.imgId)
//        presenter.tapOnTheImage(imageId: button.imgId)
//    }
//}
