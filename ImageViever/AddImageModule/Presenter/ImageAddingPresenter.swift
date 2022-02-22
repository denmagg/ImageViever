//
//  ImageAddingPresenter.swift
//  ImageViever
//
//  Created by Denis Medvedev on 11/02/2022.
//  Copyright © 2022 Denis Medvedev. All rights reserved.
//

import Foundation

@objc protocol ImageAddingViewProtocol: class {
    @objc func hideKeyboard()
}

protocol ImageAddingPresenterProtocol: class {
    
}

final class ImageAddingPresenter: ImageAddingPresenterProtocol {
    
    //MARK: propetries
    
    //MARK: private properties
    
    private weak var view: ImageAddingViewProtocol?
    private var router: RouterProtocol?
    
    //MARK: init
    
    required init(view: ImageAddingViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
}
