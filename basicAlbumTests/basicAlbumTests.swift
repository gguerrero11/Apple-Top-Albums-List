//
//  basicAlbumTests.swift
//  basicAlbumTests
//
//  Created by Gabe Guerrero on 4/20/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import XCTest
@testable import basicAlbum

class basicAlbumTests: XCTestCase {
    var manager: AlbumManager?
    
    let jsonString = """
    {
    "feed":{
        "title":"Top Albums",
        "id":"https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/non-explicit.json",
        "author":{
        "name":"iTunes Store",
        "uri":"http://wwww.apple.com/us/itunes/"
        },
        "links":[],
        "copyright":"Copyright 2018 Apple Inc. Alle Rechte vorbehalten.",
        "country":"us",
        "icon":"http://itunes.apple.com/favicon.ico",
        "updated":"2020-04-20T03:09:42.000-07:00",
        "results":[
            {
            "artistName":"Fiona Apple",
            "id":"1507811635",
            "releaseDate":"2020-04-17",
            "name":"Fetch The Bolt Cutters",
            "kind":"album",
            "copyright":"℗ 2020 Epic Records, a division of Sony Music Entertainment",
            "artistId":"466131",
            "artistUrl":"https://music.apple.com/us/artist/fiona-apple/466131?app=music",
            "artworkUrl100":"https://is2-ssl.mzstatic.com/image/thumb/Music123/v4/d7/35/0d/d7350da2-70a2-22d6-20fb-514fbf05d0df/886448398486.jpg/200x200bb.png",
            "genres":[
                {
                    "genreId":"20",
                    "name":"Alternative",
                    "url":"https://itunes.apple.com/us/genre/id20"
                },
                {
                    "genreId":"34",
                    "name":"Music",
                    "url":"https://itunes.apple.com/us/genre/id34"
                }
            ],
            "url":"https://music.apple.com/us/album/fetch-the-bolt-cutters/1507811635?app=music"
            },
        }
    }
    """
    
    override func setUp() {
        manager = AlbumManager()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        manager = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImageCaching() {
        guard let image = UIImage(systemName: "photo") else { return }
        let time = Date.timeIntervalSinceReferenceDate
        let mockKey = "hourglass\(time).jpg"
        XCTAssertNotNil(image)
        AlbumManager.cacheImage(image: image, forKey: mockKey)
        let retrievedImage = AlbumManager.getImage(forKey: mockKey)
        XCTAssertNotNil(retrievedImage)
    }
    
    func testHandleJSONString() {
        manager?.albums = []
        manager?.title = ""
        guard let manager = manager else { return }
        manager.albumDownloadCallback = {
            XCTAssert(manager.title == "Top Albums")
            XCTAssert(!manager.albums.isEmpty)
            guard let albumMock = manager.albums.first else { return }
            XCTAssert(albumMock.artistName == "Fiona Apple")
            XCTAssert(albumMock.releaseDate == "2020-04-17")
            XCTAssert(albumMock.name == "Fetch The Bolt Cutters")
            XCTAssert(albumMock.copyright == "℗ 2020 Epic Records, a division of Sony Music Entertainment")
            XCTAssert(albumMock.imageURL == "https://is2-ssl.mzstatic.com/image/thumb/Music123/v4/d7/35/0d/d7350da2-70a2-22d6-20fb-514fbf05d0df/886448398486.jpg/200x200bb.png")
            XCTAssert(albumMock.artistUrl == "https://music.apple.com/us/artist/fiona-apple/466131?app=music")
            
            guard let genres = manager.albums.first?.genres else { return }
            XCTAssert(!genres.isEmpty)
            XCTAssert(genres[0].name == "Alternative")
            XCTAssert(genres[1].name == "Music")
        }
    
        manager.handleJSONString(jsonString)
    }
    
    func testHandleData() {
        manager?.albums = []
        manager?.title = ""
        guard let manager = manager else { return }
        manager.albumDownloadCallback = {
            XCTAssert(manager.title == "Top Albums")
            XCTAssert(!manager.albums.isEmpty)
            guard let albumMock = manager.albums.first else { return }
            XCTAssert(albumMock.artistName == "Fiona Apple")
            XCTAssert(albumMock.releaseDate == "2020-04-17")
            XCTAssert(albumMock.name == "Fetch The Bolt Cutters")
            XCTAssert(albumMock.copyright == "℗ 2020 Epic Records, a division of Sony Music Entertainment")
            XCTAssert(albumMock.imageURL == "https://is2-ssl.mzstatic.com/image/thumb/Music123/v4/d7/35/0d/d7350da2-70a2-22d6-20fb-514fbf05d0df/886448398486.jpg/200x200bb.png")
            XCTAssert(albumMock.artistUrl == "https://music.apple.com/us/artist/fiona-apple/466131?app=music")
            
            guard let genres = manager.albums.first?.genres else { return }
            XCTAssert(!genres.isEmpty)
            XCTAssert(genres[0].name == "Alternative")
            XCTAssert(genres[1].name == "Music")
        }
        
        let jsonData = jsonString.data(using: .utf8)
        manager.handleData(data: jsonData)
    }
    
    func testGetAlbums() {
        manager?.albums = []
        manager?.title = ""
        guard let manager = manager else { return }
        manager.getAlbums()
        manager.albumDownloadCallback = {
            XCTAssert(manager.title == "Top Albums")
            XCTAssert(!manager.albums.isEmpty)
            guard let albumMock = manager.albums.first else { return }
            XCTAssertNotNil(albumMock.artistName)
            XCTAssertNotNil(albumMock.releaseDate)
            XCTAssertNotNil(albumMock.name)
            XCTAssertNotNil(albumMock.copyright)
            XCTAssertNotNil(albumMock.imageURL)
            XCTAssertNotNil(albumMock.artistUrl)
            XCTAssertNotNil(albumMock.genres)
        }
    }
    
    func testDetailVCInit() {
        manager?.albums = []
        guard let manager = manager else { return }
        manager.handleJSONString(jsonString)
        if let album = manager.albums.first {
            let dvc = DetailViewController(withAlbum: album)
            guard let album = dvc.album else { return }
            XCTAssert(dvc.title == "Fetch The Bolt Cutters")
            XCTAssert(album.artistName == "Fiona Apple")
            XCTAssert(album.releaseDate == "2020-04-17")
            XCTAssert(album.name == "Fetch The Bolt Cutters")
            XCTAssert(album.copyright == "℗ 2020 Epic Records, a division of Sony Music Entertainment")
            XCTAssert(album.imageURL == "https://is2-ssl.mzstatic.com/image/thumb/Music123/v4/d7/35/0d/d7350da2-70a2-22d6-20fb-514fbf05d0df/886448398486.jpg/200x200bb.png")
            XCTAssert(album.artistUrl == "https://music.apple.com/us/artist/fiona-apple/466131?app=music")
            
            guard let genres = dvc.album?.genres else { return }
            XCTAssert(!genres.isEmpty)
            XCTAssert(genres[0].name == "Alternative")
            XCTAssert(genres[1].name == "Music")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
