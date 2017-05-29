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
//    func setUpdater()
//    var view: UIView { get }
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
//        weak var weakSelf = self
//        musicPlayer.player.addObserver(weakSelf!, forKeyPath: "isPlaying", options: .new, context: &playerIsPlayingContext)
        
        playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButton(_:)))
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseButton(_:)))
        
        print("awakefromnib")
        // set player buttonIndex
        if musicPlayer.isNotPlaying {
            setButton(to: .play)
//            let buttonIndex = self.items?.index(where: { $0 == (musicPlayButton ?? pauseButton) })
//            self.items![buttonIndex!] = playButton
        }
    }
    
//    deinit {
//        // Remove previously added observers
//        musicPlayer.player.removeObserver(self, forKeyPath: "isPlaying", context: &playerIsPlayingContext)
//    }
    
//    // MARK: - Observers
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        
//        switch object! {
//        case let player as MusicPlayerModel where player.isPlaying == true:
//            setButton(to: .pause)
//            
//        case let player as MusicPlayerModel where player.isPlaying == false:
//            setButton(to: .play)
//        default:
//            break
//        }
//    }
    
    // MARK: - IBActions
    @IBAction func playButton(_ sender: UIBarButtonItem) {
        musicPlayer.play()
//        print("isPlaying?: \(musicPlayer.isPlaying)")
//        minimizedPlayerDelegate?.setUpdater()
        
//        setButton(to: .pause)
        
//        let buttonIndex = self.items?.index(where: { $0 == sender })
//        self.items![buttonIndex!] = pauseButton
    }
    
    @IBAction func pauseButton(_ sender: UIBarButtonItem) {
        musicPlayer.pause()
//        setButton(to: .play)
//        print("isplaying?: \(musicPlayer.isPlaying)")
//        let buttonIndex = self.items?.index(where: { $0 == sender })
//        self.items![buttonIndex!] = playButton
    }
    
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
