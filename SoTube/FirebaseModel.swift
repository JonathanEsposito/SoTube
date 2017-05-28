//
//  FirebaseModel.swift
//  SoTube
//
//  Created by .jsber on 18/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import Foundation
import Firebase

class Firebase: DatabaseModel {
    func login(withEmail email: String, password: String, delegate: DatabaseDelegate, onCompletion completionHandler:  (() -> ())? ) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("error")
                delegate.showAlert(withTitle: "Login Error", message: error.localizedDescription, actions: nil)
                return
            }
            
            guard let currentUser = user, currentUser.isEmailVerified else {
                print("email not verified")
                let actions = [
                    UIAlertAction(title: "Resent email", style: .default, handler: { (action) in
                        user?.sendEmailVerification(completion: nil)
                    }),
                    UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ]
                
                delegate.showAlert(withTitle: "Email address not confirmed", message: "You haven't confirmed your email address yet. We sent you a confirmation email upon refistration. You can click the verification link in that email. If you lost that email we'll gladly send you a new confirmation email. In that case you ought to tap Resend confirmation email.", actions: actions)
                return
            }
            
            // On completion
            if let completionHandler = completionHandler {
                completionHandler()
            } else {
                print("no completionhandler")
            }
        })
    }
    
    func signOut() throws {
        try FIRAuth.auth()?.signOut()
    }
    
    func createNewAccount(withUserName userName: String, emailAddress: String, password: String, delegate: DatabaseDelegate) {
        FIRAuth.auth()?.createUser(withEmail: emailAddress, password: password, completion: { (user, error) in
            if let error = error {
                delegate.showAlert(withTitle: "Registration error", message: error.localizedDescription, actions: nil)
                return
            }
            
            // Add userName
            if let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest() {
                changeRequest.displayName = userName
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error {
                        print("Failed to change the display name: \(error.localizedDescription)")
                    }
                })
            }
            
            // Send Verification email
            user?.sendEmailVerification(completion: nil)
            
            let dismissDelegateAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    // Dismiss the current view controller
                    delegate.dismiss(animated: true, completion: nil)
            })
            
            delegate.showAlert(withTitle: "Email Verification", message: "We've just sent a confirmation email to \(emailAddress). Please check your inbox and click the verification link in that email to complete registration.", actions:  [dismissDelegateAction])
        
            /****
             * Add user to database
             ****/
            // Setting the users reference
            let usersReference = FIRDatabase.database().reference(withPath: "users")
            
            // Create User in database
            if let currentUser = user {
                let currentUserReference = usersReference.child(currentUser.uid)
                let propertiesChild = currentUserReference.child("properties")
                let coinsChild = propertiesChild.child("coins")
                coinsChild.setValue(200)
            }
        })
    }
    
    func resetPassword(forEmail email: String, delegate: DatabaseDelegate) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                delegate.showAlert(withTitle: "Password reset error", message: error.localizedDescription, actions:  nil)
            } else {
                delegate.showAlert(withTitle: "Password reset", message: "An email has been send to \(email). Please click the reset password link in that email to complete the password reset.", actions: nil)
            }
        }
    }
    
    
    // can be optimized with REST API "shallow=true"
    // https://yourapp.firebaseio.com/users/[userID]/songs?shallow=true
    // to be tested
    func checkForSongs(onCompletion completionHandler: @escaping (Bool) -> () ) {
        guard let userID = FIRAuth.auth()?.currentUser?.uid else {
            print("user not loged in")
            completionHandler(false)
            return
        }
        
        let userReference = FIRDatabase.database().reference(withPath: "users")
        userReference.child(userID).child("songs").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists() {
                
                if let value = snapshot.value as? NSDictionary {
//                    print("checkForSongs \(value)")
                    let songCount = value.count
                    
                    if songCount > 0 {
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                } else {
                    print("cannot cast snapshot as NSDictionary")
//                    print(snapshot.value)
                    completionHandler(false)
                }
            } else {
                completionHandler(false)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getCurrentUserProfile(onCompletion completionHandler: @escaping (Profile) -> ()) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            print("User not logged in")
            return
        }
        
        let userEmail = currentUser.email ?? ""
        let userUsername = currentUser.displayName ?? ""
        let userID = currentUser.uid
        
        let userReference = FIRDatabase.database().reference(withPath: "users/\(userID)")
        userReference.child("properties/coins").observeSingleEvent(of: .value, with: { snapshot in
//            print(snapshot.value)
            let amountOfCoins = snapshot.value as? Int
            
            userReference.child("songs").observeSingleEvent(of: .value, with: { snapshot in
                let tracks = snapshot.value as? NSDictionary
                let amountOfSongs = tracks?.count
                
                let userProfile = Profile(username: userUsername, email: userEmail, amountOfCoins: amountOfCoins ?? 0, amountOfSongs: amountOfSongs ?? 0)
                
                completionHandler(userProfile)
            })
        })
    }
    
    func changeUsername(to newUsername: String, onCompletion completionHandler: @escaping (Error?) -> ()) {
        if let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest() {
            changeRequest.displayName = newUsername
            changeRequest.commitChanges(completion: completionHandler)
        }
    }
    
    func change(_ currentPassword: String, with newPassword: String, for email: String, on delegate: userInfoDelegate, onCompletion completionHandler: @escaping (Error?) -> ()) {
        // reauthenticate
        let user = FIRAuth.auth()?.currentUser
        
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: currentPassword)
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                completionHandler(error)
            } else {
                user?.updatePassword(newPassword, completion: completionHandler)
            }
        }
    }
    
    func getCoins(onCompletion completionHandler: @escaping (Int) -> ()) {
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let userRef = FIRDatabase.database().reference(withPath: "users/\(userID)")
            userRef.child("properties/coins").observeSingleEvent(of: .value, with: { snapshot in
                print("coinsSnapshot: \(snapshot.value)")
                if let currentAmount = snapshot.value as? Int {
                    completionHandler(currentAmount)
                }
            })
        }
    }
    
    func updateCoins(with coinPurchase: CoinPurchase, onCompletion completionHandler: @escaping ()->()) {
        print("we will update our coins")
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            print("userId: \(userID)")
            
            let userReference = FIRDatabase.database().reference(withPath: "users/\(userID)")
            
//            userReference.child("properties/coins").runTransactionBlock({ snapshot in
//                if let currentAmount = snapshot.value as? Int {
//                    snapshot.value = currentAmount + coinPurchase.amount
//                    completionHandler()
//                    return FIRTransactionResult.success(withValue: snapshot)
//                }
//                print("adding coins not succesfull")
//                return FIRTransactionResult.abort()
//            })
            
            userReference.child("properties/coins").observeSingleEvent(of: .value, with: { snapshot in
//                print(snapshot.value)
                if let currentAmount = snapshot.value as? Int {
                    let newTotal = currentAmount + coinPurchase.amount
                    userReference.child("properties/coins").setValue(newTotal)
                    completionHandler()
                }
            })
            
            
            userReference.child("properties/coinsHistory").updateChildValues(coinPurchase.dictionary)
//            let coinsHistoryChild = userReference.child("properties/coinsHistory")
//            coinsHistoryChild.updateChildValues(coinPurchase.dictionary)
        } else {
            print("user not logged in")
        }
    }
    
    func getCoinHistory(onCompletion completionHandler: @escaping ([CoinPurchase])->()) {
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let userCoinHistoryRef = FIRDatabase.database().reference(withPath: "users/\(userID)/properties/coinsHistory")
            userCoinHistoryRef.observeSingleEvent(of: .value, with: { snapshot in
                if let purchaseDictionary = snapshot.value as? [String : [String : Double]] {
                    var coinPurchases: [CoinPurchase] = []
                    purchaseDictionary.forEach {
                        let dateString = $0.key
                        guard let amountString = $0.value.keys.first else {fatalError("Database error")}
                        guard let price = $0.value.values.first else {fatalError("Database error")}
                        
                        if let date = Int(dateString), let amount = Int(amountString) {
//                            print("time: \(time), amount: \(amount), price: \(round(price * 100) / 100)")
                            coinPurchases.append(CoinPurchase(amount: amount, price: price, databaseTime: date))
                        }
                    }
                    completionHandler(coinPurchases)
                }
            })
        } else {
            print("user not logged in")
        }
    }
    
    func buy(_ track: Track, withCoins coins: Int, onCompletion completionHandler: (Error?)->()) {
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let userRef = FIRDatabase.database().reference(withPath: "users/\(userID)")
            
            // updateCoins
            userRef.child("properties/coins").observeSingleEvent(of: .value, with: { snapshot in
                if let currentAmount = snapshot.value as? Int {
                    let newTotal = currentAmount - coins
                    userRef.child("properties/coins").setValue(newTotal)
                }
            })
            
            userRef.child("songs").updateChildValues(track.dictionary)
            userRef.child("albums/\(track.albumId)").updateChildValues(track.albumDictionary)
            userRef.child("albums/\(track.albumId)/trackIds").updateChildValues(["\(track.id)" : true])
            userRef.child("artists/\(track.artistId)").updateChildValues(track.artistDictionary)
            userRef.child("artists/\(track.artistId)/albumIds").updateChildValues(["\(track.albumId)" : true])
            
            completionHandler(nil)
        } else {
            completionHandler(DatabaseError.notLoggedIn)
        }
    }
    
    func getTracks(onCompletion completionHandler: @escaping ([Track])->()) {
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let userMusicHistoryRef = FIRDatabase.database().reference(withPath: "users/\(userID)/songs")
            userMusicHistoryRef.observeSingleEvent(of: .value, with: { snapshot in
                print(snapshot.value)
                if let purchaseDictionary = snapshot.value as? [String : [String : String]] {
//                    print(purchaseDictionary)
                    var musicPurchases: [Track] = []
                    purchaseDictionary.forEach {
                        print($0)
                        let id = $0.key
                        guard let name = $0.value["name"] else {fatalError("Database error")}
                        guard let trackNumberString = $0.value["trackNumber"], let trackNumber = Int(trackNumberString) else {fatalError("Database error")}
                        guard let discNumberString = $0.value["discNumber"], let discNumber = Int(discNumberString) else {fatalError("Database error")}
                        guard let durationString = $0.value["duration"], let duration = Int(durationString) else {fatalError("Database error")}
                        guard let coverUrl = $0.value["coverUrl"] else {fatalError("Database error")}
                        guard let artistName = $0.value["artistName"] else {fatalError("Database error")}
                        guard let artistId = $0.value["artistId"] else {fatalError("Database error")}
                        guard let albumName = $0.value["albumName"] else {fatalError("Database error")}
                        guard let albumId = $0.value["albumId"] else {fatalError("Database error")}
                        guard let dateOfPurchaseString = $0.value["dateOfPurchase"], let dateOfPurchase = TimeInterval(dateOfPurchaseString) else {fatalError("Database error")}
                        guard let priceInCoinsString = $0.value["priceInCoins"], let priceInCoins = Int(priceInCoinsString) else {fatalError("Database error")}
                        
                        musicPurchases.append(Track(id: id, name: name, trackNumber: trackNumber, discNumber: discNumber, duration: duration, coverUrl: coverUrl, artistName: artistName, artistId: artistId, albumName: albumName, albumId: albumId, bought: true, databaseDate: dateOfPurchase, priceInCoins: priceInCoins))
                    }
                    completionHandler(musicPurchases)
                } else {
                    completionHandler([])
                    print("my my, snapshot cast error")
                }
            })
        } else {
            completionHandler([])
            print("user not logged in")
        }
    }
    
    func getAlbums(onCompletion completionHandler: @escaping ([Album]) -> ()) {
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let userRef = FIRDatabase.database().reference(withPath: "users/\(userID)")
            userRef.child("albums").observeSingleEvent(of: .value, with: { snapshot in
                if let albumDictionary = snapshot.value as? [String : [String : Any]] {
//                    print(albumDictionary)
                    var albums: [Album] = []
                    albumDictionary.forEach {
//                        print($0)
                        let albumId = $0.key
                        guard let albumName = $0.value["albumName"] as? String else {fatalError("Database error")}
                        guard let coverUrl = $0.value["coverUrl"] as? String else {fatalError("Database error")}
                        guard let artistId = $0.value["artistId"] as? String else {fatalError("Database error")}
                        guard let artistName = $0.value["artistName"] as? String else {fatalError("Database error")}
                        guard let trackIdsDictionary = $0.value["trackIds"] as? [String : Bool] else {fatalError("Database error")}
                        let trackIds = Array(trackIdsDictionary.keys)
                        
                        albums.append(Album(albumId: albumId, albumName: albumName, coverUrl: coverUrl, artistId: artistId, artistName: artistName, trackIds: trackIds))
                    }
                    completionHandler(albums)
                    
                } else {
                    completionHandler([])
                    print("snapshot cast error")
                }
            })
        } else {
            completionHandler([])
            print("user not logged in")
        }
    }
    
    func getArtists(onCompletion completionHandler: @escaping ([Artist]) -> ()) {
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let userRef = FIRDatabase.database().reference(withPath: "users/\(userID)")
            userRef.child("artists").observeSingleEvent(of: .value, with: { snapshot in
                if let artistDictionary = snapshot.value as? [String : [String : Any]] {
//                    print(albumDictionary)
                    var artists: [Artist] = []
                    artistDictionary.forEach {
//                        print($0)
                        let artistId = $0.key
                        guard let artistName = $0.value["artistName"] as? String else {fatalError("Database error")}
                        guard let artistCoverUrl = $0.value["artistCoverUrl"] as? String else {fatalError("Database error")}
                        guard let albumIdsDictionary = $0.value["albumIds"] as? [String : Bool] else {fatalError("Database error")}
                        let albumIds = Array(albumIdsDictionary.keys)
                        
                        artists.append(Artist(artistId: artistId, artistName: artistName, artistCoverUrl: artistCoverUrl, albumIds: albumIds))
                    }
                    completionHandler(artists)
                    
                } else {
                    completionHandler([])
                    print("snapshot cast error")
                }
            })
        } else {
            completionHandler([])
            print("user not logged in")
        }
    }
    
    func getAlbums(forArtist artist: Artist, onCompletion completionHandler: @escaping ([Album]) -> ()) {
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let userRef = FIRDatabase.database().reference(withPath: "users/\(userID)")
            userRef.child("albums").observeSingleEvent(of: .value, with: { snapshot in
                if let albumDictionary = snapshot.value as? [String : [String : Any]] {
                    //                    print(albumDictionary)
                    var albums: [Album] = []
                    albumDictionary.forEach {
                        //                        print($0)
                        let albumId = $0.key
                        guard let albumName = $0.value["albumName"] as? String else {fatalError("Database error")}
                        guard let coverUrl = $0.value["coverUrl"] as? String else {fatalError("Database error")}
                        guard let artistId = $0.value["artistId"] as? String else {fatalError("Database error")}
                        guard let artistName = $0.value["artistName"] as? String else {fatalError("Database error")}
                        guard let trackIdsDictionary = $0.value["trackIds"] as? [String : Bool] else {fatalError("Database error")}
                        let trackIds = Array(trackIdsDictionary.keys)
                        
                        albums.append(Album(albumId: albumId, albumName: albumName, coverUrl: coverUrl, artistId: artistId, artistName: artistName, trackIds: trackIds))
                    }
                    completionHandler(albums)
                    
                } else {
                    completionHandler([])
                    print("snapshot cast error")
                }
            })
        } else {
            completionHandler([])
            print("user not logged in")
        }
    }
    
    func getAlbum(byID id: String, onCompletion completionHandler: @escaping (Album) -> ()) {
        print("id: \(id)")
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            let userRef = FIRDatabase.database().reference(withPath: "users/\(userID)")
            userRef.child("albums/\(id)").observeSingleEvent(of: .value, with: { snapshot in
//                print(snapshot.value)
                if let albumDictionary = snapshot.value as? [String : Any] {
//                    print("albumDictionary: \(albumDictionary)")
                    guard let albumName = albumDictionary["albumName"] as? String else {fatalError("Database error")}
                    guard let coverUrl = albumDictionary["coverUrl"] as? String else {fatalError("Database error")}
                    guard let artistId = albumDictionary["artistId"] as? String else {fatalError("Database error")}
                    guard let artistName = albumDictionary["artistName"] as? String else {fatalError("Database error")}
                    guard let trackIdsDictionary = albumDictionary["trackIds"] as? [String : Bool] else {fatalError("Database error")}
                    let trackIds = Array(trackIdsDictionary.keys)
                    
                    let album = Album(albumId: id, albumName: albumName, coverUrl: coverUrl, artistId: artistId, artistName: artistName, trackIds: trackIds)
                    completionHandler(album)
                } else {
//                    completionHandler()
                    print("snapshot cast error")
                }
            })
        } else {
//            completionHandler()
            print("user not logged in")
        }

    }
}
