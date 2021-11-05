//
//  GalleryViewCell.swift
//  ImageViever
//
//  Created by Denis Medvedev on 25/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import SnapKit
import UIKit

//protocol buttonDelegate {
//    func didSelect(button: UIButton)
//}

class GalleryViewCell: UITableViewCell {
    
    //var buttonDelegate: buttonDelegate?
    
    var firstImageButton = CustomButton()
    var middleImageButton = CustomButton()
    var lastImageButton = CustomButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //let sizeOfImage = (superview?.frame.size.width)! / 3
        
        //let sizeOfImage = superview?.snp.height
        
        addSubview(firstImageButton)
        addSubview(middleImageButton)
        addSubview(lastImageButton)
        
        firstImageButton.imageView?.contentMode = .scaleAspectFill
        
        firstImageButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.bottom.leading.equalToSuperview()
            make.size.width.equalTo(firstImageButton.snp.height)
        }

        lastImageButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.bottom.trailing.equalToSuperview()
            make.size.width.equalTo(firstImageButton.snp.height)
        }
        
        middleImageButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.size.width.equalTo(middleImageButton.snp.width)
        }
        
        firstImageButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 1)
        middleImageButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        lastImageButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 0)

        
//        firstImageButton.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
//        middleImageButton.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
//        lastImageButton.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
    
        // Configure the view for the selected state
    }
    
//    @objc func buttonPressed(button: UIButton) {
//        print()
//        //buttonDelegate?.didSelect(button: button)
//    }

}

