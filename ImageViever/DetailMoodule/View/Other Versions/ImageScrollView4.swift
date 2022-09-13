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
//    var imageView = UIImageView()
//    var imageScrollViewDelegate: ImageScrollViewDelegate?
//
//    lazy var singleTap: UITapGestureRecognizer = {
//        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnImageScroollView))
//        singleTap.numberOfTapsRequired = 1
//        singleTap.require(toFail: zoomingTap)
//        return singleTap
//    }()
//
//    lazy var zoomingTap: UITapGestureRecognizer = {
//        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
//        zoomingTap.numberOfTapsRequired = 2
//        return zoomingTap
//    }()
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
//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//        imageScrollViewDelegate?.scrollViewWillBeginZooming()
//    }
//
//    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        imageScrollViewDelegate?.scrollViewDidEndZooming()
//    }
//
//    private func initialize() {
//        self.delegate = self
//
//        self.addSubview(imageView)
//        self.minimumZoomScale = 1.0
//        self.maximumZoomScale = 3.0
////        self.maximumZoomScale = 2.715
////        self.maximumZoomScale = 2.5
//
//        self.backgroundColor = .green
//
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(self.zoomingTap)
//        imageView.addGestureRecognizer(self.singleTap)
//
//        //тут надо пошаманить
////        imageView.contentMode = .scaleAspectFill
//    }
//
//    // gesture
//    @objc func didTapOnImageScroollView() {
//        imageScrollViewDelegate?.didTapOnImageScroollView()
//    }
//
//    @objc func handleZoomingTap(sender: UITapGestureRecognizer) {
//        let location = sender.location(in: sender.view)
//        self.zoom(point: location, animated: true)
//    }
//
//    func zoom(point: CGPoint, animated: Bool) {
//        let currectScale = self.zoomScale
//        let minScale = self.minimumZoomScale
//        let maxScale: CGFloat = 2.5
//
//        if (minScale == maxScale && minScale > 1) {
//            return
//        }
//        print("point\(point)")
//
//        let toScale = maxScale
//        let finalScale: CGFloat
//        if currectScale == minScale {
//            finalScale = toScale
//        } else {
//            finalScale = minScale
//        }
//        //let finalScale = (currectScale == minScale) ? toScale : minScale
//        let zoomRect = self.zoomRect(scale: finalScale, center: point)
//        self.zoom(to: zoomRect, animated: animated)
//
//    }
//
//    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
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
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//
//            imageScrollViewDelegate?.centerImage()
//    }
//
//
//}
//
//extension ImageScrollView: UIScrollViewDelegate {
//    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.imageView
//    }
//
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        print(self.zoomScale)
//
//
//            imageScrollViewDelegate?.centerImage()
//
//    //        print(self.contentSize)
//        }
//}
//
//extension ImageScrollView: Nuke_ImageDisplaying {
//    public func nuke_display(image: PlatformImage?) {
//        self.imageView.image = image
//    }
//}
//
