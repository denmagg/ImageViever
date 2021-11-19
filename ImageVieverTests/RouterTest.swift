//
//  RouterTest.swift
//  ImageVieverTests
//
//  Created by Denis Medvedev on 16/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import XCTest
@testable import ImageViever

class RouterTest: XCTestCase {
    
    var router: RouterProtocol!
    var navigationController: MockNavigationController!
    var assembly: AssemblyBuilderProtocol!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        navigationController = MockNavigationController()
        assembly = AssemblyModuleBuilder()
        router = Router(navigationController: navigationController, assemblyBuilder: assembly)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        router = nil
    }
    
    func testInitialViewControllerIsGalleryViewController() {
        router.initialViewController()
        let galleryViewController = router.navigationController?.viewControllers.last
        
        XCTAssertTrue(galleryViewController is GalleryViewController)
    }
    
    func testShowDetailPresentsDetailViewController() {
        let image = Image(albumId: 0, id: 0, title: "Baz", url: "Bar", thumbnailUrl: "Foo")
        
        router.showDetail(image: image)
        let detailViewController = navigationController.presentedVC.last
        
        XCTAssertTrue(detailViewController is DetailViewController)
    }
    
    
    
    func testShowDescriptionPresentsDecriptionViewController() {
        let mockDescritpion = "Bar"
        
        router.showDescription(description: mockDescritpion)
        let descritpionViewController = navigationController.presentedVC.last
        
        XCTAssertTrue(descritpionViewController is DescriptionViewController)
        
    }
    
    //FIXME: override func dismiss didn't work, why???
//    func testBackToDetailViewControllerPresentsDetailViewController() {
//        router.initialViewController()
//        let image = Image(albumId: 0, id: 0, title: "Baz", url: "Bar", thumbnailUrl: "Foo")
//        router.showDetail(image: image)
//        let mockDescritpion = "Bar"
//        router.showDescription(description: mockDescritpion)
//        router.backToDetailViewController()
//        let detailViewController = navigationController.presentedVC.last
//
//
//        XCTAssertTrue(detailViewController is DetailViewController)
//    }
    
}

extension RouterTest {
    class MockNavigationController: UINavigationController {
        var presentedVC = [UIViewController]()
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            self.presentedVC.append(viewController)
            super.pushViewController(viewController, animated: true)
        }
        
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            self.presentedVC.append(viewControllerToPresent)
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        }
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            print("----------Print-перед удалением-----------")
            print(presentedVC)
            presentedVC.removeLast()
            print("----------Print-после удаления-----------")
            print(presentedVC)
            super.dismiss(animated: flag, completion: completion)
        }
        
        
    }
}
