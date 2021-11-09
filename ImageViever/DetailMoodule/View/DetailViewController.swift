//
//  DetailViewController.swift
//  ImageViever
//
//  Created by Denis Medvedev on 26/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import UIKit
import Nuke

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    var imageScrollView = ImageScrollView()
    var presenter: DetailViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        imageScrollView.setup()

        presenter.setImage()
        // Do any additional setup after loading the view.
    }
    
    private func initialize() {
        view.backgroundColor = .white
        view.addSubview(imageScrollView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(descriptionButtonTapped(button:)))
        
        imageScrollView.snp.makeConstraints { make in
            print("going")
            make.edges.equalTo(view.safeAreaInsets)
        }
    }
    
    @objc func descriptionButtonTapped(button: UIBarButtonItem){
        presenter.tapOnDescription()
        
    }
}

extension DetailViewController: DetailViewProtocol {
    func setImage(image: Image?) {
        print(image?.url)
        guard let imageUrl = image?.url else { return }
        
        let options = ImageLoadingOptions(
            placeholder: UIImage(systemName: "photo"),
            transition: .fadeIn(duration: 0.33),
            failureImage: UIImage(systemName: "goforward"),
            failureImageTransition: .fadeIn(duration: 0.33),
            contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
        )
        
        Nuke.loadImage(with: URL(string: imageUrl)!,
        options: options,
        into: imageScrollView)
        
    }
}
