//
//  GalleryViewController.swift
//  ImageViever
//
//  Created by Denis Medvedev on 25/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import SnapKit
import UIKit
import Nuke

class GalleryViewController: UIViewController {
    
    var presenter: GalleryPresenterProtocol!
    var tableView = UITableView()
    
    let options = ImageLoadingOptions(
        placeholder: UIImage(systemName: "photo"), transition: .fadeIn(duration: 0.33), failureImage: UIImage(systemName: "goforward"), failureImageTransition: .fadeIn(duration: 0.33), contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        AppUtility.lockOrientation(.portrait)
//        // Or to rotate and lock
//        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Don't forget to reset when view is being removed
//        AppUtility.lockOrientation(.all)
//    }
    
    private func initialize() {
        view.backgroundColor = .white
        navigationItem.title = "Gallery APP"
        
        //tableView.frame = self.view.frame
        tableView.backgroundColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(GalleryViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension GalleryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.images?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GalleryViewCell
        
        //!!!Может ли интерфейс хранить модель?
        //если удалось получить Image из массива
//        guard let firstImage = presenter.images?[indexPath.row * 3],
//        let middleImage = presenter.images?[(indexPath.row * 3) + 1],
//        let lastImage = presenter.images?[(indexPath.row * 3) + 2] else { return cell }
        
        let firstImageId = indexPath.row * 3
        let middleImageId = (indexPath.row * 3) + 1
        let lastImageId = (indexPath.row * 3) + 2
        
        //и если удалось извлечь дату этого изображения
        //устанавливаем изображение по urlString
        //replaced by Nuke
//        presenter.getData(from: presenter.images?[firstImageId].thumbnailUrl) { (data) in
//            DispatchQueue.main.async {
//                //cell.firstImageButton.setBackgroundImage(UIImage(data: data), for: .normal)
//                cell.firstImageButton.setImage(UIImage(data: data), for: .normal)
//                //cell.firstImageButton.contentVerticalAlignment = .fill
//                //cell.firstImageButton.contentHorizontalAlignment = .fill
//                //cell.firstImageButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 1)
//                cell.firstImageButton.imgId = firstImageId
//                cell.firstImageButton.addTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
//            }
//        }
//        presenter.getData(from: presenter.images?[middleImageId].thumbnailUrl) { (data) in
//            DispatchQueue.main.async {
//                //cell.middleImageButton.setBackgroundImage(UIImage(data: data), for: .normal)
//                cell.middleImageButton.setImage(UIImage(data: data), for: .normal)
//                //cell.middleImageButton.contentVerticalAlignment = .fill
//                //cell.middleImageButton.contentHorizontalAlignment = .fill
//                //cell.middleImageButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
//                cell.middleImageButton.imgId = middleImageId
//                cell.middleImageButton.addTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
//            }
//        }
//        presenter.getData(from: presenter.images?[lastImageId].thumbnailUrl) { (data) in
//            DispatchQueue.main.async {
//                //cell.lastImageButton.setBackgroundImage(UIImage(data: data), for: .normal)
//                cell.lastImageButton.setImage(UIImage(data: data), for: .normal)
//                //cell.lastImageButton.contentVerticalAlignment = .fill
//                //cell.lastImageButton.contentHorizontalAlignment = .fill
//                //cell.lastImageButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 0)
//                cell.lastImageButton.imgId = lastImageId
//                cell.lastImageButton.addTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
//            }
//        }
        
        cell.firstImageButton.imgId = firstImageId
        cell.firstImageButton.addTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
        
        cell.middleImageButton.imgId = middleImageId
        cell.middleImageButton.addTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
        
        cell.lastImageButton.imgId = lastImageId
        cell.lastImageButton.addTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
        
//        MARK: Nuke
        Nuke.loadImage(with: URL(string: (presenter.images?[firstImageId].thumbnailUrl)!)!,
                       options: options,
                       into: cell.firstImageButton)
        
        Nuke.loadImage(with: URL(string: (presenter.images?[middleImageId].thumbnailUrl)!)!,
                       options: options,
                       into: cell.middleImageButton)
        
        Nuke.loadImage(with: URL(string: (presenter.images?[lastImageId].thumbnailUrl)!)!,
        options: options,
        into: cell.lastImageButton)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width / 3
    }
    
    @objc func buttonTapped(button: CustomButton) {
        print(button.imgId)
        presenter.tapOnTheImage(imageId: button.imgId)
    }
    
    
}

extension GalleryViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

extension GalleryViewController: GalleryViewProtocol {
    func success() {
        tableView.reloadData()
    }
    
    func failture(error: Error) {
        print(error.localizedDescription)
    }
}

//extension GalleryViewController: buttonDelegate {
//    func didSelect(button: UIButton) {
//        presenter.tapOnTheImage(image: button.image)
//    }
//}

