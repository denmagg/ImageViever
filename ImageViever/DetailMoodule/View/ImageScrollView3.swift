////
////  ImageScrollView.swift
////  ImageViever
////
////  Created by Denis Medvedev on 27/10/2021.
////  Copyright © 2021 Denis Medvedev. All rights reserved.
////
//
//import UIKit
//import Nuke
//
//final class ImageScrollView: UIScrollView {
//    
//    var imageView = UIImageView()
//    var barHeight: CGFloat
//    
//    init(barHeight: CGFloat) {
//        self.barHeight = barHeight
//        super.init(frame: CGRect.zero)
//        initialize()
//    }
//    
//    private func initialize() {
//        self.delegate = self
//        
//        self.addSubview(imageView)
//        self.minimumZoomScale = 1.0
//        self.maximumZoomScale = 6.0
//        self.backgroundColor = .green
//        
//        imageView.isUserInteractionEnabled = true
//        imageView.contentMode = .scaleAspectFit
//        imageView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.top.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalToSuperview().inset(barHeight)
//            //make.center.equalToSuperview()
//        }
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//
//extension ImageScrollView: UIScrollViewDelegate{
//    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.imageView
//    }
//}
//
//extension ImageScrollView: Nuke_ImageDisplaying {
//    public func nuke_display(image: PlatformImage?) {
//        self.imageView.image = image
//    }
//}
//
