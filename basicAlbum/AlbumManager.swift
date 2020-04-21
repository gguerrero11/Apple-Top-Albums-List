//
//  AlbumManager.swift
//  basicAlbum
//
//  Created by Gabe Guerrero on 4/20/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import Foundation

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
}

struct Response: Codable {
    var feed: Feed
    
    struct Feed: Codable {
        var results: [Album]
    }
}
