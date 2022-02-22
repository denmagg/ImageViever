//
//  GalleryViewCell.swift
//  ImageViever
//
//  Created by Denis Medvedev on 25/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import SnapKit
import UIKit

final class GalleryViewCell: UITableViewCell {
    
    //MARK: properties
    
    var firstImageButton = CustomButton()
    var middleImageButton = CustomButton()
    var lastImageButton = CustomButton()
    
    //MARK: private properties
    private enum Consts {
        enum FirstImageButton {
            static let imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 1)
        }
        enum MiddleImageButton {
            static let imageEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        }
        enum LastImageButton {
            static let imageEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 0)
        }
    }
    
    //MARK: inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        configurateButtons()
        setupConstraints()
        
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init helpers
    
    private func setupSubviews() {
        addSubview(firstImageButton)
        addSubview(middleImageButton)
        addSubview(lastImageButton)
    }
    
    private func setupConstraints() {
        firstImageButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.bottom.leading.equalToSuperview()
            make.size.width.equalTo(firstImageButton.snp.height)
        }
        
        lastImageButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.bottom.trailing.equalToSuperview()
            make.size.width.equalTo(lastImageButton.snp.height)
        }
        
        middleImageButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.size.width.equalTo(middleImageButton.snp.height)
        }
    }
    
    private func configurateButtons() {
        firstImageButton.imageView?.contentMode = .scaleAspectFill
        lastImageButton.imageView?.contentMode = .scaleAspectFill
        middleImageButton.imageView?.contentMode = .scaleAspectFill
        
        firstImageButton.imageEdgeInsets = Consts.FirstImageButton.imageEdgeInsets
        middleImageButton.imageEdgeInsets = Consts.MiddleImageButton.imageEdgeInsets
        lastImageButton.imageEdgeInsets = Consts.LastImageButton.imageEdgeInsets
    }
    
    override func prepareForReuse() {
        firstImageButton.imageLiked.isHidden = true
        middleImageButton.imageLiked.isHidden = true
        lastImageButton.imageLiked.isHidden = true
    }
    
}
