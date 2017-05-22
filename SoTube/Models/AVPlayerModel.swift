//
//  AVPlayerModel.swift
//  SoTube
//
//  Created by VDAB Cursist on 17/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import AVFoundation

//class AVPlayerModel: MusicPlayerModel {
//    private var player = AVPlayer()
//    
//    var isPlaying: Bool {
//        if player.rate == 0.0 {
//            return false
//        } else {
//            return true
//        }
//    }
//    
//    var currentTime: TimeInterval {
//        return TimeInterval(player.currentTime().value)
//    }
//    
////    var duration: TimeInterval {
////        return player.pl
////    }
//    
//    func play(contentOf url: URL) throws {
//        player = AVPlayer(url: url)
//        player.play()
//    }
//    
//    func stop() {
//        player.replaceCurrentItem(with: nil)
//    }
//    
//    func setCurrentTime(to timeInterval: TimeInterval) {
//        player.seek(to: CMTime(value: CMTimeValue(timeInterval), timescale: 1))
//    }
//    
//    func pause() {
//        player.rate = 0.0
//    }
//    
//    func play() {
//        player.rate = 1.0
//    }
//}
