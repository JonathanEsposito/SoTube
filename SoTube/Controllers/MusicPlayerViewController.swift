//
//  MusicPlayerViewController.swift
//  SoTube
//
//  Created by .jsber on 12/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit
import CoreImage

class MusicPlayerViewController: UIViewController, PaymentDelegate {

    // MARK: - Properties
    @IBOutlet weak var buyTrackButton: UIBarButtonItem!
    @IBOutlet weak var controllersView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
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
        
        let track = musicPlayer.track
        
        if track!.bought || guestuser {
            buyTrackButton.isEnabled = false
        } else {
            buyTrackButton.isEnabled = true
        }
        
        dump(track)
        albumCoverImageView.image(fromLink: track?.coverUrl ?? "") { image in
            // Set controller backgroundColor to averige of cover
            //        controllersView.backgroundColor = coverImageView.image!.areaAverage().withAlphaComponent(0.5) // To slow :s
            self.controllersView.backgroundColor = image.averageColor.withAlphaComponent(0.5) ?? UIColor.white
        }
        trackTitleLabel.text = track?.name ?? ""
        artistAndAlbumLabel.text =  "\(track?.artistName ?? "") - \(track?.albumName ?? "")"
        
        //
        configureProgresSlider()
        
        // set toolbar background transparent
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        
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
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        print("share")
        let currentTrack = musicPlayer.track
        let activityViewController = UIActivityViewController(activityItems: [currentTrack], applicationActivities: nil)
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
                database.getCoins { currentCoins in
                    if (currentCoins - coinsPerTrackRate) > 0 {
                        let alertController = UIAlertController(title: "SoTunes Store", message: "You are about to buy \"\(track.name)\" by \"\(track.artistName)\" for \(coinsPerTrackRate) SoCoins.\n\nCurrently you have \(currentCoins) SoCoins.\nAfter buying this song you will have \(currentCoins - coinsPerTrackRate) SoCoins left.\n\nDo you want to continue?", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        
                        let buyTrackAction = UIAlertAction(title: "Buy this track!", style: .default, handler: { _ in
                            self.database.buy(track, withCoins: coinsPerTrackRate, onCompletion: { error in
                                DispatchQueue.main.async {
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("track bought :D")
                                        track.bought = true
                                        self.buyTrackButton.isEnabled = false
                                    }
                                }
                            })
                        })
                        alertController.addAction(buyTrackAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    } else {
                        let alertController = UIAlertController(title: "SoTunes Store", message: "You are about to buy \"\(track.name)\" by \"\(track.artistName)\" for \(coinsPerTrackRate) SoCoins.\n\nSadly you currently only have \(currentCoins) SoCoins left.\nWould you want to top up your acount?", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        let topUpAccount = UIAlertAction(title: "Topup account", style: .default, handler: { _ in
                            self.presentTopUpAlertController(onCompletion: { amount in
                                if let price = self.paymentViewModel.pricePerAmount[amount] {
                                    let coinPurchase = CoinPurchase(amount: amount, price: price)
                                    print("I'm buying!!")
                                    self.database.updateCoins(with: coinPurchase) {
                                        print("bought coins :D")
                                    }
                                }
                            })
                        })
                        alertController.addAction(topUpAccount)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
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
