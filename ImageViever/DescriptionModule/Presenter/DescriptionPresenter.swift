//
//  DescriptionPresenter.swift
//  ImageViever
//
//  Created by Denis Medvedev on 09/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import Foundation

protocol DescriptionViewProtocol {
    func setDescription(description: String)
}

protocol DescriptionPresenterProtocol {
    init(view: DescriptionViewProtocol, description: String)
    func setDescription()
}


class DescriptionPresenter: DescriptionPresenterProtocol {
    var view: DescriptionViewProtocol!
    
    let description: String
    
    required init(view: DescriptionViewProtocol, description: String) {
        self.view = view
        self.description = description
    }
    
    func setDescription() {
        self.view.setDescription(description: description)
    }
}
