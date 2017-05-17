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

        // Set controller backgroundColor
        let color = averageColor(ofImage: coverImageView.image!)
        controllersView.backgroundColor = UIColor(patternImage: color).withAlphaComponent(0.5)
        
        
        /****
         * Set up Player
         ****/
        
        
        
        
        /****
         * Start Player
         ****/
        updater = CADisplayLink(target: self, selector: #selector(updateAudioProgressView))
        updater.preferredFramesPerSecond = 1
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
        let buttonIndex = toolbar.items?.index(where: { $0 == (musicPlayButton ?? pauseButton) })
        toolbar.items![buttonIndex!] = playButton
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
    
    private func averageColor(ofImage originalimage: UIImage) -> UIImage {
        
        let context = CIContext(options: nil)
        let convertImage = CIImage(image: originalimage)
        
        let filter = CIFilter(name: "CIAreaAverage")
        filter?.setValue(convertImage , forKey: kCIInputImageKey)
        
        let processImage = filter?.outputImage
        
        let finalImage = context.createCGImage(processImage!, from: processImage!.extent)
        
        let newImage = UIImage(cgImage: finalImage!)
        
        return newImage
    }
    
    private func thumbRectForBounds(bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return bounds
    }

}
