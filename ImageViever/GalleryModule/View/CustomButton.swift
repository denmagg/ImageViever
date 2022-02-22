//
//  CustomButton.swift
//  ImageViever
//
//  Created by Denis Medvedev on 27/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import UIKit
import SnapKit
import Nuke

final class CustomButton : UIButton {
    
    //MARK: properties
    
    var imgId: Int?
    var imageLiked = UIImageView()
    
    private enum Consts {
        enum ImageLikedImageView {
            static let image = UIImage(systemName: "heart.fill")
        }
    }
    
    //MARK: inits
    
    init() {
        super.init(frame: CGRect.zero)
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
        setupSubviews()
        configurateImageLiked()
        setupConstraints()
    }
    
    private func setupSubviews() {
        self.imageView?.addSubview(imageLiked)
        //self.addSubview(imageLiked)
    }
    
    private func configurateImageLiked() {
//        imageLiked.isUserInteractionEnabled = false
        imageLiked.image = Consts.ImageLikedImageView.image
        imageLiked.contentMode = .scaleAspectFit
        imageLiked.tintColor = .white
        imageLiked.isHidden = true
    }
    
    private func setupConstraints() {
        imageLiked.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(5)
            make.height.width.equalTo(17)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: extension Nuke_ImageDisplaying

extension CustomButton: Nuke_ImageDisplaying {
    func nuke_display(image: PlatformImage?) {
        self.setImage(image, for: .normal)
    }
}
