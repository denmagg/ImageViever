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
    func goBack()
    func tapOnShare() -> String
    func tapOnLike() -> Bool?
}

final class DetailPresenter:  DetailViewPresenterProtocol {
    
    //MARK: private properties
    
    private weak var view: DetailViewProtocol?
    private var router: RouterProtocol?
    private var image: Image
    
    //MARK: init
    
    required init(view: DetailViewProtocol, router: RouterProtocol, image: Image) {
        self.view = view
        self.image = image
        self.router = router
    }
    
    //MARK: methods
    
    func setImage() {
        self.view?.setImage(image: image)
    }
    
    func tapOnDescription() {
        router?.showDescription(description: image.title)
        print("DescriptionTapped")
    }
    
    func goBack() {
        router?.backToPreviousViewController()
    }
    
    func tapOnLike() -> Bool? {
        if image.liked != nil {
            image.liked = nil
        } else {
            image.liked = true
        }
        print("image liked \(image.liked)")
        return image.liked
    }
    
    func tapOnShare() -> String {
        return image.url
    }
    
    func tapOnDelete() {
        
    }
    
}
