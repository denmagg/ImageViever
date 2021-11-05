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
    init(view: GalleryViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    //func getImages()
    func getData(from urlString: String?, complition: @escaping (Data)->())
    var images: [Image]? { get set }
    func tapOnTheImage(imageId: Int?)
}

class GalleryPresenter: GalleryPresenterProtocol {
    weak var view: GalleryViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    var images: [Image]?
    
    required init(view: GalleryViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getImages()
    }
    
    func tapOnTheImage(imageId: Int?) {
        if let imageId = imageId, let image = images?[imageId] {
            router?.showDetail(image: image)
        }
    }
    
    func getImages() {
        networkService.getImages { [weak self] result in
            guard let self = self else { return }
            //вызываем, потому что если мы сделаем success и во view  начнем релоудить таблицу, то у нас все брякнется
            //потому что возвращается все через URLSession асинхронно и соответственно success полетит во VC тоже асинхронно
            //и тк у нас UI не работает в main потоке у нас все брякнестя
            DispatchQueue.main.async {
                switch result {
                    //если пришел success, то сюда вернутся комменты через ассоциаливный тип
                case .success(let images):
                    self.images = images
                    self.view?.success()
                case .failure(let error):
                    self.view?.failture(error: error)
                }
            }
        }
    }
    
    func getData(from urlString: String?, complition: @escaping (Data)->()) {
        if let urlString = urlString {
            DispatchQueue.global().async {
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        complition(data)
                    }
                }
            }
        }
    }
    
    
    
//    func getData(urlString: String?) -> Data? {
//        var imageData: Data?
//        DispatchQueue.global().async {
//            guard let urlString = urlString else { return }
//            if let url = URL(string: urlString) {
//                if let data = try? Data(contentsOf: url) {
//                    imageData = data
//                }
//            }
//        }
//        return imageData
//    }
}


