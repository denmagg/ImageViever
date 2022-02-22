//
//  NetworkService.swift
//  ImageViever
//
//  Created by Denis Medvedev on 25/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getImages(complition: @escaping (Result<[Image]?, NetworkError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    //MARK: private properties
    
    private enum Consts {
        //static let urlString = "https://gist.githubusercontent.com/denmagg/0ed8be348e7ff54189d9d147d6ea5b81/raw/2a90817c1dc6839772833200bbb40be028f658e4/JSONDataNotLikedAll.json"
        static let urlString = "https://gist.githubusercontent.com/denmagg/ac6a6e1742f878d34cf7087294992d92/raw/cc5df262b8c0f0050991494c851e54976b3f7f87/JSONData.json"
        static let fileName = "JSONData.json"
    }
    
    //MARK: methods
    
    func getImages(complition: @escaping (Result<[Image]?, NetworkError>) -> Void) {
        let urlString = Consts.urlString
        
        //path for the simulator for debugging
//        let filePath: URL? = URL(fileURLWithPath: "/Users/denis/Desktop/SwiftProjects/ImageViever/ImageViever/GalleryModule/Model/JSONData.json")
        
        //path for the application to work
        var filePath = URL(string: "")
        do {
            filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: .none, create: false).appendingPathComponent(Consts.fileName)
        } catch {
            print(error)
        }
        
        guard let url = URL(string: urlString) else { return }

        func getLocalData(failure reason: NetworkError) {
            do {
                if let filePath = filePath {
                    let fileData = try Data(contentsOf: filePath)
                    let fileObj = try JSONDecoder().decode([Image].self, from: fileData)
                    complition(.success(fileObj))
                }
            } catch {
                complition(.failure(reason))
            }
        }

        //Если мы подключены к интернету, то обновляем данные по ссылке, поскольку мы могли заменить JSON объект или он мог обновиться
        //Если интернета нет все что мы можем сделать это доставать картинки из того JSON файла который у нас есть
        //print(NetworkMonitor.shared.isConnected)
        if NetworkMonitor.shared.isConnected {
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let _ = error {
                    //Если не удалось получить доступ к url дергаем лок файл
                    //Если данные не удалось декодировать с сервера и при этом их нет на лок файле, то сервер не отвечает и кеша у нас нет
                    getLocalData(failure: .serverError)
                    return
                }
                
                //Если на сервере нет данных - дергаем с лок файла
                guard let data = data else {
                    getLocalData(failure: .serverError)
                    return
                }

                do {
                    //Если данные удалось  декодировать с сервера, то записываем их в локальный файл и выводим
                    let obj = try JSONDecoder().decode([Image].self, from: data)

                    do {
                        if let filePath = filePath {
                            try data.write(to: filePath)
                        }
                    }
                    catch {
//                        print("Failed to write JSON data: \(error.localizedDescription)")
                        complition(.failure(.failedToWriteData))
                    }

                    complition(.success(obj))
                } catch {
                    print(error)
                    //Если данные не удалось декодировать с сервера (например сервер не отвечает, а интернет подключение есть) то дергаем их из лок файла
                    //Если данные не удалось декодировать с сервера и при этом их нет на лок файле, то на сервере содержатся не те данные и кеша у нас нет
                    getLocalData(failure: .serverError)
                }
            }.resume()
        } else {
            getLocalData(failure: .noConnection)
        }
    }
}
