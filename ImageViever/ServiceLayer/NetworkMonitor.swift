//
//  NetworkMonitor.swift
//  ImageViever
//
//  Created by Denis Medvedev on 04/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import Foundation
import Network

final class NetworkMonitor {
    
    //MARK: properties
    
    static let shared = NetworkMonitor()
    public  var isConnected: Bool = false
    
    //MARK: private properties
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    //MARK: init
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    //MARK: methods
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = {  path in
            self.isConnected = path.status != .unsatisfied
            print(self.isConnected)
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
}
