//
//  Album.swift
//  SoTube
//
//  Created by VDAB Cursist on 23/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

struct Album {
    let name: String
    let artist: String
    let coverUrl: String
    let id: String
    var trackIds: [String]
    
    init(named name: String, fromArtist artist: String, withCoverUrl coverUrl: String, withId id: String, trackIds: [String]? = nil) {
        self.name = name
        self.artist = artist
        self.id = id
        self.coverUrl = coverUrl
        self.trackIds = trackIds ?? []
    }
}
