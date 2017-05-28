//
//  Album.swift
//  SoTube
//
//  Created by VDAB Cursist on 23/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

struct Album {
    let id: String
    let name: String
    let coverUrl: String
    let artistId: String
    let artist: String
    var trackIds: [String]
    
    init(albumId: String, albumName: String, coverUrl: String, artistId: String, artistName: String, trackIds: [String]) {
        self.id = albumId
        self.name = albumName
        self.coverUrl = coverUrl
        self.artistId = artistId
        self.artist = artistName
        self.trackIds = trackIds
    }
    
    init(named name: String, fromArtist artist: String, withCoverUrl coverUrl: String, withId id: String) {
        self.init(albumId: id, albumName: name, coverUrl: coverUrl, artistId: "", artistName: artist, trackIds: [])
    }
}
