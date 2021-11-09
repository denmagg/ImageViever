//
//  ModuleBuilder.swift
//  ImageViever
//
//  Created by Denis Medvedev on 25/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import UIKit

protocol AsselderBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(image: Image?, router: RouterProtocol) -> UIViewController
    func createDescriptionModule(description: String, router: RouterProtocol) -> UIViewController
}

//Внедрение зависимостей - те они создаются не внутри всех этих сущностей эти штуки, а снаружи и потом туда инжектятся
//Нужна по SOLID, и для того чтобы во время тестов подсунуть сюда мок объект, для того чтобы протестировать презентер.
class AsselderModuleBuilder: AsselderBuilderProtocol {
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let view = GalleryViewController()
        let presenter = GalleryPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createDetailModule(image: Image?, router: RouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, networkService: networkService, router: router, image: image)
        view.presenter = presenter
        return view
    }
    
    func createDescriptionModule(description: String, router: RouterProtocol) -> UIViewController {
        let view = DescriptionViewController()
        let presenter = DescriptionPresenter(view: view, description: description)
        view.presenter = presenter
        return view
    }
    
}
