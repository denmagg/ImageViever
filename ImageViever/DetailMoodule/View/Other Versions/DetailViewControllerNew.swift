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
//            contentModes: .init(success: .center, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
//        )
//        
//        static var nukeOptionsLightMode = ImageLoadingOptions(
//            placeholder: UIImage(named: "photoLight300x300"),
//            transition: .fadeIn(duration: 0.33),
//            failureImage: UIImage(named: "goforwardLight300x300"),
//            failureImageTransition: .fadeIn(duration: 0.33),
//            contentModes: .init(success: .center, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
//        )
//        
//        static var nukeOptionsDarkMode = ImageLoadingOptions(
//            placeholder: UIImage(named: "photoDark300x300"),
//            transition: .fadeIn(duration: 0.33),
//            failureImage: UIImage(named: "goforwardDark300x300"),
//            failureImageTransition: .fadeIn(duration: 0.33),
//            contentModes: .init(success: .center, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
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
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        if isPortrait {
//            print("portrait")
//            barHeight = getStatusBarHeight() + getNavigationBarHeight() - (bottomPadding ?? 0) - (topPadding ?? 0)
//            print("DIFF \(barHeight)")
//            imageScrollView.imageView.snp.makeConstraints { make in
//                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                    print("getNavigationBarHeight() \(getNavigationBarHeight())")
//                    print("getStatusBarHeight() \(getStatusBarHeight())")
//                    make.top.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight())
//                    make.bottom.equalToSuperview().inset(-32)
//                    
//                    make.leading.trailing.equalToSuperview()
//                } else {
//                    make.top.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight())
//                    make.bottom.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight())
//                    make.leading.trailing.equalToSuperview()
//                }
//            }
//        } else {
//            print("landscape")
//            halfNavBarHeight = getNavigationBarHeight()/2
//            print("halfNavBarHeight \(halfNavBarHeight) в лендскейпе")
//            imageScrollView.imageView.snp.makeConstraints { make in
//                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                    make.top.equalToSuperview().inset(-getNavigationBarHeight())
//                    make.bottom.equalToSuperview().inset(-getNavigationBarHeight())
//                    make.leading.equalToSuperview().inset(32)
//                    make.trailing.equalToSuperview()
//                } else {
//                    make.top.equalToSuperview().inset(-getNavigationBarHeight() - getStatusBarHeight())
//                    make.bottom.equalToSuperview().inset(-getNavigationBarHeight() - getStatusBarHeight())
//                    make.leading.trailing.equalToSuperview()
//                }
//            }
//        }
//
//        presenter.setImage()
//        //MARK: image setted
//        //первый раз при открытии изображения imageSize будет 300x300 - это placeholder,
//        //затем этот же код выполнится в success, где imageSize поменяется на размер изображения
//        //при повторном запуске, изображение будет сеттится сразу без placeholder, тк уже есть в RAM и success не будет срабатывать
//        //при failure размер failureImage == placeholderImage, дополнительное выполнение поиска минимума в case fuilure не требуется
//        setMinMaxZoomScale()
//        imageScrollView.zoomScale = imageScrollView.minimumZoomScale
//        
////        //только для вертикальных
////        //надо вспомнить с какого момента изображения урезаются по высоте
//        print("minimum zoom scale is \(self.imageScrollView.minimumZoomScale)")
//        //print("screenSize is \(screenSize)")
//        //print("imageSize is \(imageSize)")
//
//    }
//    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        
//        let prevMinZoomScale = imageScrollView.minimumZoomScale
//        let prevCurrentZooScale = imageScrollView.zoomScale
//        setMinMaxZoomScale()
//        imageScrollView.zoomScale = (imageScrollView.minimumZoomScale / prevMinZoomScale) * prevCurrentZooScale
//        
//        if isStatusBarHidden {
//            if UIDevice.current.orientation.isPortrait {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.top.equalToSuperview().inset(-12)
//                        make.bottom.equalToSuperview().inset(-32)
//                        make.leading.equalToSuperview()
//                    } else {
//                        print("SBHP \(getStatusBarHeight())")
//                        make.top.equalToSuperview().inset(-getStatusBarHeight())
//                        make.bottom.equalToSuperview().inset(-getStatusBarHeight())
//                    }
//                }
//            } else {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.top.equalToSuperview()
//                        //это шоб не дрыгалось вверх-вниз при смене на лендскейп с выключеным статусбаром
//                        make.bottom.equalToSuperview().inset(-32) //FIXME: inset bottom landscape padding
//                        make.leading.equalToSuperview().inset(32)
//                    } else {
//                        print("SBHL \(getStatusBarHeight())")
//                        make.top.equalToSuperview().inset(-getStatusBarHeight())
//                        make.bottom.equalToSuperview().inset(-getStatusBarHeight())
//                    }
//                }
//            }
//        } else {
//            if UIDevice.current.orientation.isPortrait {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.top.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight() + 32)
//                        make.bottom.equalToSuperview().inset(-32)
//                        make.leading.equalToSuperview()
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
//                        make.leading.equalToSuperview().inset(32)
//                    } else {
//                        make.top.equalToSuperview().inset(-getNavigationBarHeight() - getStatusBarHeight())
//                        make.bottom.equalToSuperview().inset(-getNavigationBarHeight() - getStatusBarHeight())
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
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(self.view.snp.top)
//            make.bottom.equalTo(self.view.snp.bottom)
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
//    private func setMinMaxZoomScale() {
////        var screenSize = startScreenSize
//        var screenSize = self.view.frame.size
//        guard let imageSize = self.imageScrollView.imageView.image?.size else { return }
//        
//        guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
//        let isPortrait = scene.interfaceOrientation.isPortrait
//        
//        let window = UIApplication.shared.windows.first
//        bottomPadding = window?.safeAreaInsets.bottom
//        
//        if isPortrait {
//            if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) && ((imageSize.width / imageSize.height) <= 0.45) {
//                screenSize.height -= 64 //70 не шевелится
//            }
//        } else {
//            if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) && ((imageSize.height / imageSize.width) <= 0.45) {
//                screenSize.width -= 64 //70
//            }
//        }
//        
//        let xScale = screenSize.width / imageSize.width
//        let yScale = screenSize.height / imageSize.height
//        
//        let minScale = min(xScale, yScale)
//        let maxScale = max(xScale, yScale)
//        
//        self.imageScrollView.minimumZoomScale = minScale
//        //self.imageScrollView.zoomScale = minScale
//        
//        let secondMaxScale = minScale * 3
//        if secondMaxScale >= maxScale {
//            self.imageScrollView.maximumZoomScale = secondMaxScale
//        } else {
//            self.imageScrollView.maximumZoomScale = maxScale
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
//                //FIXME: убрать форс
//                self?.imageScrollView.isUserInteractionEnabled = true
//                self?.setMinMaxZoomScale()
//                guard let minZoomScale = self?.imageScrollView.minimumZoomScale else { return }
//                self?.imageScrollView.zoomScale = minZoomScale
//            case .failure(_):
//                self?.imageScrollView.isUserInteractionEnabled = false
//////                self?.imageScrollView.contentMode = .scaleAspectFit
//////                self?.imageScrollView.imageView.contentMode = .scaleAspectFit
////                print("КОНТЕНТ МОДЫ ИС ИМ")
////                print("\(self?.imageScrollView.contentMode.rawValue), \(self?.imageScrollView.imageView.contentMode.rawValue)")
////                //self?.imageScrollView.zoomScale = screensize!.height / imageSize!.height
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
//    func getScreenSize() -> CGSize {
//        return self.view.frame.size
//    }
//    
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
//                        make.top.equalToSuperview().inset(-12-32)
//                        make.bottom.equalToSuperview().inset(-32)
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
//            imageScrollView.backgroundColor = nil
//            if isPortrait {
//                imageScrollView.imageView.snp.updateConstraints { make in
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        make.top.equalToSuperview().inset(-getNavigationBarHeight()-getStatusBarHeight())
//                        make.bottom.equalToSuperview().inset(-32)
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
//        let screenSize = self.view.frame.size
//        var frameToCenter = imageScrollView.imageView.frame
////        print("screensize \(screenSize)")
////        print("boundsSize \(boundsSize)")
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
//        //MARK: остановился тут
//        if isPortrait {
//            if frameToCenter.size.height < boundsSize.height {
//                if isStatusBarHidden {
//                    frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getNavigationBarHeight() //+ 14
//                } else {
//                    frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getNavigationBarHeight() - getStatusBarHeight() //+ 14
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
//    }
//}
//
