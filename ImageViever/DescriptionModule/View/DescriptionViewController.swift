//
//  DescriptionViewController.swift
//  ImageViever
//
//  Created by Denis Medvedev on 09/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    var presenter: DescriptionPresenterProtocol!
    var descriptionLabel = UILabel()
    var headerLablel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter.setDescription()
        // Do any additional setup after loading the view.
    }
    
    func initialize() {
        view.backgroundColor = .white
//        navigationItem.title = "Description"
        
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(20)
        }
        
        headerLablel.numberOfLines = 0
        view.addSubview(headerLablel)
        headerLablel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(20)
        }
        headerLablel.text = "Description:"
        headerLablel.font = UIFont.boldSystemFont(ofSize: 16)
        
    }

}

extension DescriptionViewController: DescriptionViewProtocol {
    func setDescription(description: String) {
        self.descriptionLabel.text = description
    }
}
