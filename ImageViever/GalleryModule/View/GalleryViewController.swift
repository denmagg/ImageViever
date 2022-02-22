//
//  GalleryViewController.swift
//  ImageViever
//
//  Created by Denis Medvedev on 25/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import SnapKit
import UIKit
import Nuke

final class GalleryViewController: UIViewController {

    //MARK: properties

    var presenter: GalleryPresenterProtocol!
    var tableView = UITableView()
    var noPhotosLabel = UILabel()
    
    enum Consts {
        static var nukeOptions = ImageLoadingOptions(
            placeholder: UIImage(systemName: "photoLight150x150"),
            transition: .fadeIn(duration: 0.33),
            failureImage: UIImage(systemName: "goforwardLight150x150"),
            failureImageTransition: .fadeIn(duration: 0.33),
            contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
        )

        static var nukeOptionsLightMode = ImageLoadingOptions(
            placeholder: UIImage(named: "photoLight150x150"),
            transition: .fadeIn(duration: 0.33),
            failureImage: UIImage(named: "goforwardLight150x150"),
            failureImageTransition: .fadeIn(duration: 0.33),
            contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
        )

        static var nukeOptionsDarkMode = ImageLoadingOptions(
            placeholder: UIImage(named: "photoDark150x150"),
            transition: .fadeIn(duration: 0.33),
            failureImage: UIImage(named: "goforwardDark150x150"),
            failureImageTransition: .fadeIn(duration: 0.33),
            contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
        )

        enum BackButton {
            static let title = ""
        }

        enum NavigationItem {
            static let title = "Photos"
        }

        enum Alert {
            static let title = "Error"
            static let actionTitle = "OK"
        }
        
        enum NoPhotosLabel {
            static let text = "No Photos"
            static let font = UIFont(name: "HelveticaNeue-Bold", size: 21)
            static let color = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        }
        
        enum AddPhotoButton {
            static let image = UIImage(systemName: "plus")
        }
    }
    
    //MARK: private properties
    
    private var addPhotoButton = UIBarButtonItem()
    
    //MARK: lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        configurateAddPhotoButton()
        configurateNavigationBar()
        configurateTableView()
        coonfigurateNoPhotosLabel()
        configurateView()
        setupConstraints()
        updateUserInterfaceStyle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        self.view.layoutIfNeeded()
//        self.view.updateConstraintsIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }



    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateUserInterfaceStyle()
    }

    //MARK: viewDidLoad helpers

    private func setupSubviews() {
        self.view.addSubview(tableView)
        self.view.addSubview(noPhotosLabel)
    }

    private func configurateTableView() {
        //tableView.frame = self.view.frame
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(GalleryViewCell.self, forCellReuseIdentifier: String(describing: GalleryViewCell.self))
    }
    
    func coonfigurateNoPhotosLabel() {
//        noPhotosLabel.isHidden = true
        noPhotosLabel.text = Consts.NoPhotosLabel.text
        noPhotosLabel.font = Consts.NoPhotosLabel.font
        noPhotosLabel.textColor = Consts.NoPhotosLabel.color
        noPhotosLabel.sizeToFit()
    }
    
    private func configurateAddPhotoButton() {
        addPhotoButton.image = Consts.AddPhotoButton.image
        addPhotoButton.style = .plain
        addPhotoButton.target = self
        addPhotoButton.action = #selector(didTapOnAddImageButton)
    }

    private func configurateNavigationBar() {
        let backButton = UIBarButtonItem()
        backButton.title = Consts.BackButton.title
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.title = Consts.NavigationItem.title
//        self.navigationController?.navigationItem.rightBarButtonItem = addPhotoButton
        navigationItem.setRightBarButton(addPhotoButton, animated: false)
    }

    private func configurateView() {
        self.view.isMultipleTouchEnabled = false
        view.backgroundColor = .systemBackground
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noPhotosLabel.snp.makeConstraints { make in
            make.center.equalTo(self.view.snp.center)
        }
    }

    private func configureAppearenceNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let barAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.standardAppearance = barAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
    }

    //MARK: private methods

    private func updateUserInterfaceStyle() {
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            Consts.nukeOptions = Consts.nukeOptionsLightMode
            print("light mode detected")
        case .dark:
            Consts.nukeOptions = Consts.nukeOptionsDarkMode
            print("dark mode detected")
        @unknown default:
            print("unknown interface mode detected")
        }
    }

    @objc func didTapOnImageButton(button: CustomButton) {
        print(presenter.images?[button.imgId!].liked)
        print(button.imgId)
        presenter.tapOnTheImage(imageId: button.imgId)
    }
    
    @objc func didTapOnAddImageButton() {
        presenter.addImage()
    }
}
