//
//  Category.swift
//  SoTube
//
//  Created by VDAB Cursist on 23/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

struct Category {
    let name: String
    let coverUrl: String
    let url: String
    
    init(named name: String, withCoverUrl coverUrl: String, withUrl url: String) {
        self.name = name
        self.url = url
        self.coverUrl = coverUrl
    }
}
