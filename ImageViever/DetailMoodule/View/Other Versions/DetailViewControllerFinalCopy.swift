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
//        let viewH = Float(self.view.frame.size.height) - 88 - 88
//        let viewW = Float(self.view.frame.size.width)
//        print("ВЫСОТА\(viewH)")
//        print("ШИРИНА\(viewW)")
//        //if #available(iOS 13.0, *) {
//        let window = UIApplication.shared.windows.first
//        let topPadding = window?.safeAreaInsets.top
//        bottomPadding = window?.safeAreaInsets.bottom
//        let leftPadding = window?.safeAreaInsets.left
//        let rightPadding = window?.safeAreaInsets.right
//        print("SAFEAREABOTTOM\(bottomPadding)")
//        print("SAFEAREATOP\(topPadding)")
//        print("SAFEAREALEFT\(leftPadding)")
//        print("SAFEAREARIGHT\(rightPadding)")
//        //}
//        
//        //правильное отображение вертикальных высоких, горизонтальных высоких  БЕЗ ЗАКРАШЕНОГО  БАРА
//        //правильное отображение вертикальных  высоких, горизонтальных высоких, обычных iphone 8
//        //правильное отображение вертикальных  высоких, горизонтальных высоких, обычных iphone XS. Высокий имадж  на 2 пикселя меньше, чем в галерее
//        //Если открыть закоменченый  топ, то будет как в галерее, но почему -2.
//        //Единственная  зацепка landscape, size of bar: getStatusBarHeight is 0.0 getNavigationBarHeight is 32.0
//        //Но это ленскейпная ориентация
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        if isPortrait {
//            print("portrait")
//            //barHeight = getStatusBarHeight() - getNavigationBarHeight()/4
//            barHeight = getStatusBarHeight() + getNavigationBarHeight() - (bottomPadding ?? 0) - (topPadding ?? 0)
//            print("DIFF \(barHeight)")
//            imageScrollView.imageView.snp.makeConstraints { make in
//                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                    make.top.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight() + 32)
//                    //make.top.equalToSuperview().inset(-CGFloat(bottomPadding ?? 0) - CGFloat(topPadding ?? 0)/2)
//                    make.bottom.equalToSuperview().inset(-32)
//                    make.height.equalToSuperview().inset(32)
//                    make.leading.trailing.width.equalToSuperview()
//                } else {
//                    make.top.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight())
//                    make.bottom.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight())
//                    make.height.equalToSuperview()
//                    make.leading.trailing.width.equalToSuperview()
//                }
//            }
//        } else {
//            print("landscape")
//            halfNavBarHeight = getNavigationBarHeight()/2
//            print("halfNavBarHeight \(halfNavBarHeight) сука в лендскейпе")
//            imageScrollView.imageView.snp.makeConstraints { make in
//                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                    make.top.equalToSuperview().inset(-getNavigationBarHeight())
//                    make.bottom.equalToSuperview().inset(-getNavigationBarHeight())
//                    make.height.equalToSuperview()//.inset(getNavigationBarHeight())
//                    make.leading.equalToSuperview().inset(32)
//                    make.trailing.equalToSuperview()
//                    make.width.equalToSuperview().inset(32)
//                } else {
//                    make.top.equalToSuperview().inset(-getNavigationBarHeight() - getStatusBarHeight())
//                    make.bottom.equalToSuperview().inset(-getNavigationBarHeight() - getStatusBarHeight())
//                    make.height.equalToSuperview()//.inset(getNavigationBarHeight())
//                    make.leading.trailing.width.equalToSuperview()
//                }
//            }
//        }
//        
//        //imageScrollView.setup()
//
//        presenter.setImage()
//        
//        print("imHEI\(imageScrollView.imageView.image?.size.height)")
//        // Do any additional setup after loading the view.
//    }
//    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        
//        imageScrollView.zoomScale = 1.0
//        
//        print("imHEI\(imageScrollView.imageView.image?.size.height)")
//        print("imWID\(imageScrollView.imageView.image?.size.width)")
//        
//        //centerImage()
//
//        if isStatusBarHidden {
//            if UIDevice.current.orientation.isPortrait {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.top.equalToSuperview().inset(-12)
//                        make.bottom.equalToSuperview().inset(-32)
//                        make.height.equalToSuperview().inset(32)
//                        make.leading.width.equalToSuperview()
////                        make.trailing.equalToSuperview()
//                    } else {
//                        print("SBHP \(getStatusBarHeight())")
//                        make.top.equalToSuperview().inset(-getStatusBarHeight())
//                        make.bottom.equalToSuperview().inset(-getStatusBarHeight())
////                        make.height.equalToSuperview()
////                        make.leading.trailing.width.equalToSuperview()
//                    }
//                }
//            } else {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.top.equalToSuperview()
//                        make.bottom.equalToSuperview().inset(-32) //FIXME: inset bottom landscape padding
//                        make.height.equalToSuperview()
//                        make.leading.equalToSuperview().inset(32)
////                        make.trailing.equalToSuperview()
//                        make.width.equalToSuperview().inset(32)
//                    } else {
//                        print("SBHL \(getStatusBarHeight())")
//                        make.top.equalToSuperview().inset(-getStatusBarHeight())
//                        make.bottom.equalToSuperview().inset(-getStatusBarHeight())
////                        make.height.equalToSuperview()
////                        make.leading.trailing.width.equalToSuperview()
//                    }
//                }
//            }
//        } else {
//            if UIDevice.current.orientation.isPortrait {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.top.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight() + 32)
//                        make.bottom.equalToSuperview().inset(-32)
//                        make.height.equalToSuperview().inset(32)
//                        make.leading.width.equalToSuperview()
////                        make.trailing.equalToSuperview()
//                    } else {
//                        make.top.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight())
//                        make.bottom.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight())
////                        make.height.equalToSuperview()
////                        make.leading.trailing.width.equalToSuperview()
//                    }
//                }
//            } else {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.top.equalToSuperview().inset(-getNavigationBarHeight())
//                        make.bottom.equalToSuperview().inset(-getNavigationBarHeight())
//                        make.height.equalToSuperview()
//                        make.leading.equalToSuperview().inset(32)
////                        make.trailing.equalToSuperview()
//                        make.width.equalToSuperview().inset(32)
//                    } else {
//                        make.top.equalToSuperview().inset(-getNavigationBarHeight() - getStatusBarHeight())
//                        make.bottom.equalToSuperview().inset(-getNavigationBarHeight() - getStatusBarHeight())
////                        make.height.equalToSuperview()
////                        make.leading.trailing.width.equalToSuperview()
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
//            print("going")
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(self.view.snp.top)
//            make.bottom.equalTo(self.view.snp.bottom)
//        }
//
////        self.imageScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImageScroollView)))
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
//    
//    
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
//extension DetailViewController: ImageScrollViewDelegate {
//    @objc func didTapOnImageScroollView() {
//        self.navigationController?.isNavigationBarHidden = !(self.navigationController?.isNavigationBarHidden ?? false)
//        isStatusBarHidden = !isStatusBarHidden
//        isHomeIndicatorAutoHidden = !isHomeIndicatorAutoHidden
//        
//        guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
//        let isPortrait = scene.interfaceOrientation.isPortrait
//        if(self.navigationController?.isNavigationBarHidden ?? true) {
//            if isPortrait {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.top.equalToSuperview().inset(-12)
//                        make.bottom.equalToSuperview().inset(-32)
//                        make.height.equalToSuperview().inset(32)
//                        
//                    } else {
//                        make.top.equalToSuperview().inset(-getStatusBarHeight())
//                        make.bottom.equalToSuperview().inset(-getStatusBarHeight()) //MARK: не шевелится на iPad/XS Важно (когда сначала выключаешь NB а потом делаешь поворот в лендскейп)
//                    }
//                }
//            } else {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.top.equalToSuperview()
//                        make.bottom.equalToSuperview().inset(-getNavigationBarHeight())
//                    } else {
//                        make.top.equalToSuperview().inset(-getStatusBarHeight())
//                        make.bottom.equalToSuperview().inset(-getStatusBarHeight())
//                    }
//                }
//            }
//        } else {
//            if isPortrait {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.top.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight() + 32)
//                        make.bottom.equalToSuperview().inset(-32)
//                        make.height.equalToSuperview().inset(32)
//                    } else {
//                        make.top.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight())
//                        make.bottom.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight())
//                    }
//                }
//            } else {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.top.equalToSuperview().inset(-getNavigationBarHeight())
//                        make.bottom.equalToSuperview().inset(-getNavigationBarHeight())
//                    } else {
//                        make.top.equalToSuperview().inset(-getNavigationBarHeight() - getStatusBarHeight())
//                        make.bottom.equalToSuperview().inset(-getNavigationBarHeight() - getStatusBarHeight())
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
//                //            frameToCenter.origin.y = 0
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
//        print("imageScrollView image size is \(imageSize ?? nil)")
//        print("imageScrollView image scale is \(imageScale ?? nil)")
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
//        //MARK: ебать
////        imageScrollView.imageView.snp.updateConstraints { make in
////            make.height.equalTo(imageHeight)
////            make.width.equalTo(imageWidth)
////        }
//        
//        if (imageWidth > Float(screensize.width)) && (imageHeight > Float(screensize.height)) {
////            guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
////            let isPortrait = scene.interfaceOrientation.isPortrait
////
////            //portrait phone and vertical image
////            //calculate CGPoints
////            //левая граница по x
////            let contentOffsetToCenterX = (imageScrollView.contentSize.width/2) - (imageScrollView.bounds.size.width/2) - CGFloat(imageWidth / 2)
////
////            //левая граница по y
////            let contentOffsetToCenterY = (imageScrollView.contentSize.height/2) - (imageScrollView.bounds.size.height/2) - CGFloat(imageHeight / 2)
////
////            let currentX = imageScrollView.contentOffset.x
////            let currentY = imageScrollView.contentOffset.y
////
////            print("currentX \(currentX) leftX corner \(contentOffsetToCenterX)")
////            print("currentY \(currentY) leftY corner \(contentOffsetToCenterY)")
////
//////            if isPortrait {
//////                //portrait phone and vertical image
//////                //let contentOffsetToCenterX = (imageScrollView.contentSize.width/2) - (imageScrollView.bounds.size.width/2) - imageWidth / 2
//////            } else {
//////
//////            }
//        } else {
//            guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
//            let isPortrait = scene.interfaceOrientation.isPortrait
//            if isPortrait {
//                if imageHeight > Float(screensize.height) {
//                    //portrait phone and vertical image
//                    let contentOffsetToCenterX = (imageScrollView.contentSize.width/2) - (imageScrollView.bounds.size.width/2)
//                    imageScrollView.setContentOffset(CGPoint(x: contentOffsetToCenterX, y: imageScrollView.contentOffset.y), animated: true)
//                    
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
////        imageScrollView.flag = false
//    }
//}
