//
//  DetailViewController.swift
//  ImageViever
//
//  Created by Denis Medvedev on 26/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import UIKit
import Nuke

final class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: properties
    
    var presenter: DetailViewPresenterProtocol!
    
    //MARK: override properties
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return isHomeIndicatorAutoHidden
    }
    
    //MARK: private properties
    
    var bottomPadding: CGFloat?
    
    var imageScrollView: ImageScrollView!
    
    var toolBar: UIToolbar!
    
    var isStatusBarHidden = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    var isHomeIndicatorAutoHidden = false {
        didSet {
            setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
    }
    
    enum Consts {
        static var nukeOptions = ImageLoadingOptions(
            placeholder: UIImage(systemName: "photoLight300x300"),
            transition: .fadeIn(duration: 0.33),
            failureImage: UIImage(systemName: "goforwardLight300x300"),
            failureImageTransition: .fadeIn(duration: 0.33),
            contentModes: .init(success: .center, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
        )
        
        static let nukeOptionsLightMode = ImageLoadingOptions(
            placeholder: UIImage(named: "photoLight300x300"),
            transition: .fadeIn(duration: 0.33),
            failureImage: UIImage(named: "goforwardLight300x300"),
            failureImageTransition: .fadeIn(duration: 0.33),
            contentModes: .init(success: .center, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
        )
        
        static let nukeOptionsDarkMode = ImageLoadingOptions(
            placeholder: UIImage(named: "photoDark300x300"),
            transition: .fadeIn(duration: 0.33),
            failureImage: UIImage(named: "goforwardDark300x300"),
            failureImageTransition: .fadeIn(duration: 0.33),
            contentModes: .init(success: .center, failure: .scaleAspectFit, placeholder: .scaleAspectFit)
        )
        
        enum NavigationItem {
            enum RightBarButtonItem {
                static let image = "info.circle"
            }
        }
        
        enum TabBarItems {
            static let shareTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "square.and.arrow.up"), tag: 0)
            static let likeTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart"), tag: 1)
            static let likedTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart.fill"), tag: 1)
            static let deleteTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "trash"), tag: 2)
            static let playTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "play.fill"), tag: 3)
            static let pauseTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "pause.fill"), tag: 3)
            static let soundOffTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "speaker.slash.fill"), tag: 4)
            static let soundOnTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "speaker.2.fill"), tag: 4)
            static let emptyTabBarItem = UITabBarItem(title: nil, image: nil, tag: 5)
        }
        
        enum ToolBarItems {
            static let shareToolBarItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(didTapOnShareButton))
            static let likeToolBarItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapOnLikeButton))
            static let likedToolBarItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(didTapOnLikeButton))
            static let deleteToolBarItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(didTapOnDeleteButton))
            static let flexibleSpaceToolBarItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
        
        enum SharedButton {
            static let shareByLinkToast = "link copied"
        }
        
        enum DeleteButton {
            static let deleteTitle = "Delete Photo"
            static let cancelTitle = "Cancel"
        }
    }
    
    //MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        configurateNavigationBar()
        configurateToolBar()
        configurateImageScrollView()
        configurateView()
        setupConstraints()
        tabBarController?.tabBar.isHidden = true
        updateUserInterfaceStyle()
        //setupNavBarInDevMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        self.view.layoutIfNeeded()
        tabBarController?.tabBar.isHidden = true
//        self.view.updateConstraintsIfNeeded()
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.userInterfaceIdiom == .pad {
            recalculateZoomingScales(isPadTransition: true)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        reloadNavigationBar()
        recalculateZoomingScales()
        updateUserInterfaceStyle()
    }
    
    //MARK: viewDidLoadHelpers helpers
    
    private func setupSubviews() {
        imageScrollView = ImageScrollView()
        toolBar = UIToolbar()
        
        view.addSubview(imageScrollView)
        view.addSubview(toolBar)
    }
    
    private func configurateNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: Consts.NavigationItem.RightBarButtonItem.image),
            style: .plain,
            target: self,
            action: #selector(didTapOnDescriptionButton(button:))
        )
    }
    
    private func configurateToolBar() {
        toolBar.setItems([Consts.ToolBarItems.shareToolBarItem,
                          Consts.ToolBarItems.flexibleSpaceToolBarItem,
                          Consts.ToolBarItems.likeToolBarItem,
                          Consts.ToolBarItems.flexibleSpaceToolBarItem,
                          Consts.ToolBarItems.deleteToolBarItem], animated: false)
    }
    
    private func setupConstraints() {
        imageScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        toolBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    private func configurateImageScrollView() {
        imageScrollView.imageScrollViewDelegate = self
        
        //Рассчет границ safearea (if #available(iOS 13.0, *) {)
        let window = UIApplication.shared.windows.first
        bottomPadding = window?.safeAreaInsets.bottom
        print("SAFEAREABOTTOM\(bottomPadding)")
        
        presenter.setImage()
        //первый раз при открытии изображения imageSize будет 300x300 - это placeholder,
        //затем этот же код выполнится в success, где imageSize поменяется на размер изображения
        //при повторном запуске, изображение будет сеттится сразу без placeholder, тк уже есть в RAM и success не будет срабатывать
        //при failure размер failureImage == placeholderImage, дополнительное выполнение поиска минимума в case fuilure не требуется
        setMinMaxZoomScale()
        imageScrollView.zoomScale = imageScrollView.minimumZoomScale
    }
    
    private func configureAppearenceNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let barAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = barAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
    }
    
    private func configurateView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavBarInDevMode() {
        //Инф. по отображению изображений на текущей версии констрейнтов
        //правильное отображение вертикальных высоких, горизонтальных высоких  БЕЗ ЗАКРАШЕНОГО  БАРА
        //правильное отображение вертикальных  высоких, горизонтальных высоких, обычных iphone 8
        //правильное отображение вертикальных  высоких, горизонтальных высоких, обычных iphone XS.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.view.backgroundColor = .green
    }
    
    //MARK: methods
    
    //MARK: private methods
    
    //это для того чтобы размеры нав бара не лагали на pro, X, XS (где wC hC в landscape) - при смене ориентации и скрытом navBar его размер не обновляется
    private func reloadNavigationBar() {
        if self.navigationController?.isNavigationBarHidden ?? true {
            self.navigationController?.isNavigationBarHidden = !(self.navigationController?.isNavigationBarHidden ?? false)
            self.navigationController?.isNavigationBarHidden = !(self.navigationController?.isNavigationBarHidden ?? false)
        }
    }
    
    private func reloadToolBar() {
        self.toolBar.isHidden = self.toolBar.isHidden
        self.toolBar.isHidden = self.toolBar.isHidden
    }
    
    private func recalculateZoomingScales(isPadTransition: Bool = false) {
        let prevMinZoomScale = self.imageScrollView.minimumZoomScale
        let prevCurrentZooScale = self.imageScrollView.zoomScale
        self.setMinMaxZoomScale(isPadTransition: isPadTransition)
        self.imageScrollView.zoomScale = (self.imageScrollView.minimumZoomScale / prevMinZoomScale) * prevCurrentZooScale
    }

    private func updateUserInterfaceStyle() {
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            Consts.nukeOptions = Consts.nukeOptionsLightMode
            print("light mode detected")
        case .dark:
            Consts.nukeOptions = Consts.nukeOptionsDarkMode
            print("dark mode detected")
        @unknown default:
            print("unknown interface mode detected")
        }
    }
    
    //isPadTransition - аргумент связанный с тем что traitCollectionDidChange на ipad не вызывается при вовороте экрана
    //и тк вызывается только willTransition мы должны исскуственно поменять высоту и ширину местами, тк они еще не поменялись по факту
    func setMinMaxZoomScale(isPadTransition: Bool = false) {
        var screenSize = self.view.frame.size
        guard var imageSize = self.imageScrollView.imageView.image?.size else { return }
        
        if isPadTransition == true {
            swap(&screenSize.width, &screenSize.height)
        }
        
        guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
        let isPortrait = scene.interfaceOrientation.isPortrait
        
        let window = UIApplication.shared.windows.first
        bottomPadding = window?.safeAreaInsets.bottom
        
        if isPortrait {
            if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) && ((imageSize.width / imageSize.height) <= 0.45) {
                screenSize.height -= 64 //70 не шевелится
            }
        } else {
            if (bottomPadding != 0) && (UIDevice.current.userInterfaceIdiom == .phone) && ((imageSize.height / imageSize.width) <= 0.45) {
                screenSize.width -= 64 //70
            }
        }
        
        let xScale = screenSize.width / imageSize.width
        let yScale = screenSize.height / imageSize.height
        
        let minScale = min(xScale, yScale)
        let maxScale = max(xScale, yScale)
        
        self.imageScrollView.minimumZoomScale = minScale
        
        let secondMaxScale = minScale * 3
        if secondMaxScale >= maxScale {
            self.imageScrollView.maximumZoomScale = secondMaxScale
        } else {
            self.imageScrollView.maximumZoomScale = maxScale
        }
        
        let doubleTapZoomingScale = minScale * 2.5
        if doubleTapZoomingScale >= maxScale {
            self.imageScrollView.doubleTapZoomingScale = doubleTapZoomingScale
        } else {
            self.imageScrollView.doubleTapZoomingScale = self.imageScrollView.maximumZoomScale
        }
    }
    
    @objc private func didTapOnDescriptionButton(button: UIBarButtonItem) {
        presenter.tapOnDescription()
    }
    
    @objc func didTapOnShareButton() {
        UIPasteboard.general.string = presenter.tapOnShare()
        showToast(message: Consts.SharedButton.shareByLinkToast)
    }
    //FIXME
    @objc func didTapOnLikeButton() {
        if presenter.tapOnLike() != nil {
            toolBar.items?[2] = Consts.ToolBarItems.likedToolBarItem
        } else {
            toolBar.items?[2] = Consts.ToolBarItems.likeToolBarItem
        }
    }
    
    @objc func didTapOnDeleteButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: Consts.DeleteButton.deleteTitle, style: .destructive , handler:{ (UIAlertAction)in
            self.navigationController?.navigationBar.isHidden = false
            self.presenter.goBack()
        })
        let cancelAction = UIAlertAction(title: Consts.DeleteButton.cancelTitle, style: .cancel, handler:{ (UIAlertAction)in
            print("User click Cancel button")
        })
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}
