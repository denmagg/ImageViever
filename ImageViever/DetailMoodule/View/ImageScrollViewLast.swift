//
//  ImageScrollView.swift
//  ImageViever
//
//  Created by Denis Medvedev on 27/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import UIKit
import Nuke

@objc protocol ImageScrollViewDelegate {
    func scrollViewWillBeginZooming()
    func centerImage()
    func getScreenSize() -> CGSize
    @objc func didTapOnImageScroollView()
}

final class ImageScrollView: UIScrollView {

    //MARK: properties
    
    var imageView = UIImageView()
    var doubleTapZoomingScale : CGFloat = 1.0
    weak var imageScrollViewDelegate: ImageScrollViewDelegate?

    //MARK: private properties
    
    //single-tap getsure recognizer
    private lazy var singleTapOnImage: UITapGestureRecognizer = {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnImageScroollView))
        singleTap.numberOfTapsRequired = 1
        singleTap.require(toFail: zoomingTapOnImage)
        return singleTap
    }()
    private lazy var singleTapOnImageScrollView: UITapGestureRecognizer = {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnImageScroollView))
        singleTap.numberOfTapsRequired = 1
        return singleTap
    }()
    //double-tap zooming getsure recognizer
    private lazy var zoomingTapOnImage: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()
    
    //MARK: inits

    init() {
        super.init(frame: CGRect.zero)
        self.delegate = self
        
        setupSubviews()
        setupAppearence()
        setupGetsureRecognizers()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: init helpers
    
    private func setupSubviews() {
        self.addSubview(imageView)
    }
    
    private func setupAppearence() {
        self.decelerationRate = .fast
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false

        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .center
    }
    
    private func setupGetsureRecognizers() {
        self.addGestureRecognizer(self.singleTapOnImageScrollView)
        
        imageView.addGestureRecognizer(self.zoomingTapOnImage)
        imageView.addGestureRecognizer(self.singleTapOnImage)
    }
    
    private func setupConstraints() {
        self.imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    //MARK: methods
    
    //MARK: override methods
    
    override func layoutSubviews() {
        //FIXME: колхоз написать почему так
//        let contentOffset = self.contentOffset
        super.layoutSubviews()
//        self.contentOffset = contentOffset
        imageScrollViewDelegate?.centerImage()
    }
    
    //MARK: private methods

    //single tap action
    @objc private func didTapOnImageScroollView() {
        imageScrollViewDelegate?.didTapOnImageScroollView()
        print("1imageScrollView.frame.height \(self.contentSize.height)")
    }

    //double-tap zooming action
    @objc private func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        self.zoom(point: location, maxScale: doubleTapZoomingScale, animated: true)
    }

    //calculating zoooming scale for double-tap zoom
    private func zoom(point: CGPoint, maxScale: CGFloat, animated: Bool) {
        let currectScale = self.zoomScale
        let minScale = self.minimumZoomScale

        if (minScale == maxScale && minScale > 1) {
            return
        }

        let toScale = maxScale
        let finalScale: CGFloat
        if currectScale == minScale {
            finalScale = toScale
        } else {
            finalScale = minScale
        }
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animated)
    }

    //calculating zooming rect for double-tap zoom
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds

        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale

        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
}

//MARK: extension UIScrollViewDelegate

extension ImageScrollView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print(self.zoomScale)
        imageScrollViewDelegate?.centerImage()
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        imageScrollViewDelegate?.scrollViewWillBeginZooming()
    }
}

//MARK: extension Nuke_ImageDisplaying

extension ImageScrollView: Nuke_ImageDisplaying {
    public func nuke_display(image: PlatformImage?) {
        self.imageView.image = image
    }
}

//content size was settting automaticly by Nuke
//content size was adapted to screen dpi
//in iphone XS case it is 3x
//EX: when real image size 300x300 content size will be 100x100
