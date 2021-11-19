//
//  Router.swift
//  ImageViever
//
//  Created by Denis Medvedev on 25/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import UIKit

//базовый тип для всех роутеров
protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

//для конкретного роутера
protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(image: Image)
    func showDescription(description: String)
    func backToDetailViewController()
}

final class Router : RouterProtocol {
    var navigationController: UINavigationController?
    
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol?){
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    func initialViewController() {
        if let navigationController = navigationController {
            guard let galleryViewController = assemblyBuilder?.createGalleryModule(router: self) else { return }
            navigationController.viewControllers = [galleryViewController]
        }
    }
    
    func showDetail(image: Image) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?.createDetailModule(image: image, router: self) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func showDescription(description: String){
        if let navigationController = navigationController {
            guard let descriptionViewController = assemblyBuilder?.createDescriptionModule(description: description, router: self) else { return }
            descriptionViewController.modalPresentationStyle = .popover
            //navigationController.viewControllers.last?.present(descriptionViewController, animated: true)
            navigationController.present(descriptionViewController, animated: true)
        }
    }
    
    func backToDetailViewController() {
        navigationController?.viewControllers.last?.dismiss(animated: true)
    }
}
