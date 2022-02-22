//
//  DetailPresenterTest.swift
//  ImageVieverTests
//
//  Created by Denis Medvedev on 18/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import XCTest
@testable import ImageViever

class DetailPresenterTest: XCTestCase {
    
    var view: MockDetailViewController!
    var navigationController: MockNavigationController!
    var router: RouterProtocol!
    var image: Image!
    var sut: DetailViewPresenterProtocol!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        view = MockDetailViewController()
        navigationController = MockNavigationController()
        let assemblyBuilder = AssemblyModuleBuilder()
        router = Router(tabBarController: navigationController, assemblyBuilder: assemblyBuilder)
        image = Image(albumId: 0, id: 0, title: "Baz", url: "Bar", thumbnailUrl: "Foo")
        sut = DetailPresenter(view: view, router: router, image: image)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitDetailPresenter() {
        XCTAssertNotNil(sut)
        XCTAssertTrue(sut is DetailPresenter)
    }
    
    func testSetImage() {
        sut.setImage()
        
        XCTAssertEqual(view.image?.albumId, image?.albumId)
        XCTAssertEqual(view.image?.id, image?.id)
        XCTAssertEqual(view.image?.title, image?.title)
        XCTAssertEqual(view.image?.url, image?.url)
        XCTAssertEqual(view.image?.thumbnailUrl, image?.thumbnailUrl)
    }
    
    func testTapOnDescriptionPresentsDescriptionViewVintroller() {
        sut.tapOnDescription()
        
        XCTAssertTrue(navigationController.presentedVC is DescriptionViewController)
    }
    

}

extension DetailPresenterTest {
    class MockDetailViewController: DetailViewProtocol {
        var image: Image?
        func setImage(image: Image?) {
            self.image = image
        }
    }
    
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
}
