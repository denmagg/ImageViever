//
//  GalleryPresenter.swift
//  ImageViever
//
//  Created by Denis Medvedev on 25/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import Foundation

//протокол для вьюхи
protocol GalleryViewProtocol: class {
    //метод который будет отправлять сообщения нашей вьюхе
    func success()
    func failture(error: Error)
}

//протокол для входа данных
protocol GalleryPresenterProtocol: class {
    var showLiked: Bool { get }
    var images: [Image]? { get set }
    init(view: GalleryViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, showLiked: Bool)
    func getImages()
    func tapOnTheImage(imageId: Int?)
    func addImage()
}

class GalleryPresenter: GalleryPresenterProtocol {
    
    //MARK: properties
    
    var images: [Image]?
    let showLiked: Bool
    
    //MARK: private properties
    
    private weak var view: GalleryViewProtocol?
    private var router: RouterProtocol?
    private let networkService: NetworkServiceProtocol!
    
    //MARK: init
    
    required init(view: GalleryViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, showLiked: Bool = false) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.showLiked = showLiked
        getImages()
    }
    
    //MARK: methods
    
    func tapOnTheImage(imageId: Int?) {
        if let imageId = imageId, let image = images?[imageId] {
            router?.showDetail(image: image)
        }
    }
    
    func addImage() {
        router?.showImageAdding()
    }
    
    func getImages() {
        networkService.getImages { [weak self] result in
            guard let self = self else { return }
            //вызываем, потому что если мы сделаем success и во view  начнем релоудить таблицу, то у нас все брякнется
            //потому что возвращается все через URLSession асинхронно и соответственно success полетит во VC тоже асинхронно
            //и тк у нас UI не работает в main потоке у нас все брякнестя
            DispatchQueue.main.async {
                switch result {
                    //если пришел success, то сюда вернутся изображения через ассоциаливный тип
                case .success(let images):
                    if self.showLiked == true {
                        self.images = images?.filter({ (image) -> Bool in
                            if image.liked == true {
                                return true
                            } else {
                                return false
                            }
                        })
                    } else {
                        self.images = images
                    }
                    self.view?.success()
                case .failure(let error):
                    self.view?.failture(error: error)
                }
            }
        }
    }
}


