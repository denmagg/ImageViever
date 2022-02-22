//
//  SettingsPresenter.swift
//  ImageViever
//
//  Created by Denis Medvedev on 09/02/2022.
//  Copyright © 2022 Denis Medvedev. All rights reserved.
//

import Foundation
import Nuke

protocol SettingsViewProtocol: class {
    
}

protocol SettingsPresenterProtocol: class {
    func clearCache()
    func getCacheSize() -> String
}

final class SettingsPresenter: SettingsPresenterProtocol {

    //MARK: propetries
    
    //MARK: private properties
    
    private weak var view: SettingsViewProtocol?
    private var router: RouterProtocol?
    
    //MARK: init
    
    required init(view: SettingsViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    //MARK: methods
    
    func clearCache() {
        print("Clearing...")
        //source: https://github.com/kean/Nuke/issues/128 или https://kean.blog/nuke/guides/caching#accessing-images
        //clear memory cache
        ImageCache.shared.removeAll()
        //clear disk cache
        DataLoader.sharedUrlCache.removeAllCachedResponses()
    }
    
    func getCacheSize() -> String {
        return "\(String(((DataLoader.sharedUrlCache.currentDiskUsage) / 1024) / 1024))MB"
    }
}
