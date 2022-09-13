////
////  Router.swift
////  ImageViever
////
////  Created by Denis Medvedev on 25/10/2021.
////  Copyright © 2021 Denis Medvedev. All rights reserved.
////
//
//import UIKit
//
////базовый тип для всех роутеров
//protocol RouterMain {
//    var navigationController: UINavigationController? { get set }
//    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
//}
//
////для конкретного роутера
//protocol RouterProtocol: RouterMain {
//    func initialViewController()
//    func showDetail(image: Image)
//    func showDescription(description: String)
//    func closeDescription()
//    func backToPreviousViewController()
//}
//
//final class Router : RouterProtocol {
//    
//    //MARK: properties
//    
//    var navigationController: UINavigationController?
//    var assemblyBuilder: AssemblyBuilderProtocol?
//    
//    //MARK: inits
//    
//    init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol?){
//        self.navigationController = navigationController
//        self.assemblyBuilder = assemblyBuilder
//    }
//
//    //MARK: methods
//    
//    
//    
//    func initialViewController() {
//        if let navigationController = navigationController {
//            guard let galleryViewController = assemblyBuilder?.createGalleryModule(router: self) else { return }
//            navigationController.viewControllers = [galleryViewController]
//        }
//    }
//    
//    func showDetail(image: Image) {
//        if let navigationController = navigationController {
//            guard let detailViewController = assemblyBuilder?.createDetailModule(image: image, router: self) else { return }
//            navigationController.pushViewController(detailViewController, animated: true)
//        }
//    }
//    
//    func showDescription(description: String) {
//        if let navigationController = navigationController {
//            guard let descriptionViewController = assemblyBuilder?.createDescriptionModule(description: description, router: self) else { return }
//            descriptionViewController.modalPresentationStyle = .popover
//            
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                guard let sourceView = navigationController.viewControllers.last?.view else { return }
//                descriptionViewController.popoverPresentationController?.sourceView = sourceView
//                descriptionViewController.popoverPresentationController?.sourceRect = CGRect(x: sourceView.bounds.size.width / 2.0, y: sourceView.bounds.size.height / 2.0, width: 1.0, height: 1.0)
//            }
//            
//            navigationController.present(descriptionViewController, animated: true)
//        }
//    }
//    
//    func closeDescription() {
//        navigationController?.viewControllers.last?.dismiss(animated: true)
//    }
//    
//    func backToPreviousViewController() {
//        _ = navigationController?.popViewController(animated: true)
//    }
//}
