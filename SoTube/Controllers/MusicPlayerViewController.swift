//
//  MusicPlayerViewController.swift
//  SoTube
//
//  Created by .jsber on 12/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit
import CoreImage

class MusicPlayerViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var controllersView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var fastBackwardButton: UIBarButtonItem!
    @IBOutlet weak var musicPlayButton: UIBarButtonItem!
    @IBOutlet weak var fastForwardButton: UIBarButtonItem!
    
    var updater: CADisplayLink! = nil
    var songURL: URL?
    
    var playButton: UIBarButtonItem!
    var pauseButton: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MusicPlayer")
        
        //
        configureProgresSlider()
        
        // set toolbar background transparent
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)

        // Set controller backgroundColor to averige of cover
//        controllersView.backgroundColor = coverImageView.image!.areaAverage().withAlphaComponent(0.5) // To slow :s
        controllersView.backgroundColor = coverImageView.image?.averageColor.withAlphaComponent(0.5) ?? UIColor.white
        
        
        /****
         * Set up Player
         ****/
        
        
        
        
        /****
         * Start Player
         ****/
        updater = CADisplayLink(target: self, selector: #selector(updateAudioProgressView))
        updater.preferredFramesPerSecond = 1
//        print((updater.targetTimestamp - updater.timestamp))
        updater.add(to: .current, forMode: .commonModes)
        
        // Set Playbuttons
        playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButton(_:)))
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseButton(_:)))
        
        
        // set player buttonIndex
        if musicPlayer.isNotPlaying {
            let buttonIndex = toolbar.items?.index(where: { $0 == (musicPlayButton ?? pauseButton) })
            toolbar.items![buttonIndex!] = playButton
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        updater.invalidate()
    }
    
    // MARK: - IBActions
    @IBAction func playButton(_ sender: UIBarButtonItem) {
        musicPlayer.play()
        
        let buttonIndex = toolbar.items?.index(where: { $0 == sender})
        toolbar.items![buttonIndex!] = pauseButton
    }
    
    @IBAction func pauseButton(_ sender: UIBarButtonItem) {
        musicPlayer.pause()
        
        let buttonIndex = toolbar.items?.index(where: { $0 == sender})
        toolbar.items![buttonIndex!] = playButton
    }
    
    @IBAction func fastForward(_ sender: UIBarButtonItem) {
        musicPlayer.fastForward()
        if musicPlayer.stopped {
            resetProgress()
        }
    }
    
    @IBAction func fastBackward(_ sender: UIBarButtonItem) {
        musicPlayer.fastBackward()
        if musicPlayer.stopped {
            resetProgress()
        }
    }
    
    @IBAction func slide(_ sender: UISlider) {
        musicPlayer.set(time: TimeInterval(sender.value))
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
//        TabBarViewController setupMinimizedPlayer()
    }
    
    
    // MARK: - Private Methods
    private func resetProgress() {
        progressSlider.setValue(0, animated: false)
        currentTimeLabel.text = musicPlayer.currentTime
        timeLeftLabel.text = musicPlayer.timeLeft
        
        // set pause to play
        if let buttonIndex = toolbar.items?.index(where: { $0 == (musicPlayButton ?? pauseButton) }) {
            toolbar.items![buttonIndex] = playButton
        }
    }
    
    func updateAudioProgressView() {
        progressSlider.setValue(musicPlayer.progress, animated: true)
        currentTimeLabel.text = musicPlayer.currentTime
        timeLeftLabel.text = musicPlayer.timeLeft
    }
    
    // MARK: UISetup
    private func configureProgresSlider() {
        progressSlider.setThumbImage(UIImage(named: "slider"), for: .normal)
    }
}
