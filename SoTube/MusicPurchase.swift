//
//  MusicPurchase.swift
//  SoTube
//
//  Created by .jsber on 24/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import Foundation

struct Track {
    let id: String
    let name: String
    let trackNumber: Int
    let discNumber: Int
    let duration: Int
    let coverUrl: String
    let artistName: String
    let artistId: String
    let albumName: String
    let albumId: String
    
    var dateOfPurchase: Date?
    var priceInCoins: Int?
    
    var dateString: String {
        return DateFormatter.localizedString(from: dateOfPurchase!, dateStyle: .medium, timeStyle: .none)
    }
    
    var keyDate: TimeInterval {
        return dateOfPurchase!.timeIntervalSinceReferenceDate
    }
    
    var dictionary: [String : [String : String]] {
        return [ id : [
            "name" : name,
            "trackNumber" : String(trackNumber),
            "discNumber" : String(discNumber),
            "duration" : String(duration),
            "coverUrl" : coverUrl,
            "artistName" : artistName,
            "artistId" : artistId,
            "albumName" : albumName,
            "albumId" : albumId,
            "dateOfPurchase" : String(keyDate),
            "priceInCoins" : String(priceInCoins!)
            ]]
    }
    
    init(id: String, name: String, trackNumber: Int, discNumber: Int, duration: Int, coverUrl: String, artistName: String, artistId: String, albumName: String, albumId: String, dateOfPurchase: Date?, priceInCoins: Int?) {
        self.id = id
        self.name = name
        self.trackNumber = trackNumber
        self.discNumber = discNumber
        self.duration = duration
        self.coverUrl = coverUrl
        self.artistName = artistName
        self.artistId = artistId
        self.albumName = albumName
        self.albumId = albumId
        self.dateOfPurchase = dateOfPurchase
        self.priceInCoins = priceInCoins
    }
    
    init(id: String, name: String, trackNumber: Int, discNumber: Int, duration: Int, coverUrl: String, artistName: String, artistId: String, albumName: String, albumId: String) {
        self.init(id: id, name: name, trackNumber: trackNumber, discNumber: discNumber, duration: duration, coverUrl: coverUrl, artistName: artistName, artistId: artistId, albumName: albumName, albumId: albumId, dateOfPurchase: nil, priceInCoins: nil)
    }
    
    init(id: String, name: String, trackNumber: Int, discNumber: Int, duration: Int, coverUrl: String, artistName: String, artistId: String, albumName: String, albumId: String, databaseDate: TimeInterval, priceInCoins: Int) {
        let date = Date(timeIntervalSinceReferenceDate: databaseDate)
        self.init(id: id, name: name, trackNumber: trackNumber, discNumber: discNumber, duration: duration, coverUrl: coverUrl, artistName: artistName, artistId: artistId, albumName: albumName, albumId: albumId, dateOfPurchase: date, priceInCoins: priceInCoins)
    }
}
