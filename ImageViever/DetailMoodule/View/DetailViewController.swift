//
//  DetailViewController.swift
//  ImageViever
//
//  Created by Denis Medvedev on 26/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import UIKit
import Nuke

final class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    private var imageScrollView: ImageScrollView!
    var presenter: DetailViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageScrollView = ImageScrollView(barHeight: (getStatusBarHeight() + getNavigationBarHeight()))
        imageScrollView = ImageScrollView()
        initialize()
        imageScrollView.setup()

        presenter.setImage()
        // Do any additional setup after loading the view.
    }
    
    
    private func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    private func getNavigationBarHeight() -> CGFloat {
        return (navigationController?.navigationBar.frame.height ?? 0)
    }
    
    private func initialize() {
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(descriptionButtonTapped(button:)))
        
        view.addSubview(imageScrollView)
        imageScrollView.snp.makeConstraints { make in
            print("going")
            make.edges.equalToSuperview()
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
