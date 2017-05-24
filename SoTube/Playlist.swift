//
//  Playlist.swift
//  SoTube
//
//  Created by VDAB Cursist on 23/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

struct Playlist {
    let name: String
    let coverUrl: String
    let id: String
    let owner: String
    var tracks: [Track]?
    
    init(named name: String, withCoverUrl coverUrl: String, withId id: String, fromOwner owner: String) {
        self.name = name
        self.id = id
        self.coverUrl = coverUrl
        self.owner = owner
    }
}
