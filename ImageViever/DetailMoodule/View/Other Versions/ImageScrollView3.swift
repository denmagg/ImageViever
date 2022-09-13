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
//@objc protocol ImageScrollViewDelegate {
//    func scrollViewWillBeginZooming()
//    func scrollViewDidEndZooming()
//    func centerImage()
//    @objc func didTapOnImageScroollView()
//}
//
//final class ImageScrollView: UIScrollView {
//
//    //MARK: properties
//    
//    var imageView = UIImageView()
//    var imageScrollViewDelegate: ImageScrollViewDelegate?
//
//    //MARK: private properties
//    
//    //single-tap getsure recognizer
//    private lazy var singleTap: UITapGestureRecognizer = {
//        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnImageScroollView))
//        singleTap.numberOfTapsRequired = 1
//        singleTap.require(toFail: zoomingTap)
//        return singleTap
//    }()
//    //double-tap zooming getsure recognizer
//    private lazy var zoomingTap: UITapGestureRecognizer = {
//        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
//        zoomingTap.numberOfTapsRequired = 2
//        return zoomingTap
//    }()
//    
//    //MARK: inits
//
//    init() {
//        super.init(frame: CGRect.zero)
//        initialize()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: methods
//
//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//        imageScrollViewDelegate?.scrollViewWillBeginZooming()
//    }
//
//    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        imageScrollViewDelegate?.scrollViewDidEndZooming()
//    }
//    
//    //срабатывает, когда заканчивается анимация
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        imageScrollViewDelegate?.scrollViewDidEndZooming()
//    }
//    
//    //срабатывает, когда отпускаешь палец, если  нет анимации
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        imageScrollViewDelegate?.scrollViewDidEndZooming()
//    }
//    
//    //MARK: override methods
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        if self.zoomScale < 1.0 {
//            imageScrollViewDelegate?.centerImage()
//        }
//    }
//    
//    //MARK: private methods
//
//    private func initialize() {
//        self.delegate = self
//
//        self.addSubview(imageView)
//        self.minimumZoomScale = 1.0
//        self.maximumZoomScale = 3.0
//        self.decelerationRate = .fast
//        self.showsVerticalScrollIndicator = false
//        self.showsHorizontalScrollIndicator = false
//
//        //self.backgroundColor = .green
//
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(self.zoomingTap)
//        imageView.addGestureRecognizer(self.singleTap)
//    }
//
//    //single tap action
//    @objc private func didTapOnImageScroollView() {
//        imageScrollViewDelegate?.didTapOnImageScroollView()
//    }
//
//    //double-tap zooming action
//    @objc private func handleZoomingTap(sender: UITapGestureRecognizer) {
//        let location = sender.location(in: sender.view)
//        self.zoom(point: location, animated: true)
//    }
//
//    //calculating zoooming scale for double-tap zoom
//    private func zoom(point: CGPoint, animated: Bool) {
//        let currectScale = self.zoomScale
//        let minScale = self.minimumZoomScale
//        let maxScale: CGFloat = 2.5
//
//        if (minScale == maxScale && minScale > 1) {
//            return
//        }
//
//        let toScale = maxScale
//        let finalScale: CGFloat
//        if currectScale == minScale {
//            finalScale = toScale
//        } else {
//            finalScale = minScale
//        }
//        let zoomRect = self.zoomRect(scale: finalScale, center: point)
//        self.zoom(to: zoomRect, animated: animated)
//    }
//
//    //calculating zooming rect for double-tap zoom
//    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
//        var zoomRect = CGRect.zero
//        let bounds = self.bounds
//
//        zoomRect.size.width = bounds.size.width / scale
//        zoomRect.size.height = bounds.size.height / scale
//
//        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
//        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
//        return zoomRect
//    }
//}
//
////MARK: extension UIScrollViewDelegate
//
//extension ImageScrollView: UIScrollViewDelegate {
//    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.imageView
//    }
//
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        print(self.zoomScale)
//
//        if self.zoomScale <= 1.0 {
//            imageScrollViewDelegate?.centerImage()
//            self.isScrollEnabled = false
//        } else {
//            self.isScrollEnabled = true
//        }
//    }
//}
//
////MARK: extension Nuke_ImageDisplaying
//
//extension ImageScrollView: Nuke_ImageDisplaying {
//    public func nuke_display(image: PlatformImage?) {
//        self.imageView.image = image
//    }
//}
