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
    //var img: Image?
    var imgId: Int?
    
    init() {
        super.init(frame: CGRect.zero)
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomButton: Nuke_ImageDisplaying {
    func nuke_display(image: PlatformImage?) {
        self.setImage(image, for: .normal)
    }
}
