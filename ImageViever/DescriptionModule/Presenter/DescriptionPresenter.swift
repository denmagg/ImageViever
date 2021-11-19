//
//  DescriptionPresenter.swift
//  ImageViever
//
//  Created by Denis Medvedev on 09/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import Foundation

protocol DescriptionViewProtocol {
    func setDescription(description: String)
}

protocol DescriptionPresenterProtocol {
    init(view: DescriptionViewProtocol, description: String, router: RouterProtocol)
    func setDescription()
    func goBack()
}


final class DescriptionPresenter: DescriptionPresenterProtocol {
    private var view: DescriptionViewProtocol!
    private var router: RouterProtocol?
    private let description: String
    
    required init(view: DescriptionViewProtocol, description: String, router: RouterProtocol) {
        self.view = view
        self.description = description
        self.router = router
    }
    
    func setDescription() {
        self.view.setDescription(description: self.description)
    }
    
    func goBack() {
        router?.backToDetailViewController()
    }
}
