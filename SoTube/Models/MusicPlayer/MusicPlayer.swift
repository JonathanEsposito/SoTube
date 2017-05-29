//
//  MusicPlayer.swift
//  Audio Player
//
//  Created by .jsber on 15/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import Foundation

protocol MusicPlayerModel {
    //MARK: - Protocol
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get }
    var duration: TimeInterval { get }
    
    func play(contentOf: String) throws
    func stop()
    func setCurrentTime(to: TimeInterval)
    func pause()
    func play()
}

class MusicPlayer: NSObject {
    // MARK: - Private Properties
    private let player: MusicPlayerModel = SPTPlayerModel()
    var track: Track?
    private var link: String?
    
    // MARK: - MusicPlayer API
    // MARK: Properties
    var hasSong: Bool {
        if track != nil {
            return true
        }
        return false
    }
    
    var isPlaying: Bool {
        if track != nil {
            return player.isPlaying
        }
        return false
    }
    
    var isNotPlaying: Bool {
        return !isPlaying
    }
    
    var stopped: Bool {
        return isNotPlaying && player.currentTime == 0
    }
    
    var progress: Float {
        return Float(player.currentTime / player.duration)
    }
    
    var currentTime: String {
        return string(fromTimeInterval: player.currentTime)
    }
    
    var timeLeft: String {
        return "-\(string(fromTimeInterval: player.duration - player.currentTime))"
    }
    
    // MARK: Methods
    func fastBackward() {
        var time: TimeInterval = player.currentTime
        time -= 5.0 // Go back by 5 seconds
        if time < 0 {
            stopPlayer()
        } else {
            player.setCurrentTime(to: time)
        }
    }
    
    func pause() {
        player.pause()
    }
    
    func play() {
        if isNotPlaying {
            player.play()
        }
    }
    
    func stop() {
        stopPlayer()
    }
    
    func fastForward() {
        var time: TimeInterval = player.currentTime
        time += 5.0 // Go forward by 5 seconds
        if time > player.duration {
            stopPlayer()
        } else {
            player.setCurrentTime(to: time)
        }
    }
    
    func play(_ track: Track) {
        self.track = track
        let link = track.id
        print(link)
//        do {
//            try player.play(contentOf: link)
//        } catch {
//            print("error")
//        }
    }
    
    func set(time: TimeInterval) {
        player.setCurrentTime(to: time * player.duration)
    }
    
    // MARK: - Private Methods
    private func stopPlayer() {
        player.stop()
    }
    
    private func string(fromTimeInterval interval: TimeInterval) -> String {
        
        let time = Int(interval)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        if hours == 0 {
            return String(format: "%0.1d:%0.2d",minutes,seconds)
        } else {
            return String(format: "%0.1d:%0.2d:%0.2d",hours,minutes,seconds)
        }
    }
    
}
