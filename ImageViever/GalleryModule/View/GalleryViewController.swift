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
        
        tableView.register(GalleryViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension GalleryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.images?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GalleryViewCell
        
        let firstImageId = indexPath.row * 3
        let middleImageId = (indexPath.row * 3) + 1
        let lastImageId = (indexPath.row * 3) + 2
        
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

