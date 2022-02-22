//
//  DescriptionViewController.swift
//  ImageViever
//
//  Created by Denis Medvedev on 09/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import UIKit

final class DescriptionViewController: UIViewController {
    
    //MARK: properties
    
    var presenter: DescriptionPresenterProtocol!
    
    //MARK: private properties
    
    private var descriptionLabel = UILabel()
    private var headerLablel = UILabel()
    private var backButton = UIButton(type: .system)
    
    private enum Consts {
        enum DescriptionLabel {
            static let leftInset = 20
            static let rightInset = 20
            static let numberOfLines = 0
        }
        enum HeaderLablel {
            static let leftInset = 20
            static let rightInset = 20
            static let numberOfLines = 0
            static let text = "Description:"
            static let font = UIFont.boldSystemFont(ofSize: 16)
        }
        enum BackButton {
            static let leftInset = 20
            static let width = 50
            static let height = 30
            static let title = "Back"
            static let font = UIFont(name: "System", size: 17)
        }
    }
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        configurateDescriptionLabel()
        configurateHeaderLablel()
        conigurateBackButton()
        configurateView()
        setupConstraints()
        setupAppearence()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.userInterfaceIdiom == .pad {
            let screenCenter = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            self.popoverPresentationController?.sourceRect = CGRect(x: screenCenter.x, y: screenCenter.y, width: 1.0, height: 1.0)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        if UIDevice.current.orientation.isPortrait || UIDevice.current.userInterfaceIdiom == .pad {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
    }
    
    //MARK: methods
    
    @objc func didTapOnBackButton() {
        presenter.goBack()
    }
    
    //MARK: private methods
    
    private func setupSubviews() {
        view.addSubview(descriptionLabel)
        view.addSubview(headerLablel)
        view.addSubview(backButton)
    }
    
    private func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(Consts.DescriptionLabel.leftInset)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(Consts.DescriptionLabel.rightInset)
        }
        headerLablel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(Consts.HeaderLablel.leftInset)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(Consts.HeaderLablel.rightInset)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)//.inset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(Consts.BackButton.leftInset)
            //            make.center.equalToSuperview()
            make.width.equalTo(Consts.BackButton.width)
            make.height.equalTo(Consts.BackButton.height)
        }
    }
    
    private func configurateDescriptionLabel() {
        descriptionLabel.numberOfLines = Consts.DescriptionLabel.numberOfLines
        presenter.setDescription()
    }
    
    private func configurateHeaderLablel() {
        headerLablel.numberOfLines = Consts.HeaderLablel.numberOfLines
        headerLablel.text = Consts.HeaderLablel.text
        headerLablel.font = Consts.HeaderLablel.font
    }
    
    private func conigurateBackButton() {
        backButton.setTitle(Consts.BackButton.title, for: .normal)
        backButton.titleLabel?.font = Consts.BackButton.font
        backButton.contentHorizontalAlignment = .left
        backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)
    }
    
    private func configurateView() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func setupAppearence() {
        guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
        let isPortrait = scene.interfaceOrientation.isPortrait
        
        if isPortrait || UIDevice.current.userInterfaceIdiom == .pad {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
    }

}

//MARK: extension DescriptionViewProtocol

extension DescriptionViewController: DescriptionViewProtocol {
    func setDescription(description: String) {
        self.descriptionLabel.text = description
    }
}
