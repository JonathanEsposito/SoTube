//
//  DatabaseViewModel.swift
//  SoTube
//
//  Created by .jsber on 18/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import Foundation

enum DatabaseError: Error {
    case notLoggedIn, notEnoughCoins
    
    var localizedDescription: String {
        switch self {
        case .notLoggedIn:
            return "You are not logged in."
        case .notEnoughCoins:
            return "You have not enough coins."
        }
    }
}

struct ErrorAlert {
    let title: String
    let message: String
    let actions: [UIAlertAction]?
}

protocol DatabaseModel {
    // Account stuff
    func login(withEmail email: String, password: String, onCompletion: ((ErrorAlert?) -> ())?)
    func signOut() throws
    func createNewAccount(withUserName userName: String, emailAddress: String, password: String, delegate: DatabaseDelegate)
    func resetPassword(forEmail email: String, delegate: DatabaseDelegate)
    func checkForSongs(onCompletion: @escaping (Bool) -> ())
    func getCurrentUserProfile(onCompletion: @escaping (Profile) -> ())
    func changeUsername(to: String, onCompletion: @escaping (Error?) -> ())
    func change(_ currentPassword: String, with newPassword: String, for email: String, on delegate: userInfoDelegate, onCompletion completionHandler: @escaping (Error?) -> ())
    // Store stuff
    func updateCoins(with: CoinPurchase, onCompletion: @escaping ()->())
    func getCoinHistory(onCompletion completionHandler: @escaping ([CoinPurchase])->())
    func getCoins(onCompletion: @escaping (Int)->())
    func buy(_ track: Track, withCoins coins: Int, onCompletion: (Error?)->())
    // Music stuff
    func getTracks(onCompletion completionHandler: @escaping ([Track])->())
    func getAlbums(onCompletion completionHandler: @escaping ([Album])->())
    func getAlbum(byID id: String, onCompletion completionHandler: @escaping (Album) -> ())
    func getArtists(onCompletion completionHandler: @escaping ([Artist])->())
}

protocol DatabaseDelegate {
    func showAlert(withTitle title: String, message: String, actions: [UIAlertAction]?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

class DatabaseViewModel {
    var databaseModel: DatabaseModel = Firebase()
    var delegate: DatabaseDelegate?
    var musicSource = SpotifyModel()
    
    func checkUserHasSongs(onCompletion completionHandler: @escaping (Bool) -> () ) {
        databaseModel.checkForSongs(onCompletion: completionHandler)
    }
    
    func login(withEmail email: String, password: String, onCompletion completionHandler: ((ErrorAlert?) -> ())? ) {        
        databaseModel.login(withEmail: email, password: password, onCompletion: completionHandler)
    }
    
    func createNewAccount(withUserName userName: String, emailAddress: String, password: String) {
        guard let delegate = delegate else {
            fatalError("DatabaseDelegate not yet set!")
        }
        databaseModel.createNewAccount(withUserName: userName, emailAddress: emailAddress, password: password, delegate: delegate)
    }
    
    func resetPassword(forEmail email: String) {
        guard let delegate = delegate else {
            fatalError("DatabaseDelegate not yet set!")
        }
        databaseModel.resetPassword(forEmail: email, delegate: delegate)
    }
    
    func getCurrentUserProfile(onCompletion completionHandler: @escaping (Profile) -> ()) {
        databaseModel.getCurrentUserProfile(onCompletion: completionHandler)
    }
    
    func changeUsername(to newUsername: String, onCompletion completionHandler: @escaping (Error?) -> ()) {
        databaseModel.changeUsername(to: newUsername, onCompletion: completionHandler)
    }
    
    func change(_ currentPassword: String, with newPassword: String, for email: String, on delegate: userInfoDelegate, onCompletion completionHandler: @escaping (Error?) -> ()) {
        databaseModel.change(currentPassword, with: newPassword, for: email, on: delegate, onCompletion: completionHandler)
    }
    
    func signOut(onCompletion completionHandler: () -> ()) {
        do {
            try databaseModel.signOut()
        } catch {
            delegate?.showAlert(withTitle: "Problem signing off", message: error.localizedDescription, actions: nil)
            return
        }
        completionHandler()
    }
    
    func updateCoins(with coinPurchase: CoinPurchase, onCompletion completionHandler: @escaping ()->()) {
        databaseModel.updateCoins(with: coinPurchase, onCompletion: completionHandler)
    }
    
    func getCoinHistory(onCompletion completionHandler: @escaping ([CoinPurchase])->()) {
        databaseModel.getCoinHistory(onCompletion: completionHandler)
    }
    
    func getTracks(onCompletion completionHandler: @escaping ([Track])->()) {
        databaseModel.getTracks(onCompletion: completionHandler)
    }
    
    func getCoins(onCompletion completionHandler: @escaping (Int)->()) {
        databaseModel.getCoins(onCompletion: completionHandler)
    }
    
    func buy(_ track: Track, withCoins coins: Int, onCompletion completionHandler: @escaping (Error?)->()) {
        // we already checked for enough coins
        self.musicSource.getCoverUrl(forArtistID: track.artistId) { [weak self] url in
//            print("url: \(url)")
            let track = track
            track.artistCoverUrl = url
            track.dateOfPurchase = Date()
            track.priceInCoins = coins
            
            self?.databaseModel.buy(track, withCoins: coins, onCompletion: completionHandler)
        }
    }
    
    func getAlbums(forArtist artist: Artist, onCompletion completionHandler: @escaping ([Album])->()) {
        let albumIds = artist.albumIds
        let albumIdsCount = albumIds.count
        var albums: [Album] = []
        albumIds.forEach {
            databaseModel.getAlbum(byID: $0) { album in
//                print("getAlbum(byID: \(album)")
                DispatchQueue.main.async {
                    albums.append(album)
                    if albums.count >= albumIdsCount {
                        completionHandler(albums)
                    }
                }
            }
//            print($0)
        }
    }
    
    func getAlbum(byId albumId: String, onCompletion completionHandler: @escaping (Album)->()) {
        databaseModel.getAlbum(byID: albumId, onCompletion: completionHandler)
    }
    
    func getAlbums(onCompletion completionHandler: @escaping ([Album])->()) {
        databaseModel.getAlbums(onCompletion: completionHandler)
    }
    
    func getArtists(onCompletion completionHandler: @escaping ([Artist])->()) {
        databaseModel.getArtists(onCompletion: completionHandler)
    }
}
