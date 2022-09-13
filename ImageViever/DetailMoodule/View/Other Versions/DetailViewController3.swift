////
////  DetailViewController.swift
////  ImageViever
////
////  Created by Denis Medvedev on 26/10/2021.
////  Copyright © 2021 Denis Medvedev. All rights reserved.
////
//
//import UIKit
//import Nuke
//
//final class DetailViewController: UIViewController, UIScrollViewDelegate {
//    
//    //MARK: properties
//    
//    var prevCenter: CGPoint = CGPoint.zero
//    var presenter: DetailViewPresenterProtocol!
//    
//    //MARK: override properties
//    
//    override var prefersStatusBarHidden: Bool {
//      return isStatusBarHidden
//    }
//    
//    override var prefersHomeIndicatorAutoHidden: Bool {
//        return isHomeIndicatorAutoHidden
//    }
//    
//    //MARK: private properties
//    
//    private var barHeight: CGFloat = CGFloat(0)
//    private var halfNavBarHeight: CGFloat = CGFloat(0)
//    private var bottomPadding: CGFloat?
//    
//    private var imageScrollView: ImageScrollView!
//    
//    private var isStatusBarHidden = false {
//        didSet {
//            setNeedsStatusBarAppearanceUpdate()
//        }
//    }
//    private var isHomeIndicatorAutoHidden = false {
//        didSet {
//            setNeedsUpdateOfHomeIndicatorAutoHidden()
//        }
//    }
//    
//    private enum Consts {
//        static var nukeOptions = ImageLoadingOptions(
//            placeholder: UIImage(systemName: "photoLight300x300"),
//            transition: .fadeIn(duration: 0.33),
//            failureImage: UIImage(systemName: "goforwardLight300x300"),
//            failureImageTransition: .fadeIn(duration: 0.33),
//            contentModes: .init(success: .scaleAspectFit, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
//        )
//        
//        static var nukeOptionsLightMode = ImageLoadingOptions(
//            placeholder: UIImage(named: "photoLight300x300"),
//            transition: .fadeIn(duration: 0.33),
//            failureImage: UIImage(named: "goforwardLight300x300"),
//            failureImageTransition: .fadeIn(duration: 0.33),
//            contentModes: .init(success: .scaleAspectFit, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
//        )
//        
//        static var nukeOptionsDarkMode = ImageLoadingOptions(
//            placeholder: UIImage(named: "photoDark300x300"),
//            transition: .fadeIn(duration: 0.33),
//            failureImage: UIImage(named: "goforwardDark300x300"),
//            failureImageTransition: .fadeIn(duration: 0.33),
//            contentModes: .init(success: .scaleAspectFit, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
//        )
//        
//        enum NavigationItem {
//            enum RightBarButtonItem {
//                static let image = "info.circle"
//            }
//        }
//    }
//    
//    //MARK: lifecycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        imageScrollView = ImageScrollView()
//        imageScrollView.imageScrollViewDelegate = self
//
//        initialize()
//        
//        guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
//        let isPortrait = scene.interfaceOrientation.isPortrait
//        
//        //Рассчет границ safearea
//        //if #available(iOS 13.0, *) {
//        let window = UIApplication.shared.windows.first
//        let topPadding = window?.safeAreaInsets.top
//        bottomPadding = window?.safeAreaInsets.bottom
////        let leftPadding = window?.safeAreaInsets.left
////        let rightPadding = window?.safeAreaInsets.right
//        print("SAFEAREABOTTOM\(bottomPadding)")
//        print("SAFEAREATOP\(topPadding)")
////        print("SAFEAREALEFT\(leftPadding)")
////        print("SAFEAREARIGHT\(rightPadding)")
//        //}
//        
//        //Инф. по отображению изображений на текущей версии констрейнтов
//        //правильное отображение вертикальных высоких, горизонтальных высоких  БЕЗ ЗАКРАШЕНОГО  БАРА
//        //правильное отображение вертикальных  высоких, горизонтальных высоких, обычных iphone 8
//        //правильное отображение вертикальных  высоких, горизонтальных высоких, обычных iphone XS.
////        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
////        self.navigationController?.navigationBar.shadowImage = UIImage()
////        self.navigationController?.navigationBar.isTranslucent = true
////        self.navigationController?.view.backgroundColor = .clear
//        if isPortrait {
//            let screenSize: CGRect = UIScreen.main.bounds
//            print("portrait")
//            
//            barHeight = getStatusBarHeight() + getNavigationBarHeight() - (bottomPadding ?? 0) - (topPadding ?? 0)
//            print("DIFF \(barHeight)")
//            imageScrollView.imageView.snp.makeConstraints { make in
//                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                    make.height.equalToSuperview().inset(32)
//                    make.width.equalToSuperview()
//                    make.centerY.equalTo(self.view.snp.top).inset(screenSize.height / 2)
//                    make.centerX.equalTo(self.view.snp.left).inset(screenSize.width / 2)
//                } else {
//                    make.height.equalToSuperview()
//                    make.width.equalToSuperview()
//                }
//            }
//        } else {
//            let screenSize: CGRect = UIScreen.main.bounds
//            print("landscape")
//            halfNavBarHeight = getNavigationBarHeight()/2
//            print("halfNavBarHeight \(halfNavBarHeight) в лендскейпе")
//            imageScrollView.imageView.snp.makeConstraints { make in
//                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                    make.height.equalToSuperview()//.inset(getNavigationBarHeight())
//                    make.width.equalToSuperview().inset(32)
//                    make.centerY.equalTo(self.view.snp.top).inset(screenSize.height / 2)
//                    make.centerX.equalTo(self.view.snp.left).inset(screenSize.width / 2)
//                } else {
//                    make.height.equalToSuperview()//.inset(getNavigationBarHeight())
//                    make.width.equalToSuperview()
//                }
//            }
//        }
//
//        presenter.setImage()
//    }
//    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        
//        imageScrollView.zoomScale = 1.0
//        
//        if isStatusBarHidden {
//            if UIDevice.current.orientation.isPortrait {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.height.equalToSuperview().inset(32)
//                        make.width.equalToSuperview()
//                    } else {
//                        print("SBHP \(getStatusBarHeight())")
//                    }
//                }
//            } else {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.height.equalToSuperview()
//                        make.width.equalToSuperview().inset(32)
//                    } else {
//                        print("SBHL \(getStatusBarHeight())")
//                    }
//                }
//            }
//        } else {
//            if UIDevice.current.orientation.isPortrait {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.height.equalToSuperview().inset(32)
//                        make.width.equalToSuperview()
//                    } else {
//                        
//                    }
//                }
//            } else {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.height.equalToSuperview()
//                        make.width.equalToSuperview().inset(32)
//                    } else {
//                    
//                    }
//                }
//            }
//        }
//        
//        updateUserInterfaceStyle()
//    }
//    
//    //MARK: methods
//    
//    //MARK: private methods
//    
//    private func getStatusBarHeight() -> CGFloat {
//        var statusBarHeight: CGFloat = 0
//        if #available(iOS 13.0, *) {
//            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//        } else {
//            statusBarHeight = UIApplication.shared.statusBarFrame.height
//        }
//        return statusBarHeight
//    }
//    
//    private func getNavigationBarHeight() -> CGFloat {
//        return (navigationController?.navigationBar.frame.height ?? 0)
//    }
//    
//    private func initialize() {
//        updateUserInterfaceStyle()
//        
//        view.backgroundColor = .systemBackground
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: Consts.NavigationItem.RightBarButtonItem.image),
//            style: .plain,
//            target: self,
//            action: #selector(didTapOnDescriptionButton(button:))
//            )
//        
//        view.addSubview(imageScrollView)
//        imageScrollView.snp.makeConstraints { make in
//            
//        }
//    }
//    
//    private func updateUserInterfaceStyle() {
//        switch traitCollection.userInterfaceStyle {
//        case .light, .unspecified:
//            Consts.nukeOptions = Consts.nukeOptionsLightMode
//            print("light mode detected")
//        case .dark:
//            Consts.nukeOptions = Consts.nukeOptionsDarkMode
//            print("dark mode detected")
//        @unknown default:
//            print("unknown interface mode detected")
//        }
//    }
//    
//    @objc private func didTapOnDescriptionButton(button: UIBarButtonItem) {
//        //FIXME: popover crashes on iPad
//        if UIDevice.current.userInterfaceIdiom != .pad {
//            presenter.tapOnDescription()
//        }
//    }
//}
//
////MARK: extension DetailViewProtocol
//
//extension DetailViewController: DetailViewProtocol {
//    func setImage(image: Image?) {
//        print(image?.url)
//        guard let imageUrlString = image?.url,
//              let imageUrl = URL(string: imageUrlString) else { return }
//        
//        let options = Consts.nukeOptions
//        
//        Nuke.loadImage(with: imageUrl,
//        options: options,
//        into: imageScrollView.imageView)
//        Nuke.loadImage(with: imageUrl, options: options, into: imageScrollView.imageView) { [weak self] result in
//            switch result {
//            case .success(_):
//                self?.imageScrollView.isUserInteractionEnabled = true
//            case .failure(_):
//                self?.imageScrollView.isUserInteractionEnabled = false
//            }
//        }
//    }
//}
//
////FIXME: глянуть откуда я это взял
//extension UIImageView {
//    var contentClippingRect: CGRect {
//        guard let image = image else { return bounds }
//        guard contentMode == .scaleAspectFit else { return bounds }
//        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
//
//        let scale: CGFloat
//        if image.size.width > image.size.height {
//            scale = bounds.width / image.size.width
//        } else {
//            scale = bounds.height / image.size.height
//        }
//
//        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
//        let x = (bounds.width - size.width) / 2.0
//        let y = (bounds.height - size.height) / 2.0
//
//        return CGRect(x: x, y: y, width: size.width, height: size.height)
//    }
//}
//
////MARK: extension ImageScrollViewDelegate
//
//extension DetailViewController: ImageScrollViewDelegate {
//    @objc func didTapOnImageScroollView() {
//        self.navigationController?.isNavigationBarHidden = !(self.navigationController?.isNavigationBarHidden ?? false)
//        isStatusBarHidden = !isStatusBarHidden
//        isHomeIndicatorAutoHidden = !isHomeIndicatorAutoHidden
//        
//        
//        guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
//        let isPortrait = scene.interfaceOrientation.isPortrait
//        if(self.navigationController?.isNavigationBarHidden ?? true) {
//            imageScrollView.backgroundColor = .black
//            if isPortrait {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        
//                        make.height.equalToSuperview().inset(32)
//                        
//                    } else {
//                       
//                    }
//                }
//            } else {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        
//                    } else {
//                       
//                    }
//                }
//            }
//        } else {
//            imageScrollView.backgroundColor = nil
//            if isPortrait {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        
//                        make.height.equalToSuperview().inset(32)
//                    } else {
//                        
//                    }
//                }
//            } else {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                       
//                    } else {
//                        
//                    }
//                }
//            }
//        }
//    }
//    
//    func centerImage() {
//        guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
//               let isPortrait = scene.interfaceOrientation.isPortrait
//        
//        let boundsSize = imageScrollView.bounds.size
//        var frameToCenter = imageScrollView.imageView.frame
//        
//        if isPortrait {
//            if frameToCenter.size.width < boundsSize.width {
//                frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
//            } else {
//                frameToCenter.origin.x = 0
//            }
//        } else {
//            if frameToCenter.size.width < boundsSize.width {
//                if isStatusBarHidden {
//                    frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2// + getNavigationBarHeight()
//                } else {
//                    frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2// + getNavigationBarHeight()
//                }
//            } else {
//                frameToCenter.origin.x = 0 + getNavigationBarHeight()
//            }
//        }
//        
//        if isPortrait {
//            if frameToCenter.size.height < boundsSize.height {
//                if isStatusBarHidden {
//                    frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getNavigationBarHeight()
//                } else {
//                    frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getNavigationBarHeight() - getStatusBarHeight()
//                }
//            } else {
//                frameToCenter.origin.y = 0 - getNavigationBarHeight() - getStatusBarHeight()
//            }
//        } else {
//            if frameToCenter.size.height < boundsSize.height {
//                frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
//            } else {
//                if isStatusBarHidden {
//                    frameToCenter.origin.y = 0
//                } else {
//                    frameToCenter.origin.y = 0 - getNavigationBarHeight() - getStatusBarHeight()
//                }
//            }
//        }
//        
//        imageScrollView.imageView.frame = frameToCenter
//    }
//    
//    func scrollViewWillBeginZooming() {
//        if !isStatusBarHidden {
//            didTapOnImageScroollView()
//        }
//    }
//    
//    func scrollViewDidEndZooming() {
//        let contentSize = imageScrollView.contentSize
//        let imageSize = imageScrollView.imageView.image?.size
//        let imageScale = imageScrollView.imageView.image?.scale
//        let screensize = self.view.frame.size
//        print("imageScrollView content size is \(contentSize)")
//        print("imageScrollView image size is \(String(describing: imageSize))")
//        print("imageScrollView image scale is \(String(describing: imageScale))")
//        print("screen size is \(screensize)")
//        
//        let screenAspectRatio = Float(screensize.width) / Float(screensize.height)
//        let imageAspectRatio = Float(imageSize?.width ?? 0) / Float(imageSize?.height ?? 0)
//        let imageWidth: Float
//        let imageHeight: Float
//        
//        if screenAspectRatio > imageAspectRatio {
//            imageHeight = Float(contentSize.height)
//            imageWidth = imageHeight * imageAspectRatio
//        } else {
//            imageWidth = Float(contentSize.width)
//            imageHeight = imageWidth / imageAspectRatio
//        }
//        
//        print("Calculated imageSize is (\(imageWidth), \(imageHeight))")
//        
//        //если изображение имеет размер по ширине или высоте меньше, чем размер  экрана -
//        //то мы выравниваем его по центру после зума
//        if (imageWidth > Float(screensize.width)) && (imageHeight > Float(screensize.height)) {
//            
//        } else {
//            guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
//            let isPortrait = scene.interfaceOrientation.isPortrait
//            if isPortrait {
//                if imageHeight > Float(screensize.height) {
//                    //portrait phone and vertical image
//                    let contentOffsetToCenterX = (imageScrollView.contentSize.width/2) - (imageScrollView.bounds.size.width/2)
//                    imageScrollView.setContentOffset(CGPoint(x: contentOffsetToCenterX, y: imageScrollView.contentOffset.y), animated: true)
//                } else {
//                    //portrait phone and horisontal image
//                    let contentOffsetToCenterY: CGFloat
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        contentOffsetToCenterY = (imageScrollView.contentSize.height/2) - (imageScrollView.bounds.size.height/2) - 12
//                    } else {
//                        contentOffsetToCenterY = (imageScrollView.contentSize.height/2) - (imageScrollView.bounds.size.height/2)
//                    }
//                    imageScrollView.setContentOffset(CGPoint(x: imageScrollView.contentOffset.x, y: contentOffsetToCenterY), animated: true)
//                }
//            } else {
//                if imageHeight > Float(screensize.height) {
//                    //portrait phone and vertical image
//                    let contentOffsetToCenterX = (imageScrollView.contentSize.width/2) - (imageScrollView.bounds.size.width/2) + 32
//                    imageScrollView.setContentOffset(CGPoint(x: contentOffsetToCenterX, y: imageScrollView.contentOffset.y), animated: true)
//                } else {
//                    //portrait phone and horisontal image
//                    let contentOffsetToCenterY = (imageScrollView.contentSize.height/2) - (imageScrollView.bounds.size.height/2)
//                    imageScrollView.setContentOffset(CGPoint(x: imageScrollView.contentOffset.x, y: contentOffsetToCenterY), animated: true)
//                }
//            }
//        }
//    }
//}
//
