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
}

class MinimizedPlayer: UIToolbar {
    // MARK: - Properties
    @IBOutlet weak var musicPlayButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistAndAlbumLabel: UILabel!
    
    var playButton: UIBarButtonItem!
    var pauseButton: UIBarButtonItem!
    
    var minimizedPlayerDelegate: MinimizedPlayerDelegate?
    
    var playerIsPlayingContext = 0
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButton(_:)))
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseButton(_:)))
        
//        print("awakefromnib")
        // set player buttonIndex
        if musicPlayer.isNotPlaying {
            setButton(to: .play)
        }
    }
    
    // MARK: - IBActions
    @IBAction func playButton(_ sender: UIBarButtonItem) {
        musicPlayer.resume()
    }
    
    @IBAction func pauseButton(_ sender: UIBarButtonItem) {
        musicPlayer.pause()
    }
    
    // Present big player in a popover
    @IBAction func showPlayer(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "MusicPlayer", bundle: nil)
        let bigMusicPlayer = storyboard.instantiateViewController(withIdentifier: "MusicPlayer") as! MusicPlayerViewController
        
        let nav = UINavigationController(rootViewController: bigMusicPlayer)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popover = nav.popoverPresentationController
        bigMusicPlayer.preferredContentSize = CGSize(width: 320, height: 568)
        popover?.delegate = minimizedPlayerDelegate as! UIPopoverPresentationControllerDelegate?
        popover?.sourceView = self
        popover?.sourceRect = CGRect(x: self.bounds.width + 10, y: 0, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection.right
        
        minimizedPlayerDelegate?.present(nav)
    }
    
    // MARK: - Methodes
    func setButton(to buttonState: PlayerButtonState) {
        switch buttonState {
        case .play:
            self.items![0] = playButton
        case .pause:
            self.items![0] = pauseButton
        }
    }
    
    // MARK: - Private Objects
    enum PlayerButtonState {
        case play, pause
    }
}
