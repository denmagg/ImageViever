//
//  DetailViewControllerLastExtensions.swift
//  ImageViever
//
//  Created by Denis Medvedev on 09/02/2022.
//  Copyright © 2022 Denis Medvedev. All rights reserved.
//

import UIKit
import Nuke

//MARK: extension DetailViewProtocol

extension DetailViewController: DetailViewProtocol {
    func setImage(image: Image?) {
        print(image?.url)
        guard let imageUrlString = image?.url,
            let imageUrl = URL(string: imageUrlString) else { return }
        
        let options = Consts.nukeOptions
        
        Nuke.loadImage(with: imageUrl,
                       options: options,
                       into: imageScrollView.imageView)
        Nuke.loadImage(with: imageUrl, options: options, into: imageScrollView.imageView) { [weak self] result in
            switch result {
            case .success(_):
                self?.imageScrollView.isUserInteractionEnabled = true
                self?.setMinMaxZoomScale()
                guard let minZoomScale = self?.imageScrollView.minimumZoomScale else { return }
                self?.imageScrollView.zoomScale = minZoomScale
            case .failure(_):
                self?.imageScrollView.isUserInteractionEnabled = false
            }
        }
    }
}

//MARK: extension ImageScrollViewDelegate

extension DetailViewController: ImageScrollViewDelegate {
    func getScreenSize() -> CGSize {
        return self.view.frame.size
    }
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    func getNavigationBarHeight() -> CGFloat {
        return (navigationController?.navigationBar.frame.height ?? 0)
    }
    
    @objc func didTapOnImageScroollView() {
        self.navigationController?.isNavigationBarHidden = !(self.navigationController?.isNavigationBarHidden ?? false)
        isStatusBarHidden = !isStatusBarHidden
        toolBar.isHidden = !toolBar.isHidden
        isHomeIndicatorAutoHidden = !isHomeIndicatorAutoHidden
        
        if(self.navigationController?.isNavigationBarHidden ?? true) {
            imageScrollView.backgroundColor = .black
        } else {
            imageScrollView.backgroundColor = nil
        }
    }
    
    func centerImage() {
        let boundsSize = imageScrollView.bounds.size
        var frameToCenter = imageScrollView.imageView.frame
        
        //функции центровки изображния по осям координат
        func centerX(inset: CGFloat = 0) {
            if frameToCenter.size.width < boundsSize.width {
                frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2 - inset
            } else {
                frameToCenter.origin.x = 0 - inset
            }
        }
        
        func centerY(inset: CGFloat = 0) {
            if frameToCenter.size.height < boundsSize.height {
                frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - inset
            } else {
                frameToCenter.origin.y = 0 - inset
            }
        }
        
        //функция для корректировки размера контента scroollView
        func setContentSize(insetX: CGFloat = 0, insetY: CGFloat = 0) {
            guard let imageWidth = imageScrollView.imageView.image?.size.width, let imageHeight = imageScrollView.imageView.image?.size.height else { return }
            imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale - insetX, height: imageHeight * imageScrollView.zoomScale - insetY)
        }
        
        //функция оцентровки изображения с опциональным инсетом, для обхода появления наследующегося от navigationController navigationBar
        func center(navBarInset: CGFloat = 0) {
            if bottomPadding != 0 && UIDevice.current.userInterfaceIdiom == .phone {
                guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
                let isPortrait = scene.interfaceOrientation.isPortrait
                
                if isPortrait {
                    centerX()
                    centerY(inset: getNavigationBarHeight() + navBarInset)
                    setContentSize(insetY: (getNavigationBarHeight() + (bottomPadding ?? 0) + navBarInset))
                } else {
                    //внимание константа связана с тем, что на XS, 11pro navBarHeight in landscape is 32, а нужна длина portrait navBarHeight, которая равна 44, для того чтобы сдвинуть фрейм и уменьшить contentSize также как в портретном режиме. Данный промежуточный инсет смягчает переход к inset = 44, когда ширина изображения немного превышает ширину экрана.
                    //на iphone mini данная константа не проверена.
                    let sizeDifference = imageScrollView.imageView.frame.width - self.view.frame.size.width
                    var inset: CGFloat = 44
                    if sizeDifference > 0 {
                        if sizeDifference <= inset {
                            inset = sizeDifference
                        }
                    } else {
                        inset = 0
                    }
                    
                    centerX(inset: inset)
                    centerY(inset: navBarInset)
                    if sizeDifference > inset * 2 {
                        setContentSize(insetX: inset * 2, insetY: (bottomPadding ?? 0) + navBarInset)
                    } else if sizeDifference > inset {
                        setContentSize(insetX: inset, insetY: (bottomPadding ?? 0) + navBarInset)
                    } else {
                        setContentSize(insetY: (bottomPadding ?? 0) + navBarInset)
                    }
                }
            } else {
                centerX()
                centerY(inset: getStatusBarHeight() + navBarInset)
                
                setContentSize(insetY: getStatusBarHeight() + (bottomPadding ?? 0) + navBarInset)
            }
        }
        
        if isStatusBarHidden {
            center()
        } else {
            center(navBarInset: getNavigationBarHeight())
        }

        imageScrollView.imageView.frame = frameToCenter
    }
    
    func scrollViewWillBeginZooming() {
        if !isStatusBarHidden {
            didTapOnImageScroollView()
        }
    }
}

//MARK: extension Toast

extension DetailViewController {
    func showToast(message: String) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 3;
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        self.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        toastLabel.snp.makeConstraints { make in
            make.centerX.equalTo(toastContainer.snp.centerXWithinMargins)
            make.bottom.equalTo(toastContainer.snp.bottom).inset(5)
            make.top.equalTo(toastContainer.snp.top).inset(5)
        }

        toastContainer.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(toastLabel.snp.width).multipliedBy(1.2)
            make.bottom.equalTo(self.toolBar.snp.top).inset(-5)
        }

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
