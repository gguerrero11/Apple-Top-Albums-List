//
//  AlbumManager.swift
//  basicAlbum
//
//  Created by Gabe Guerrero on 4/20/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import Foundation
import UIKit

class AlbumManager {
    var albums = [Album]()
    var albumDownloadCallback: (()->Void)?
    
    let albumsURL = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/non-explicit.json"
    
    init() {
        getAlbums()
    }
    
    func getAlbums() {
        if let url = URL(string: albumsURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                self.handleData(data: data)
            }.resume()
        }
    }
    
    func handleData(data: Data?) {
        if let data = data {
            if let jsonString = String(data: data, encoding: .utf8) {
//                print(jsonString)
                handleJSONString(jsonString)
                
            }
        }
    }
    
    func handleJSONString(_ jsonString: String) {
        do {
            let jsonData = jsonString.data(using: .utf8)!
            let response = try JSONDecoder().decode(Response.self, from: jsonData)
            self.albums = response.feed.results
            if let callback = self.albumDownloadCallback {
                callback()
            }
        } catch {
            print(error)
        }
    }
    
    static func cacheImage(image: UIImage, forPath path: String) {
        let imageData = image.jpegData(compressionQuality: 1)
        let relativePath = "image_\(Date.timeIntervalSinceReferenceDate).jpg"
        let cachePath = AlbumManager.documentsPathForFileName(name: relativePath)
        let url = URL(fileURLWithPath: cachePath)
        do {
            try imageData?.write(to: url, options: .atomic)
            UserDefaults.standard.set(relativePath, forKey: path)
            UserDefaults.standard.synchronize()
        } catch {
            print("error caching")
        }
    }
    
    static func getImage(forPath path: String) -> UIImage? {
        var image: UIImage?
        let possibleOldImagePath = UserDefaults.standard.object(forKey: path) as? String
        if let oldImagePath = possibleOldImagePath {
            let oldFullPath = AlbumManager.documentsPathForFileName(name: oldImagePath)
            let url = URL(fileURLWithPath: oldFullPath)
            do {
                let oldImageData = try Data(contentsOf: url)
                image = UIImage(data: oldImageData)
            } catch {
                print("error getting cached Image")
            }
        }
        return image
    }
    
    static func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let fullPath = path.appendingPathComponent(name)
        return fullPath
    }
    
}

struct Response: Codable {
    var feed: Feed
    
    struct Feed: Codable {
        var results: [Album]
    }
}
