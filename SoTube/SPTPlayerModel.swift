//
//  SPTPlayerModel.swift
//  SoTube
//
//  Created by VDAB Cursist on 22/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//


class SPTPlayerModel: NSObject, MusicPlayerModel, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    var player: SPTAudioStreamingController?
    let auth = SPTAuth.defaultInstance()!
    let clientID = "9b9a7a7d663a41b9a65a29142e095b89"
    var trackUri = ""
    var track: Track?
    var isPlayerPlayingContext = 0
    
    // MARK: - Lifecycle
    private func initializePlayer(){
        let userDefaults = UserDefaults.standard
        let session = NSKeyedUnarchiver.unarchiveObject(with: userDefaults.object(forKey: "SpotifySession") as! Data) as? SPTSession
//        print(session?.accessToken)
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
    
    // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // Player is logged in
        
        self.player?.playSpotifyURI(trackUri, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if error == nil {
                self.isPlaying = true
            }
        })
    }
    
//    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
//        if trackUri == self.trackUri {
//            self.isPlaying = false
//        }
//    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        print("Player is playing: \(isPlaying)")
        self.isPlaying = isPlaying
    }
    
    // MARK: - API
    dynamic var isPlaying: Bool = false
    
    var currentTime: TimeInterval {
        return self.player?.playbackState?.position ?? 0
    }
    
    var duration: TimeInterval {
        if let track = track {
            return TimeInterval(track.duration / 1000)
        }
        return 0
    }
    
    func play(_ track: Track) throws {
        self.track = track
        self.trackUri = "spotify:track:\(track.id)"
        if player == nil {
            initializePlayer()
        }
        self.player?.playSpotifyURI(self.trackUri, startingWith: 0, startingWithPosition: 0, callback: { error in
            if error == nil {
                self.isPlaying = true
            }
            
        })
    }

    func stop() {
        self.player?.seek(to: 0, callback: nil)
        self.player?.setIsPlaying(false, callback: nil)
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
