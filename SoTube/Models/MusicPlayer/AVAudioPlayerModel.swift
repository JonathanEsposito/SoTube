//
//  AVAudioPlayerModel.swift
//  Audio Player
//
//  Created by .jsber on 15/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import AVFoundation

class AVAudioPlayerModel: MusicPlayerModel {
    private var player = AVAudioPlayer()
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    var currentTime: TimeInterval {
        return player.currentTime
    }
    
    var duration: TimeInterval {
        return player.duration
    }
    
    func play(contentOf url: URL) throws {
        player = try AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
        player.play()
    }
    
    func stop() {
        player.stop()
        player.currentTime = 0
    }
    
    func setCurrentTime(to timeInterval: TimeInterval) {
        player.currentTime = timeInterval
    }
    
    func pause() {
        player.pause()
    }
    
    func play() {
        player.prepareToPlay()
        player.play()
    }
}