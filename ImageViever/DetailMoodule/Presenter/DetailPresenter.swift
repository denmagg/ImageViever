//
//  DetailPresenter.swift
//  ImageViever
//
//  Created by Denis Medvedev on 26/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import Foundation

//input/output protocols
protocol DetailViewProtocol: class {
    func setImage(image: Image?)
}

protocol DetailViewPresenterProtocol: class {
    init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, image : Image?)
    func setImage()
    func tapOnDescription()
}

class DetailPresenter:  DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    var image: Image?
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, image: Image?) {
        self.view = view
        self.networkService = networkService
        self.image = image
        self.router = router
    }
    
    func setImage() {
        self.view?.setImage(image: image)
    }
    
    func tapOnDescription() {
        router?.showDescription(description: image?.title ?? "биба")
        print("DescriptionTapped")
    }
    
}
