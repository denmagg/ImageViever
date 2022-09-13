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
//    var presenter: DetailViewPresenterProtocol!
//    
//    //MARK: override properties
//    
//    override var prefersStatusBarHidden: Bool {
//        return isStatusBarHidden
//    }
//    
//    override var prefersHomeIndicatorAutoHidden: Bool {
//        return isHomeIndicatorAutoHidden
//    }
//    
//    //MARK: private properties
//    
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
//        static let nukeOptionsLightMode = ImageLoadingOptions(
//            placeholder: UIImage(named: "photoLight300x300"),
//            transition: .fadeIn(duration: 0.33),
//            failureImage: UIImage(named: "goforwardLight300x300"),
//            failureImageTransition: .fadeIn(duration: 0.33),
//            contentModes: .init(success: .center, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
//        )
//        
//        static let nukeOptionsDarkMode = ImageLoadingOptions(
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
//        //Рассчет границ safearea
//        //if #available(iOS 13.0, *) {
//        let window = UIApplication.shared.windows.first
//        bottomPadding = window?.safeAreaInsets.bottom
//        print("SAFEAREABOTTOM\(bottomPadding)")
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
//        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
////        self.view.backgroundColor = .green
//        
////        imageScrollView.imageView.snp.makeConstraints { make in
////            make.top.bottom.leading.trailing.equalToSuperview()
////        }
//        
//        presenter.setImage()
//        //MARK: image setted
//        //первый раз при открытии изображения imageSize будет 300x300 - это placeholder,
//        //затем этот же код выполнится в success, где imageSize поменяется на размер изображения
//        //при повторном запуске, изображение будет сеттится сразу без placeholder, тк уже есть в RAM и success не будет срабатывать
//        //при failure размер failureImage == placeholderImage, дополнительное выполнение поиска минимума в case fuilure не требуется
//        setMinMaxZoomScale()
//        imageScrollView.zoomScale = imageScrollView.minimumZoomScale
//    }
//    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            let prevMinZoomScale = self.imageScrollView.minimumZoomScale
//            let prevCurrentZooScale = self.imageScrollView.zoomScale
//            self.setMinMaxZoomScale(isIpad: true)
//            self.imageScrollView.zoomScale = (self.imageScrollView.minimumZoomScale / prevMinZoomScale) * prevCurrentZooScale
//        }
//    }
//    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        
//        //это для того чтобы размеры нав бара не лагали на pro, X, XS (где wC hC в landscape)
//            self.navigationController?.isNavigationBarHidden = !(self.navigationController?.isNavigationBarHidden ?? false)
//            self.navigationController?.isNavigationBarHidden = !(self.navigationController?.isNavigationBarHidden ?? false)
//            
//        let prevMinZoomScale = imageScrollView.minimumZoomScale
//        let prevCurrentZooScale = imageScrollView.zoomScale
//        setMinMaxZoomScale()
//        imageScrollView.zoomScale = (imageScrollView.minimumZoomScale / prevMinZoomScale) * prevCurrentZooScale
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
//        )
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
//    //isIpad - аргумент связанный с тем что traitCollectionDidChange на ipad не вызывается при вовороте экрана
//    private func setMinMaxZoomScale(isIpad: Bool = false) {
//        var screenSize = self.view.frame.size
//        guard var imageSize = self.imageScrollView.imageView.image?.size else { return }
//        
//        if isIpad == true {
//            swap(&screenSize.width, &screenSize.height)
//        }
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
//        
//        let secondMaxScale = minScale * 3
//        if secondMaxScale >= maxScale {
//            self.imageScrollView.maximumZoomScale = secondMaxScale
//        } else {
//            self.imageScrollView.maximumZoomScale = maxScale
//        }
//        
//        let doubleTapZoomingScale = minScale * 2.5
//        if doubleTapZoomingScale >= maxScale {
//            self.imageScrollView.doubleTapZoomingScale = doubleTapZoomingScale
//        } else {
//            self.imageScrollView.doubleTapZoomingScale = self.imageScrollView.maximumZoomScale
//        }
//    }
//    
//    @objc private func didTapOnDescriptionButton(button: UIBarButtonItem) {
//        presenter.tapOnDescription()
//    }
//}
//
////MARK: extension DetailViewProtocol
//
//extension DetailViewController: DetailViewProtocol {
//    func setImage(image: Image?) {
//        print(image?.url)
//        guard let imageUrlString = image?.url,
//            let imageUrl = URL(string: imageUrlString) else { return }
//        
//        let options = Consts.nukeOptions
//        
//        Nuke.loadImage(with: imageUrl,
//                       options: options,
//                       into: imageScrollView.imageView)
//        Nuke.loadImage(with: imageUrl, options: options, into: imageScrollView.imageView) { [weak self] result in
//            switch result {
//            case .success(_):
//                self?.imageScrollView.isUserInteractionEnabled = true
//                self?.setMinMaxZoomScale()
//                guard let minZoomScale = self?.imageScrollView.minimumZoomScale else { return }
//                self?.imageScrollView.zoomScale = minZoomScale
//            case .failure(_):
//                self?.imageScrollView.isUserInteractionEnabled = false
//            }
//        }
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
//        if(self.navigationController?.isNavigationBarHidden ?? true) {
//            imageScrollView.backgroundColor = .black
//        } else {
//            imageScrollView.backgroundColor = nil
//        }
//    }
//    
//    func centerImage() {
//        guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
//        let isPortrait = scene.interfaceOrientation.isPortrait
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
//            //landscape x
//            if frameToCenter.size.width <= boundsSize.width {
//                frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
//            } else {
//                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                    frameToCenter.origin.x = 0 - getNavigationBarHeight() - 12
//                } else {
//                    frameToCenter.origin.x = 0// + getNavigationBarHeight()
//                }
//            }
//        }
//        
//        if isPortrait {
//            //portrait y
//            if frameToCenter.size.height < boundsSize.height {
//                if isStatusBarHidden {
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getNavigationBarHeight()
//                    } else {
//                        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
//                    }
//                } else {
//                    frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getNavigationBarHeight() - getStatusBarHeight()
//                }
//            } else {
//                //тот самый else
//                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                    frameToCenter.origin.y = 0 - getNavigationBarHeight() - getStatusBarHeight()
//                } else {
//                    if isStatusBarHidden {
//                        frameToCenter.origin.y = 0
//                    } else {
//                        frameToCenter.origin.y = 0 - getNavigationBarHeight() - getStatusBarHeight()
//                    }
//                }
//            }
//        } else {
//            if frameToCenter.size.height < boundsSize.height {
//                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                    if isStatusBarHidden {
//                        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getStatusBarHeight()
//                    } else {
//                        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getStatusBarHeight() - getNavigationBarHeight()
//                    }
//                } else {
//                    if isStatusBarHidden {
//                        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
//                    } else {
//                        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getNavigationBarHeight() - getStatusBarHeight()
//                    }
//                }
//            } else {
//                if isStatusBarHidden {
//                    frameToCenter.origin.y = 0
//                } else {
//                    frameToCenter.origin.y = 0 - getNavigationBarHeight() - getStatusBarHeight()
//                }
//            }
//        }
//        
//        guard let imageWidth = imageScrollView.imageView.image?.size.width, let imageHeight = imageScrollView.imageView.image?.size.height else { return }
//            if isPortrait{
//                if isStatusBarHidden {
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight() - 32)//f
//                        print("\(getStatusBarHeight())----s----")
//                        print("\(getNavigationBarHeight())----n----")
//                    } else if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .pad)  {
//                        guard let bottomPadding = bottomPadding else { return }
//                        imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - bottomPadding)
//                        print("getNavigationBarHeight \(getNavigationBarHeight()) getStatusBarHeight \(getStatusBarHeight())")
//                    } else {
//                        imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale)
//                    }
//                } else {
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight() - getStatusBarHeight() - 32)
//                        print("--s---\(getStatusBarHeight())")
//                        print("----n----\(getNavigationBarHeight())")
//                    } else if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .pad) {
//                        guard let bottomPadding = bottomPadding else { return }
//                        imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight() - getStatusBarHeight() - bottomPadding)
//                    } else {
//                        imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight() - getStatusBarHeight())
//                    }
//                }
//            } else {
//                if isStatusBarHidden {
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale - getNavigationBarHeight() * 2 - 22, height: imageHeight * imageScrollView.zoomScale - 21)
//                        print("\(getStatusBarHeight())----s+----")
//                        print("\(getNavigationBarHeight())----n+----")
//                    } else if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .pad) {
//                        guard let bottomPadding = bottomPadding else { return }
//                        imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - bottomPadding)
//                    }
//                } else {
//                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
//                        imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale - getNavigationBarHeight() * 2 - 22, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight() - 21)
//                        print("--s+---\(getStatusBarHeight())")
//                        print("--n+---\(getNavigationBarHeight())")
//                    } else if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .pad) {
//                        guard let bottomPadding = bottomPadding else { return }
//                        imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight() - getStatusBarHeight() - bottomPadding)
//                        print("--s+---\(getStatusBarHeight())")
//                        print("--n+---\(getNavigationBarHeight())")
//                        print(bottomPadding)
//                    } else {
//                        imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight())
//                    }
//                }
//            }
//
//        print("frameToCenter \(frameToCenter)")
//        
//        imageScrollView.imageView.frame = frameToCenter
//        
//    }
//    
//    func scrollViewWillBeginZooming() {
//        if !isStatusBarHidden {
//            didTapOnImageScroollView()
//        }
//    }
//}
//
//
////    //FIXME: сделать рефакторинг, когда разработка завершиться
////    func centerImage() {
////        guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
////        let isPortrait = scene.interfaceOrientation.isPortrait
////
////        let boundsSize = imageScrollView.bounds.size
////        var frameToCenter = imageScrollView.imageView.frame
////
////        if isPortrait {
////            if frameToCenter.size.width < boundsSize.width {
////                frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
////            } else {
////                frameToCenter.origin.x = 0
////            }
////        } else {
////            //landscape x
////            if frameToCenter.size.width <= boundsSize.width {
////                frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
////            } else {
////                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
////                    frameToCenter.origin.x = 0 - getNavigationBarHeight() - 12
////                } else {
////                    frameToCenter.origin.x = 0// + getNavigationBarHeight()
////                }
////            }
////        }
////
////        if isPortrait {
////            //portrait y
////            if frameToCenter.size.height < boundsSize.height {
////                if isStatusBarHidden {
////                    if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
////                        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getNavigationBarHeight()
////                    } else {
////                        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
////                    }
////                } else {
////                    frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getNavigationBarHeight() - getStatusBarHeight()
////                }
////            } else {
////                //тот самый else
////                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
////                    frameToCenter.origin.y = 0 - getNavigationBarHeight() - getStatusBarHeight()
////                } else {
////                    if isStatusBarHidden {
////                        frameToCenter.origin.y = 0
////                    } else {
////                        frameToCenter.origin.y = 0 - getNavigationBarHeight() - getStatusBarHeight()
////                    }
////                }
////            }
////        } else {
////            if frameToCenter.size.height < boundsSize.height {
////                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
////                    if isStatusBarHidden {
////                        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getStatusBarHeight()
////                    } else {
////                        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getStatusBarHeight() - getNavigationBarHeight()
////                    }
////                } else {
////                    if isStatusBarHidden {
////                        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
////                    } else {
////                        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - getNavigationBarHeight() - getStatusBarHeight()
////                    }
////                }
////            } else {
////                if isStatusBarHidden {
////                    frameToCenter.origin.y = 0
////                } else {
////                    frameToCenter.origin.y = 0 - getNavigationBarHeight() - getStatusBarHeight()
////                }
////            }
////        }
////
////        guard let imageWidth = imageScrollView.imageView.image?.size.width, let imageHeight = imageScrollView.imageView.image?.size.height else { return }
////        if isPortrait{
////            if isStatusBarHidden {
////                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
////                    imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight() - 32)//f
////                    print("\(getStatusBarHeight())----s----")
////                    print("\(getNavigationBarHeight())----n----")
////                } else if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .pad)  {
////                    guard let bottomPadding = bottomPadding else { return }
////                    imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - bottomPadding)
////                    print("getNavigationBarHeight \(getNavigationBarHeight()) getStatusBarHeight \(getStatusBarHeight())")
////                } else {
////                    imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale)
////                }
////            } else {
////                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
////                    imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight() - getStatusBarHeight() - 32)
////                    print("--s---\(getStatusBarHeight())")
////                    print("----n----\(getNavigationBarHeight())")
////                } else if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .pad) {
////                    guard let bottomPadding = bottomPadding else { return }
////                    imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight() - getStatusBarHeight() - bottomPadding)
////                } else {
////                    imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight() - getStatusBarHeight())
////                }
////            }
////        } else {
////            if isStatusBarHidden {
////                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
////                    imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale - getNavigationBarHeight() * 2 - 22, height: imageHeight * imageScrollView.zoomScale - 21)
////                    print("\(getStatusBarHeight())----s+----")
////                    print("\(getNavigationBarHeight())----n+----")
////                } else if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .pad) {
////                    guard let bottomPadding = bottomPadding else { return }
////                    imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - bottomPadding)
////                }
////            } else {
////                if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) {
////                    imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale - getNavigationBarHeight() * 2 - 22, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight() - 21)
////                    print("--s+---\(getStatusBarHeight())")
////                    print("--n+---\(getNavigationBarHeight())")
////                } else if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .pad) {
////                    guard let bottomPadding = bottomPadding else { return }
////                    imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight() - getStatusBarHeight() - bottomPadding)
////                    print("--s+---\(getStatusBarHeight())")
////                    print("--n+---\(getNavigationBarHeight())")
////                    print(bottomPadding)
////                } else {
////                    imageScrollView.contentSize = CGSize(width: imageWidth * imageScrollView.zoomScale, height: imageHeight * imageScrollView.zoomScale - getNavigationBarHeight())
////                }
////            }
////        }
////
////        print("frameToCenter \(frameToCenter)")
////
////        imageScrollView.imageView.frame = frameToCenter
////
////    }
