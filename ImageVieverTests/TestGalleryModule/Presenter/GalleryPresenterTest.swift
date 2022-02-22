//
//  GallerPresenterTest.swift
//  ImageVieverTests
//
//  Created by Denis Medvedev on 05/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import XCTest
@testable import ImageViever

class GalleryPresenterTest: XCTestCase {

    var view: MockGalleryViewController!
    var sut: GalleryPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    var navigationController: MockNavigationController!
    var images: [Image]? = [Image]()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        navigationController = MockNavigationController()
        let assemblyBuilder = AssemblyModuleBuilder()
        router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
        view = MockGalleryViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        router = nil
        view = nil
        networkService = nil
        sut = nil
    }
    
    func testInitGalleryPresenter() {
        networkService = MockNetworkSservice()

        sut = GalleryPresenter(view: view, networkService: networkService, router: router)

        XCTAssertNotNil(sut)
    }

    //Проверем пришли наши image или нет
    func testGetSuccessImages() {
        // given
        let image = Image(albumId: 0, id: 0, title: "Baz", url: "https://novikov.com.ua/wp-content/uploads/2020/11/Mock-Tests-min.jpg", thumbnailUrl: "https://novikov.com.ua/wp-content/uploads/2020/11/Mock-Tests-min.jpg")
        images?.append(image)
        networkService = MockNetworkSservice(images: images)
        sut = GalleryPresenter(view: view, networkService: networkService, router: router)
        
        // when
        var catchImages: [Image]?
        networkService.getImages { result in
            switch result {
            case .success(let images):
                catchImages = images
            case .failure(let error):
                print(error)
            }
        }
        
        // then
        XCTAssertNotEqual(catchImages?.count, 0)
        XCTAssertEqual(catchImages?.count, images?.count)
        XCTAssertEqual(catchImages?[0].albumId, 0)
        XCTAssertEqual(catchImages?[0].id, 0)
        XCTAssertEqual(catchImages?[0].title, "Baz")
        XCTAssertEqual(catchImages?[0].url, "https://novikov.com.ua/wp-content/uploads/2020/11/Mock-Tests-min.jpg")
        XCTAssertEqual(catchImages?[0].url, "https://novikov.com.ua/wp-content/uploads/2020/11/Mock-Tests-min.jpg")
    }
    
    func testGetFailureImages() {
        networkService = MockNetworkSservice()
        sut = GalleryPresenter(view: view, networkService: networkService, router: router)
        
        var catchError: Error?
        networkService.getImages { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                catchError = error
            }
        }
        
        XCTAssertNotNil(catchError)
    }
    
    //FIMXE: presenter при инициализаци обходит DispatchQueue.main.async и не устанавливает себе изображение
    func testTapOnImagePresentsDetailViewController() {
        let image = Image(albumId: 0, id: 0, title: "Baz", url: "https://novikov.com.ua/wp-content/uploads/2020/11/Mock-Tests-min.jpg", thumbnailUrl: "https://novikov.com.ua/wp-content/uploads/2020/11/Mock-Tests-min.jpg")
        images?.append(image)
        networkService = MockNetworkSservice(images: images)
        sut = GalleryPresenter(view: view, networkService: networkService, router: router)
        
        networkService.getImages { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let images):
                    self.sut.images = images
                case .failure(_):
                    XCTFail()
                }
            }
        }
        sut.tapOnTheImage(imageId: image.id)
        
        XCTAssertTrue(navigationController.presentedVC is DetailViewController)
    }
    
}

extension GalleryPresenterTest {
    class MockNavigationController: UINavigationController {
        var presentedVC: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            self.presentedVC = viewController
            super.pushViewController(viewController, animated: true)
        }
        
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            self.presentedVC = viewControllerToPresent
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
    
    class MockNetworkSservice: NetworkServiceProtocol {
        var images: [Image]!
        
        init () {}
        
        convenience init(images: [Image]?) {
            self.init()
            self.images = images
        }
        func getImages(complition: @escaping (Result<[Image]?, NetworkError>) -> Void) {
            if let images = images {
                complition(.success(images))
            } else {
                let error = NetworkError.unexpected(code: 0)
                complition(.failure(error))
            }
        }
    }
    
    class MockGalleryViewController: GalleryViewProtocol {
        func success() { }

        func failture(error: Error) {
            print(error.localizedDescription)
        }
    }
}
