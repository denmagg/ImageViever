//
//  NetworkServiceTest.swift
//  ImageVieverTests
//
//  Created by Denis Medvedev on 19/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import XCTest
@testable import ImageViever

class NetworkServiceTest: XCTestCase {
    
    var sut: NetworkServiceProtocol!
    //var networkError: NetworkError!

    override func setUp() {
        sut = NetworkService()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetImagesWithNoConnectionAndLocaldataShouldComplitionSuccess() {
        NetworkMonitor.shared.isConnected = false
        NetworkMonitor.shared.stopMonitoring()
        
        let getImagesAnwer = expectation(description: "getImages answer")
        sut.getImages { result in
            switch result {
            case .success(let images):
                XCTAssertNotNil(images)
                getImagesAnwer.fulfill()
            case .failure(_):
                XCTFail()
                getImagesAnwer.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetImagesWithNoConnectionEmptyFileShouldComplitionFailureByNoConnection() {
        NetworkMonitor.shared.isConnected = false
        NetworkMonitor.shared.stopMonitoring()
        var filePath = URL(string: "")
        do {
            filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: .none, create: false).appendingPathComponent("JSONData.json")
        } catch {
            print(error)
        }
        let text = ""
        do {
            try? text.write(to: filePath!, atomically: false, encoding: String.Encoding.utf8)
        }
        
        let getImagesAnwer = expectation(description: "getImages answer")
        sut.getImages { result in
            switch result {
            case .success(_):
                XCTFail()
                getImagesAnwer.fulfill()
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.noConnection)
                getImagesAnwer.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetImagesWithInternetConnectionShouldComplitionSuccess() {
        let getImagesAnwer = expectation(description: "getImages answer")
        sut.getImages { result in
            switch result {
            case .success(let images):
                XCTAssertNotNil(images)
                getImagesAnwer.fulfill()
            case .failure(_):
                XCTFail()
                getImagesAnwer.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
