//
//  SPTPlayerModel.swift
//  SoTube
//
//  Created by VDAB Cursist on 22/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//


class SPTPlayerModel:NSObject, MusicPlayerModel, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    var player = SPTAudioStreamingController.sharedInstance()
    
    var isPlaying: Bool {
        return player?.playbackState.isPlaying ?? false
    }
    
    var currentTime: TimeInterval {
        return player?.playbackState.position ?? 0
    }
    
    var duration: TimeInterval {
        // TO FIX USING JSON
        return 0
    }
    
    func play(contentOf uri: String) throws {
        player?.playSpotifyURI(uri, startingWith: 0, startingWithPosition: 0, callback: nil)

    }

    func stop() {
    }
    
    func setCurrentTime(to timeInterval: TimeInterval) {
        player?.seek(to: timeInterval, callback: nil)
    }
    
    func pause() {
        player?.setIsPlaying(false, callback: nil)
    }
    
    func play() {
        player?.setIsPlaying(true, callback: nil)
    }
}
