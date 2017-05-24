//
//  Category.swift
//  SoTube
//
//  Created by VDAB Cursist on 23/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

struct Category {
    let name: String
    let id: String
    let coverUrl: String
    let url: String
    var playlists: [Playlist]?
    
    init(named name: String,withId id: String, withCoverUrl coverUrl: String, withUrl url: String) {
        self.name = name
        self.id = id
        self.url = url
        self.coverUrl = coverUrl
    }
}
