//
//  Album.swift
//  basicAlbum
//
//  Created by Gabe Guerrero on 4/20/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import Foundation
import UIKit

struct Album: Codable {
    var artistName: String?
    var releaseDate: String?
    var name: String?
    var copyright: String?
    var imageURL: String?
    var genres: [String]?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case artistName     = "artistName"
        case releaseDate    = "releaseDate"
        case name           = "name"
        case copyright      = "copyright"
        case imageURL       = "artworkUrl100"
        case genres         = "genres"
        case artistUrl      = "artistUrl"
    }
    
    init(from decoder: Decoder) throws {
        
    }
    
    func encode(to encoder: Encoder) throws {
        
    }

}

/* Sample JSON
 
 "artistName":"Harry Styles",
 "id":"1485802965",
 "releaseDate":"2019-12-13",
 "name":"Fine Line",
 "kind":"album",
 "copyright":"℗ 2019 Erskine Records Limited, under exclusive license to Columbia Records, a Division of Sony Music Entertainment",
 "artistId":"471260289",
 "artistUrl":"https://music.apple.com/us/artist/harry-styles/471260289?app=music",
 "artworkUrl100":"https://is4-ssl.mzstatic.com/image/thumb/Music113/v4/72/89/85/728985d1-9484-7b71-1ea8-0f0654f7dc16/886448022213.jpg/200x200bb.png",
 "genres":[
     {
         "genreId":"14",
         "name":"Pop",
         "url":"https://itunes.apple.com/us/genre/id14"
     },
     {
         "genreId":"34",
         "name":"Music",
         "url":"https://itunes.apple.com/us/genre/id34"
     }
 ],
 "url":"https://music.apple.com/us/album/fine-line/1485802965?app=music"
 
 */
