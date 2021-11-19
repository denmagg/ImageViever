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

final class GalleryViewController: UIViewController {
    
    var presenter: GalleryPresenterProtocol!
    private var tableView = UITableView()
    
    private let options = ImageLoadingOptions(
        placeholder: UIImage(systemName: "photo"),
        transition: .fadeIn(duration: 0.33),
        failureImage: UIImage(systemName: "goforward"),
        failureImageTransition: .fadeIn(duration: 0.33),
        contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do any additional setup after loading the view.
    }
    
    private func initialize() {
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
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
        
        tableView.register(GalleryViewCell.self, forCellReuseIdentifier: String(describing: GalleryViewCell.self))
    }
}

extension GalleryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows: Double = Double(presenter.images?.count ?? 0)/3
        return Int(numberOfRows.rounded(.up))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GalleryViewCell.self), for: indexPath) as! GalleryViewCell
        
        let firstImageId = indexPath.row * 3
        let middleImageId = (indexPath.row * 3) + 1
        let lastImageId = (indexPath.row * 3) + 2
        
//        MARK: Nuke
        guard (presenter.images?.indices.contains(firstImageId))!,
            let firstImageUrlString = (presenter.images?[firstImageId].thumbnailUrl),
            let firstImageUrl = URL(string: firstImageUrlString) else {
                cell.firstImageButton.removeTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
                // FIXME: почему-то изображение ремувится только после повторной загрузки ячейки
                cell.firstImageButton.setImage(nil, for: .normal)
                return cell
        }
        
        cell.firstImageButton.imgId = firstImageId
        cell.firstImageButton.addTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
        
        Nuke.loadImage(with: firstImageUrl,
                       options: options,
                       into: cell.firstImageButton)
        
        guard (presenter.images?.indices.contains(middleImageId))!,
            let middleImageUrlString = (presenter.images?[middleImageId].thumbnailUrl),
            let secondImageUrl = URL(string: middleImageUrlString) else {
                cell.middleImageButton.removeTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
                cell.middleImageButton.setImage(nil, for: .normal)
                return cell
                
        }
        
        cell.middleImageButton.imgId = middleImageId
               cell.middleImageButton.addTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
        
        Nuke.loadImage(with: secondImageUrl,
                       options: options,
                       into: cell.middleImageButton)
        
        guard (presenter.images?.indices.contains(lastImageId))!,
            let lastImageUrlString = (presenter.images?[lastImageId].thumbnailUrl),
            let lastImageUrl = URL(string: lastImageUrlString) else {
                cell.lastImageButton.removeTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
                cell.lastImageButton.setImage(nil, for: .normal)
                return cell
        }
        
        cell.lastImageButton.imgId = lastImageId
        cell.lastImageButton.addTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
        
        Nuke.loadImage(with: lastImageUrl,
                       options: options,
                       into: cell.lastImageButton)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width / 3
    }
    
    @objc private  func buttonTapped(button: CustomButton) {
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
        showAlert(title: "Error", message: error.localizedDescription)
        print(error.localizedDescription)
    }
}

//MARK: Allert
extension GalleryViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.presenter.getImages()
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
}

