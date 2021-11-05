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
    
//    var scrollView = UIScrollView()
//    var imageView = UIImageView()
//    var buttoon = UIButton()
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
        
        //imageScrollView.delegate = self
        imageScrollView.snp.makeConstraints { make in
            print("going")
            make.edges.equalTo(view.safeAreaInsets)
            //make.center.equalTo(view)
        }
        
//        imageScrollView.imageView.snp.makeConstraints { make in
//            make.size.width.equalTo(view)
//            make.size.height.equalTo(view)
//        }
        
//        view.addSubview(scrollView)
//        scrollView.addSubview(imageView)
//        scrollView.addSubview(buttoon)
//
//        view.backgroundColor = .white
//
//        scrollView.delegate = self
//        scrollView.minimumZoomScale = 1.0
//        scrollView.maximumZoomScale = 6.0
//        scrollView.backgroundColor = .green
//
//
//
//        imageView.isUserInteractionEnabled = true
//
//        buttoon.backgroundColor = .blue
//        buttoon.frame.size.height = 10
//        buttoon.frame.size.width = 10
//
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        imageView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//        }
//
//        buttoon.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
    }
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.imageScrollView.imageView
//    }
    
    

}

extension DetailViewController: DetailViewProtocol {
    func setImage(image: Image?) {
        print(image?.url)
        guard let imageUrl = image?.url else { return }
        
//        presenter.getData(from: imageUrl) { data in
//            DispatchQueue.main.async {
////                self.imageScrollView.imageView.image = UIImage(data: data)
////                self.imageScrollView.imageView.contentMode = .scaleAspectFit
//                self.imageScrollView.display(image: UIImage(data: data)!)
//            }
//        }
        let options = ImageLoadingOptions(
            placeholder: UIImage(systemName: "photo"), transition: .fadeIn(duration: 0.33), failureImage: UIImage(systemName: "goforward"), failureImageTransition: .fadeIn(duration: 0.33), contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
        )
        
        Nuke.loadImage(with: URL(string: imageUrl)!,
        options: options,
        into: imageScrollView)
        
    }
}
