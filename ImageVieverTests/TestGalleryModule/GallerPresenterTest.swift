//
//  GallerPresenterTest.swift
//  ImageVieverTests
//
//  Created by Denis Medvedev on 05/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import XCTest
@testable import ImageViever

class MockView: GalleryViewProtocol {
    func success() {

    }

    func failture(error: Error) {
        print(error.localizedDescription)
    }

}

class GallerPresenterTest: XCTestCase {

    var view: MockView!
    var presenter: GalleryPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol?
    var images = [Image]()


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        view = MockView()
        networkService = NetworkService()
        router = Router(navigationController: UINavigationController(), assembyBuilder: AsselderModuleBuilder())
        presenter = GalleryPresenter(view: view, networkService: networkService, router: router!)

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        view = nil
        networkService = nil
        router = nil
        presenter = nil
    }

    //Проверем пришли наши image или нет
    func testGetSuccessImages() {
        let image = Image
//        let image = Image(albumId: 0,
//                          id: 0,
//                          title: "Baz",
//                          url: "https://i.picsum.photos/id/919/200/300.jpg?hmac=jkU3iBD7FmgjpBy_oLT-Au05XW2UsFassE3X44PO_iQ",
//                          thumbnailUrl: "https://i.picsum.photos/id/919/200/300.jpg?hmac=jkU3iBD7FmgjpBy_oLT-Au05XW2UsFassE3X44PO_iQ")
    }

    func testMooduleIsNotNil() {
        XCTAssertNotNil(view, "view is nil")
        XCTAssertNotNil(networkService, "networkService is nil")
        XCTAssertNotNil(router, "router is nil")
        XCTAssertNotNil(presenter, "presenter is nil")
    }

//    func testView() {
//        presenter.tapOnTheImage(imageId: 0)
//        XCTAssertEqual(view, <#T##expression2: Equatable##Equatable#>, <#T##message: String##String#>)
//    }

}
