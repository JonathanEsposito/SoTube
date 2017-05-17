//
//  MinimizedPlayer.swift
//  SoTube
//
//  Created by .jsber on 16/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

protocol MinimizedPlayerDelegate {
    func present(_ view: UIViewController)
    var updater: CADisplayLink! { get set }
    func setUpdater()
}

class MinimizedPlayer: UIToolbar {
    @IBOutlet weak var musicPlayButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistAndAlbumLabel: UILabel!
    
    var playButton: UIBarButtonItem!
    var pauseButton: UIBarButtonItem!
    
    var minimizedPlayerDelegate: MinimizedPlayerDelegate?
    
    override func awakeFromNib() {
        playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButton(_:)))
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseButton(_:)))
        
        print("awakefromnib")
        // set player buttonIndex
        if musicPlayer.isNotPlaying {
            let buttonIndex = self.items?.index(where: { $0 == (musicPlayButton ?? pauseButton) })
            self.items![buttonIndex!] = playButton
        }
    }
    
    @IBAction func playButton(_ sender: UIBarButtonItem) {
        musicPlayer.play()
        minimizedPlayerDelegate?.setUpdater()
        
        let buttonIndex = self.items?.index(where: { $0 == sender})
        self.items![buttonIndex!] = pauseButton
    }
    
    @IBAction func pauseButton(_ sender: UIBarButtonItem) {
        musicPlayer.pause()
        
        let buttonIndex = self.items?.index(where: { $0 == sender})
        self.items![buttonIndex!] = playButton
    }

    @IBAction func showPlayer(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "MusicPlayer", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MusicPlayer")
        minimizedPlayerDelegate?.present(controller)
    }
}
