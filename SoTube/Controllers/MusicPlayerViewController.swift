//
//  MusicPlayerViewController.swift
//  SoTube
//
//  Created by .jsber on 12/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit
import CoreImage
import MediaPlayer

class MusicPlayerViewController: UIViewController, PaymentDelegate {
    
    var forDevice: Bool = true

    // MARK: - Properties
    @IBOutlet weak var buyTrackButton: UIBarButtonItem!
    @IBOutlet weak var controllersView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var volumeControlSlider: UISlider!
    @IBOutlet weak var volumeControllerSliderView: UIView!
    
    @IBOutlet weak var fastBackwardButton: UIBarButtonItem!
    @IBOutlet weak var musicPlayButton: UIBarButtonItem!
    @IBOutlet weak var fastForwardButton: UIBarButtonItem!
    
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var artistAndAlbumLabel: UILabel!
    @IBOutlet weak var albumCoverImageView: UIImageView!
    
    let database = DatabaseViewModel()
    let paymentViewModel = PaymentViewModel()
    
    var updater: CADisplayLink! = nil
    var songURL: URL?
    
    var playButton: UIBarButtonItem!
    var pauseButton: UIBarButtonItem!
    
    var pausePlayButtonIndex = 4
    
    // Observe musicPlayer
    var playerIsPlayingContext = 0
    
    var observingMusicPlayer: Bool = false {
        didSet {
            if observingMusicPlayer {
                // Set Player observer
                weak var weakSelf = self
                musicPlayer.player.addObserver(weakSelf!, forKeyPath: "isPlaying", options: .new, context: &playerIsPlayingContext)
            }
        }
    }
    
    // UserDefaults
    let kuserDefaultsEmailKey = "userEmail"
    let kuserDefaultsPasswordKey = "userPassword"
    let userDefaults = UserDefaults.standard
    
    var guestuser: Bool {
        return userDefaults.object(forKey: kuserDefaultsEmailKey) == nil ||
            userDefaults.object(forKey: kuserDefaultsPasswordKey) == nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // set toolbar background transparent
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        
        // Hide navigationbar
        self.navigationController?.isNavigationBarHidden = true
        
        configureUIOfProgresSlider()
        
        if forDevice {
            // Hide classic volumeController
            volumeControlSlider.isHidden = true
            
            let rect = self.view.bounds
            
            // Set Device volume controller
            let wrapperView = UIView(frame: CGRect(x: 0, y: 0, width: ( rect.width - 100 ), height: 20))
            let volumeView = MPVolumeView(frame: wrapperView.bounds)

            volumeControllerSliderView.addSubview(volumeView)
        }
        
        // Get playing track
        let track = musicPlayer.track
        
        if track!.bought || guestuser {
            buyTrackButton.isEnabled = false
        } else {
            buyTrackButton.isEnabled = true
        }
        
        // Get and Set AlbumCover
        if let albumCover = musicPlayer.cover {
            print("has albumcover")
            albumCoverImageView.image = albumCover
            self.controllersView.backgroundColor = albumCover.averageColor.withAlphaComponent(0.5)
        } else {
            albumCoverImageView.image(fromLink: track?.coverUrl ?? "") { [weak self] image in
                // Set controller backgroundColor to averige of cover
                //        controllersView.backgroundColor = coverImageView.image!.areaAverage().withAlphaComponent(0.5) // To slow :s
                self!.controllersView.backgroundColor = image.averageColor.withAlphaComponent(0.5)
            }
        }
        
        // Set other labels
        trackTitleLabel.text = track?.name ?? ""
        artistAndAlbumLabel.text =  "\(track?.artistName ?? "") - \(track?.albumName ?? "")"
        
        
        
        /****
         * Set up Player
         ****/
        updateAudioProgressView()
        
        
        // Start observing player
        observingMusicPlayer = true
//
//        startUpdater()
        
        // Set play button index
        if let index = toolbar.items?.index(of: musicPlayButton) {
            self.pausePlayButtonIndex = index
        }
        
        
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
        stopUpdater()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    deinit {
        if observingMusicPlayer {
            // Remove previously added observers
            musicPlayer.player.removeObserver(self, forKeyPath: "isPlaying", context: &playerIsPlayingContext)
        }
    }
    
    // MARK: - Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("update!")
        switch object! {
        case let player as MusicPlayerModel where player.isPlaying == true:
            self.setButton(to: .pause)
            // Set up progressbar tracker
            startUpdater()
            
        case let player as MusicPlayerModel where player.isPlaying == false:
            self.setButton(to: .play)
            // Dismiss tracker
            stopUpdater()
            updateAudioProgressView()
            
        default:
            break
        }
    }
    
    // MARK: - IBActions
    @IBAction func playButton(_ sender: UIBarButtonItem) {
        musicPlayer.resume()
    }
    
    @IBAction func pauseButton(_ sender: UIBarButtonItem) {
        musicPlayer.pause()
    }
    
    @IBAction func fastForward(_ sender: UIBarButtonItem) {
        musicPlayer.fastForward()
    }
    
    @IBAction func fastBackward(_ sender: UIBarButtonItem) {
        musicPlayer.fastBackward()
    }
    
    @IBAction func slide(_ sender: UISlider) {
        stopUpdater()
        let currentSliderValue = sender.value
        let currentTime = musicPlayer.duration * Double(currentSliderValue)
        let timeLeft = musicPlayer.duration - currentTime
        currentTimeLabel.text = string(fromTimeInterval: currentTime)//"\(currentTime)"
        timeLeftLabel.text = "-\(string(fromTimeInterval: timeLeft))"
    }
    
    @IBAction func seekTo(_ sender: UISlider) {
        startUpdater()
        musicPlayer.set(time: TimeInterval(sender.value))
    }
    
//    @IBAction func seekslide(_ sender: UISlider) {
//        musicPlayer.set(time: TimeInterval(sender.value))
//    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
//        TabBarViewController setupMinimizedPlayer()
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        print("share")
        let currentTrack = musicPlayer.track
        let activityViewController = UIActivityViewController(activityItems: [currentTrack!], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.postToVimeo]
        self.present(activityViewController, animated: true, completion: { _ in })
    }
    
    @IBAction func buyCurrentTrack(_ sender: UIBarButtonItem) {
        // If there is a logged in user
        if self.guestuser {
            let alertController = UIAlertController(title: "SoTunes Store", message: "As a guest you can only preview tracks but not buy track. Do you want to create an account or log in?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let creatAccountAction = UIAlertAction(title: "Create new account", style: .default, handler: { _ in
                // Go to Create Account screen
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let createNewAccountController = storyboard.instantiateViewController(withIdentifier: "createAccountVC")
                self.present(createNewAccountController, animated: true, completion: nil)
                //                UIApplication.shared.keyWindow?.rootViewController = createNewAccountController
                //                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(creatAccountAction)
            let loginAction = UIAlertAction(title: "Log in", style: .default, handler: { _ in
                // Go to login screen
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                UIApplication.shared.keyWindow?.rootViewController = loginViewController
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(loginAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            if let track = musicPlayer.track {
                database.getCoins { [weak self] currentCoins in
                    if (currentCoins - coinsPerTrackRate) > 0 {
                        let alertController = UIAlertController(title: "SoTunes Store", message: "You are about to buy \"\(track.name)\" by \"\(track.artistName)\" for \(coinsPerTrackRate) SoCoins.\n\nCurrently you have \(currentCoins) SoCoins.\nAfter buying this song you will have \(currentCoins - coinsPerTrackRate) SoCoins left.\n\nDo you want to continue?", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        
                        let buyTrackAction = UIAlertAction(title: "Buy this track!", style: .default, handler: { _ in
                            self?.database.buy(track, withCoins: coinsPerTrackRate, onCompletion: { error in
                                DispatchQueue.main.async {
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("track bought :D")
                                        musicPlayer.restrictedDuration = nil
                                        track.bought = true
                                        self?.buyTrackButton.isEnabled = false
                                    }
                                }
                            })
                        })
                        alertController.addAction(buyTrackAction)
                        self?.present(alertController, animated: true, completion: nil)
                        
                    } else {
                        let alertController = UIAlertController(title: "SoTunes Store", message: "You are about to buy \"\(track.name)\" by \"\(track.artistName)\" for \(coinsPerTrackRate) SoCoins.\n\nSadly you currently only have \(currentCoins) SoCoins left.\nWould you want to top up your acount?", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        let topUpAccount = UIAlertAction(title: "Topup account", style: .default, handler: { _ in
                            self?.presentTopUpAlertController(onCompletion: { amount in
                                if let price = self!.paymentViewModel.pricePerAmount[amount] {
                                    let coinPurchase = CoinPurchase(amount: amount, price: price)
                                    print("I'm buying!!")
                                    self?.database.updateCoins(with: coinPurchase) {
                                        print("bought coins :D")
                                    }
                                }
                            })
                        })
                        alertController.addAction(topUpAccount)
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - Private Methods
    func setButton(to buttonState: PlayerButtonState) {
        switch buttonState {
        case .play:
            self.toolbar.items![pausePlayButtonIndex] = playButton
        case .pause:
            self.toolbar.items![pausePlayButtonIndex] = pauseButton
        }
    }
    
//    private func resetProgress() {
//        progressSlider.setValue(0, animated: false)
//        currentTimeLabel.text = musicPlayer.currentTime
//        timeLeftLabel.text = musicPlayer.timeLeft
//        
//        // set pause to play
//        if let buttonIndex = toolbar.items?.index(where: { $0 == (musicPlayButton ?? pauseButton) }) {
//            toolbar.items![buttonIndex] = playButton
//        }
//    }
    
    func updateAudioProgressView() {
        progressSlider.setValue(musicPlayer.progress, animated: true)
        currentTimeLabel.text = musicPlayer.currentTime
        timeLeftLabel.text = musicPlayer.timeLeft
    }
    
    func startUpdater() {
        if musicPlayer.isPlaying {
            updater = CADisplayLink(target: self, selector: #selector(updateAudioProgressView))
            if #available(iOS 10.0, *) {
                updater.preferredFramesPerSecond = 20
            } else {
                // Fallback on earlier versions
                updater.frameInterval = 1
            }
            updater.add(to: .current, forMode: .commonModes)
        }
    }
    
    func stopUpdater() {
        if updater != nil {
            updater.invalidate()
        }
    }
    
    // MARK: UISetup
    private func configureUIOfProgresSlider() {
        progressSlider.setThumbImage(UIImage(named: "slider"), for: .normal)
    }
    
    // MARK: - Private Objects
    enum PlayerButtonState {
        case play, pause
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
