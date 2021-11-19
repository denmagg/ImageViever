//
//  DescriptionPresenterTest.swift
//  ImageVieverTests
//
//  Created by Denis Medvedev on 19/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import XCTest
@testable import ImageViever

class DescriptionPresenterTest: XCTestCase {

    var view: MockDescriptionViewController!
    var router: RouterProtocol!
    var imageDescription: String!
    var navigationController: MockNavigationController!
    var sut: DescriptionPresenterProtocol!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        navigationController = MockNavigationController()
        let assemblyBuilder = AssemblyModuleBuilder()
        router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
        imageDescription = "Bar"
        view = MockDescriptionViewController()
        sut = DescriptionPresenter(view: view, description: imageDescription, router: router)
    }

    override func tearDown() {
        router = nil
        imageDescription = nil
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSetDescription() {
        sut.setDescription()

        XCTAssertEqual(view.descriptionLabel, imageDescription)
    }

    //Нельзя протестировать, тк нет стека контроллеров
//    func testGoBackPresentsDetailViewController() {
//
//        sut.goBack()
//
//        XCTAssertTrue(navigationController.presentedVC is DescriptionViewController)
//    }

}

extension DescriptionPresenterTest {
    class MockDescriptionViewController: DescriptionViewProtocol {
        var descriptionLabel = ""
        func setDescription(description: String) {
            descriptionLabel = description
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
