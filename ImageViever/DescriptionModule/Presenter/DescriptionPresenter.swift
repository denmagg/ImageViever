//
//  DescriptionPresenter.swift
//  ImageViever
//
//  Created by Denis Medvedev on 09/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import Foundation

protocol DescriptionViewProtocol: class {
    func setDescription(description: String)
}

protocol DescriptionPresenterProtocol: class {
    init(view: DescriptionViewProtocol, description: String, router: RouterProtocol)
    func setDescription()
    func goBack()
}

final class DescriptionPresenter: DescriptionPresenterProtocol {
    
    //MARK: private properties
    
    private weak var view: DescriptionViewProtocol?
    private var router: RouterProtocol?
    private let description: String
    
    //MARK: init
    
    required init(view: DescriptionViewProtocol, description: String, router: RouterProtocol) {
        self.view = view
        self.description = description
        self.router = router
    }
    
    //MARK: methods
    
    func setDescription() {
        view?.setDescription(description: description)
    }
    
    func goBack() {
        router?.closeDescription()
    }
}
