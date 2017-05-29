//
//  SPTPlayerModel.swift
//  SoTube
//
//  Created by VDAB Cursist on 22/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//


class SPTPlayerModel:NSObject, MusicPlayerModel, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    var player: SPTAudioStreamingController?
    let auth = SPTAuth.defaultInstance()!
    let clientID = "9b9a7a7d663a41b9a65a29142e095b89"
    var trackUri = ""
//    let token = "BQBblXXW1pPLAMd7gIQmM6V-aAR4tFnkOZ3nPd3hqEiGAF9VfzlUNxfghvA5BUu7yK-sD_8NOBdUgjv5_T2ViJhudpd74ivYPZWYiNcMSnokbb8NPPXFKHsfVzwNC_pYPae1tD6T73RvUaoLtA"

    var isPlaying: Bool {
        if self.player == nil {
            return false
        }
        return self.player?.playbackState?.isPlaying ?? false
    }
    
    var currentTime: TimeInterval {
        return self.player?.playbackState?.position ?? 0
    }
    
    var duration: TimeInterval {
        // TO FIX USING JSON
        return 0
    }
    
    func play(contentOf link: String) throws {
        self.trackUri = "spotify:track:\(link)"
        if player == nil {
            initializePlayer()
        }
//        self.player?.playSpotifyURI(uri, startingWith: 0, startingWithPosition: 0, callback: nil)

    }

    func stop() {
    }
    
    func setCurrentTime(to timeInterval: TimeInterval) {
        self.player?.seek(to: timeInterval, callback: nil)
    }
    
    func pause() {
        self.player?.setIsPlaying(false, callback: nil)
    }
    
    func play() {
        self.player?.setIsPlaying(true, callback: nil)
    }
    
    private func initializePlayer(){
        let userDefaults = UserDefaults.standard
        let session = NSKeyedUnarchiver.unarchiveObject(with: userDefaults.object(forKey: "SpotifySession") as! Data) as? SPTSession
        print(session?.accessToken)
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player?.playbackDelegate = self
            self.player?.delegate = self
            do {
                try player?.start(withClientId: clientID)
            } catch {
                print("ERROR")
            }
            self.player!.login(withAccessToken: session?.accessToken)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        //  spotify:track:58s6EuEYJdlb0kO7awm3Vp
        
        self.player?.playSpotifyURI(trackUri, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
    
//    private func setup () {
//        // insert redirect your url and client ID below
//        let redirectURL = "Spotify-TestApp://returnAfterLogin" // put your redirect URL here
//         // put your client ID here
//        auth.redirectURL     = URL(string: redirectURL)
//        auth.clientID        = clientID
//        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
////        loginUrl = auth.spotifyWebAuthenticationURL()
//    }
}
