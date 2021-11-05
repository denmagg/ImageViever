//
//  ImageScrollView.swift
//  ImageViever
//
//  Created by Denis Medvedev on 27/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import UIKit

class ImageScrollView2: UIScrollView {
    
    var imageView = UIImageView()
    
    init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    private func initialize() {
        self.delegate = self
        
        self.addSubview(imageView)
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 6.0
        self.backgroundColor = .green
        
        imageView.isUserInteractionEnabled = true
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            //make.centerX.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ImageScrollView2: UIScrollViewDelegate{
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}


