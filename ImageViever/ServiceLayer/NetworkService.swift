//
//  NetworkService.swift
//  ImageViever
//
//  Created by Denis Medvedev on 25/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getImages(complition: @escaping (Result<[Image]?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func getImages(complition: @escaping (Result<[Image]?, Error>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/photos"
        let filePath = URL(fileURLWithPath: "/Users/denis/Desktop/SwiftProjects/ImageViever/ImageViever/GalleryModule/Model/JSONData.txt")
        guard let url = URL(string: urlString) else { return }
        
        //Если мы подключены к интернету, то обновляем данные по ссылке, поскольку мы могли заменить JSON объект или он мог обновиться
        //Если интернета нет все что мы можем сделать это доставать картинки из того JSON файла который у нас есть
        if NetworkMonitor.shared.isConnected {
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    complition(.failure(error))
                    return
                }
                
                //print(String(decoding: data!, as: UTF8.self))
                
                do {
                    try data!.write(to: filePath)
                }
                catch {
                    print("Failed to write JSON data: \(error.localizedDescription)")
                }
                
                do {
                    let obj = try? JSONDecoder().decode([Image].self, from: data!)
                    complition(.success(obj))
                } catch {
                    complition(.failure(error))
                }
            }.resume()
        } else {
            do {
                let fileData = try Data(contentsOf: filePath)
                let fileObj = try JSONDecoder().decode([Image].self, from: fileData)
                complition(.success(fileObj))
            } catch {
                complition(.failure(error))
                //print(error)
            }
        }
    }
}
