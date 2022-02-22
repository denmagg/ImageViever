//
//  GalleryViewControllerExtensions.swift
//  ImageViever
//
//  Created by Denis Medvedev on 08/02/2022.
//  Copyright © 2022 Denis Medvedev. All rights reserved.
//

import UIKit
import Nuke

//MARK: extension UITableViewDataSource

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
        
        func loadImage(with url: URL, and id: Int, in customButton: CustomButton) {
            customButton.imgId = id
            customButton.addTarget(self, action: #selector(self.didTapOnImageButton(button:)), for: .touchUpInside)
            
            func checkIsImageLiked(in button: CustomButton) {
                if button.imgId != nil {
                    if presenter.images?[button.imgId!].liked == true {
                        button.imageLiked.isHidden = false
                    }
                } else {
                    //FIXME: так, тут пофиксить до конца
                    button.removeTarget(self, action: #selector(self.didTapOnImageButton(button:)), for: .touchUpInside)
                    button.setImage(nil, for: .normal)
                }
            }
            
            Nuke.loadImage(with: url,
                           options: Consts.nukeOptions,
                           into: customButton) { result in
                            switch result {
                            case .success(_):
                                checkIsImageLiked(in: customButton)
                            case .failure(_):
                                break
                            }
            }
        }
        
        func removeImage(from customButton: CustomButton) {
            customButton.removeTarget(self, action: #selector(self.didTapOnImageButton(button:)), for: .touchUpInside)
            customButton.setImage(nil, for: .normal)
            customButton.imgId = nil
        }
        
        // загрузка картинок при условии, что имеется картинка с данным индексом (1 картинка будет всегда, даже в самом низу, тк кол-во сторочек numberOfRowsInSection рассчитано на это)
        if let firstImageUrlString = (presenter.images?[firstImageId].thumbnailUrl), let firstImageUrl = URL(string: firstImageUrlString) {
            loadImage(with: firstImageUrl, and: firstImageId, in: cell.firstImageButton)
            if (presenter.images?.indices.contains(middleImageId))!,
                let middleImageUrlString = (presenter.images?[middleImageId].thumbnailUrl),
                let middleImageUrl = URL(string: middleImageUrlString) {
                loadImage(with: middleImageUrl, and: middleImageId, in: cell.middleImageButton)
                if (presenter.images?.indices.contains(lastImageId))!,
                    let lastImageUrlString = (presenter.images?[lastImageId].thumbnailUrl),
                    let lastImageUrl = URL(string: lastImageUrlString) {
                    loadImage(with: lastImageUrl, and: lastImageId, in: cell.lastImageButton)
                    return cell
                } else {
                    // FIXME: почему-то изображение ремувится только после повторной загрузки ячейки
                    removeImage(from: cell.lastImageButton)
                    return cell
                }
            } else {
                removeImage(from: cell.lastImageButton)
                removeImage(from: cell.middleImageButton)
                return cell
            }
        } else {
            removeImage(from: cell.lastImageButton)
            removeImage(from: cell.middleImageButton)
            removeImage(from: cell.firstImageButton)
            return cell
        }
    }
}

//MARK: extension UITableViewDelegate

extension GalleryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width / 3
    }
}

//MARK: extension GalleryViewProtocol

extension GalleryViewController: GalleryViewProtocol {
    func success() {
        tableView.reloadData()
        if presenter.images?.count == 0 {
            noPhotosLabel.isHidden = false
            tableView.isScrollEnabled = false
        } else {
            noPhotosLabel.isHidden = true
        }
    }
    
    func failture(error: Error) {
        showAlert(title: Consts.Alert.title, message: error.localizedDescription)
        print(error.localizedDescription)
    }
}

//MARK: extension Allert

extension GalleryViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Consts.Alert.actionTitle, style: .default) { _ in
            self.presenter.getImages()
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
}
