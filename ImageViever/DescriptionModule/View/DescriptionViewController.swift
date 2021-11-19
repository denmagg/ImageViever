//
//  DescriptionViewController.swift
//  ImageViever
//
//  Created by Denis Medvedev on 09/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import UIKit

final class DescriptionViewController: UIViewController {
    
    
    var presenter: DescriptionPresenterProtocol!
    private var descriptionLabel = UILabel()
    private var headerLablel = UILabel()
    private var backButton = UIButton(type: .system)
    
    // MARK: hdkgjhk
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter.setDescription()
        // Do any additional setup after loading the view.
    }
    
    private func initialize() {
        view.backgroundColor = .white
        view.addSubview(descriptionLabel)
        view.addSubview(headerLablel)
        view.addSubview(backButton)
        
        descriptionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(20)
        }
        headerLablel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(20)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)//.inset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(20)
            //            make.center.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        descriptionLabel.numberOfLines = 0
        
        headerLablel.numberOfLines = 0
        headerLablel.text = "Description:"
        headerLablel.font = UIFont.boldSystemFont(ofSize: 16)
        
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "System", size: 17)
        backButton.contentHorizontalAlignment = .left
        //FIXME: почему-то первый раз срабатывает else
        if UIDevice.current.orientation.isPortrait {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        if UIDevice.current.orientation.isPortrait {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
    }
    
    @objc func goBack() {
        presenter.goBack()
    }

}

extension DescriptionViewController: DescriptionViewProtocol {
    func setDescription(description: String) {
        self.descriptionLabel.text = description
    }
}
