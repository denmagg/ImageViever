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
    init(view: DetailViewProtocol, router: RouterProtocol, image : Image)
    func setImage()
    func tapOnDescription()
}

final class DetailPresenter:  DetailViewPresenterProtocol {
    private weak var view: DetailViewProtocol?
    private var router: RouterProtocol?
    private var image: Image
    
    required init(view: DetailViewProtocol, router: RouterProtocol, image: Image) {
        self.view = view
        self.image = image
        self.router = router
    }
    
    func setImage() {
        self.view?.setImage(image: image)
    }
    
    func tapOnDescription() {
        router?.showDescription(description: image.title)
        print("DescriptionTapped")
    }
    
}
