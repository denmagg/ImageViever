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
    var tabBarController: UITabBarController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

//для конкретного роутера
protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(image: Image)
    func showDescription(description: String)
    func closeDescription()
    func backToPreviousViewController()
    func showImageAdding()
}

final class Router : RouterProtocol {
    
    //MARK: properties
    
    var tabBarController: UITabBarController?
    
    var photosNavigationController: UINavigationController?
    
    var likedNavigationController: UINavigationController?

    var settingsNavigationController: UINavigationController?
    
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    //MARK: private properties
    
    private enum Consts {
        enum TabBarItems {
            static let photosTabBarItem = UITabBarItem(title: "Photos", image: UIImage(systemName: "photo.fill.on.rectangle.fill"), tag: 0)
            static let likedTabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 1)
            static let settingsTabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        }
    }
    
    //MARK: inits
    
    init(tabBarController: UITabBarController?, assemblyBuilder: AssemblyBuilderProtocol?){
        self.tabBarController = tabBarController
        self.assemblyBuilder = assemblyBuilder
    }

    //MARK: methods
    
    func initialViewController() {
        if let tabBarController = tabBarController {
            guard let galleryViewController = assemblyBuilder?.createGalleryModule(router: self) else { return }
            guard let likedViewController = assemblyBuilder?.createLikedModule(router: self) else { return }
            guard let settingsViewController = assemblyBuilder?.createSettingsModule(router: self) else { return }
            galleryViewController.tabBarItem = Consts.TabBarItems.photosTabBarItem
            likedViewController.tabBarItem = Consts.TabBarItems.likedTabBarItem
            settingsViewController.tabBarItem = Consts.TabBarItems.settingsTabBarItem
            photosNavigationController = UINavigationController(rootViewController: galleryViewController)
            likedNavigationController = UINavigationController(rootViewController: likedViewController)
            settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
            tabBarController.viewControllers = [photosNavigationController!, likedNavigationController!, settingsNavigationController!]
        }
    }
    
    func showDetail(image: Image) {
        if let navigationController = tabBarController?.selectedViewController as? UINavigationController {
            guard let detailViewController = assemblyBuilder?.createDetailModule(image: image, router: self) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func showDescription(description: String) {
        if let navigationController = tabBarController?.selectedViewController as? UINavigationController {
            guard let descriptionViewController = assemblyBuilder?.createDescriptionModule(description: description, router: self) else { return }
            descriptionViewController.modalPresentationStyle = .popover

            if UIDevice.current.userInterfaceIdiom == .pad {
                guard let sourceView = navigationController.viewControllers.last?.view else { return }
                descriptionViewController.popoverPresentationController?.sourceView = sourceView
                descriptionViewController.popoverPresentationController?.sourceRect = CGRect(x: sourceView.bounds.size.width / 2.0, y: sourceView.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            }

            navigationController.present(descriptionViewController, animated: true)
        }
    }
    
    func closeDescription() {
        if let navigationController = tabBarController?.selectedViewController as? UINavigationController {
            navigationController.viewControllers.last?.dismiss(animated: true)
        }
    }
    
    func backToPreviousViewController() {
        if let navigationController = tabBarController?.selectedViewController as? UINavigationController {
            _ = navigationController.popViewController(animated: true)
        }
    }
    
    func showImageAdding() {
        if let navigationController = tabBarController?.selectedViewController as? UINavigationController {
            guard let imageAddingViewController = assemblyBuilder?.createImageAddingModule(router: self) else { return }
            navigationController.pushViewController(imageAddingViewController, animated: true)
        }
    }
}
