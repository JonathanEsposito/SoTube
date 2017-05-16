//
//  SoTubeAVAudioPlayer.swift
//  SoTube
//
//  Created by .jsber on 15/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import AVFoundation

class AVAudioPlayerModel: MusicPlayerModel {
    private let player = AVAudioPlayer()
    
    var isNotPlaying: Bool {
        return !player.isPlaying
    }
    
    var currentTime: TimeInterval {
        return player.currentTime
    }
    
    var duration: TimeInterval {
        return player.duration
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
        player.play()
    }
}
