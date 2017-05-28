//
//  TabBarViewController.swift
//  TableViewExperiments
//
//  Created by .jsber on 10/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

var selectedTabBarItemWithTitle = "Store"

class TabBarViewController: UIViewController, UITabBarDelegate,MinimizedPlayerDelegate {
    // MARK: - Properties
    
    // UserDefaults
    let kuserDefaultsEmailKey = "userEmail"
    let kuserDefaultsPasswordKey = "userPassword"
    let userDefaults = UserDefaults.standard
    
    var guestuser: Bool {
        return userDefaults.object(forKey: kuserDefaultsEmailKey) == nil ||
        userDefaults.object(forKey: kuserDefaultsPasswordKey) == nil
    }
    
    var updater: CADisplayLink! = nil
    
    let musicProgressView = UIProgressView()
    var miniPlayer: MinimizedPlayer! = nil
    var tabBar = UITabBar()
    var rightTabBar = UITabBar()
    
//    var database = DatabaseViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up all tabbar related navigations
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        print(musicPlayer.isPlaying)
        
        
        updateMiniPlayer()
        // I should put this in a function!!
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if updater != nil {
            updater.invalidate()
        }
    }
    
    // MARK: - Constraints Size Classes
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
//        if !sharedConstraints[0].isActive {
//            // Activating shared constraints
//            NSLayoutConstraint.activate(sharedConstraints)
//        }
        
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.deactivate(regularConstraints)
            // Activating compact constraints
            NSLayoutConstraint.activate(compactConstraints)
            
            // Set minimizedPlayer background
            if miniPlayer != nil {
                miniPlayer.backgroundColor = UIColor.clear
                miniPlayer.setBackgroundImage(UIImage(named: ""), forToolbarPosition: .any, barMetrics: .default)
                miniPlayer.clipsToBounds = false
            }
            
        } else {
            if compactConstraints.count > 0 && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            // Activating regular constraints
            NSLayoutConstraint.activate(regularConstraints)
            
            // clean up minimizedPlayer background
            if miniPlayer != nil {
                miniPlayer.backgroundColor = UIColor.clear
                miniPlayer.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
                miniPlayer.clipsToBounds = true
            }
        }
    }
    
    // MARK: - TabBarDelegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //This method will be called when user changes tab.
        guard let tabBarItemTitle = item.title else {
            print("item has no title")
            return
        }
        
        switch tabBarItemTitle {
        case "Account":
            print("Account")
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            guard let navigationController = storyboard.instantiateViewController(withIdentifier: "AccountFirstNavigationController") as? UINavigationController else {
                print("Couldn't find account navigation controller")
                return
            }
            selectedTabBarItemWithTitle = tabBarItemTitle
            UIApplication.shared.keyWindow?.rootViewController = navigationController
            self.dismiss(animated: true, completion: nil)
        case "My music":
            print("My music")
            let storyboard = UIStoryboard(name: "MusicViews", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "AlbumsNavCont") as? UINavigationController {
                if selectedTabBarItemWithTitle != tabBar.selectedItem?.title {
                    selectedTabBarItemWithTitle = tabBarItemTitle
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
            } else { print("no AlbumsNavCont") }
            
        case "Store":
            print("Store")
            let storyboard = UIStoryboard(name: "Store", bundle: nil)
            guard let navigationController = storyboard.instantiateViewController(withIdentifier: "storeNavCont") as? UINavigationController else { print("Couldn't find account navigation controller"); return }
            selectedTabBarItemWithTitle = tabBarItemTitle
            UIApplication.shared.keyWindow?.rootViewController = navigationController
            self.dismiss(animated: true, completion: nil)
        
        case "Login":
            print("Login")
            // Go to login screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            UIApplication.shared.keyWindow?.rootViewController = loginViewController
            self.dismiss(animated: true, completion: nil)
            
        case "Create Account":
            print("Create Account")
            // Go to Create Account screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let createNewAccountController = storyboard.instantiateViewController(withIdentifier: "createAccountVC")
            self.present(createNewAccountController, animated: true, completion: nil)
            tabBar.selectedItem = tabBar.items![0]
            
        default:
            break
        }
    }
    
    // MARK: - Private Methodes
    private func setupTabBar() {
        
        // Create tab bar
        tabBar = UITabBar(frame: CGRect(x: 0, y: self.view.bounds.height - 50, width: self.view.bounds.width, height: 50))
        
        let accountBarItem = UITabBarItem(title: "Account", image: #imageLiteral(resourceName: "accountButton"), selectedImage: #imageLiteral(resourceName: "accountButton"))
        let myMusicBarItem = UITabBarItem(title: "My music", image: #imageLiteral(resourceName: "musicButton"), selectedImage: #imageLiteral(resourceName: "musicButton"))
        let storeBarItem = UITabBarItem(title: "Store", image: #imageLiteral(resourceName: "shopButton"), selectedImage: #imageLiteral(resourceName: "shopButton"))
        
        let loginBarItem = UITabBarItem(title: "Login", image: #imageLiteral(resourceName: "accountButton"), selectedImage: #imageLiteral(resourceName: "accountButton"))
        let createAccountBarItem = UITabBarItem(title: "Create Account", image: #imageLiteral(resourceName: "accountButton"), selectedImage: #imageLiteral(resourceName: "accountButton"))
        
        if self.guestuser {
            tabBar.setItems([storeBarItem, loginBarItem, createAccountBarItem], animated: false)
        } else {
            // Add all tab bar items to our tab bar
            tabBar.setItems([accountBarItem, myMusicBarItem, storeBarItem], animated: false)
        }
        
        // Load tab bar in view
        self.view.addSubview(tabBar)
        
        // Autolayout: Set navigationbar to top of view
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        
        tabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tabBar.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tabBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        // Add an empty tab bar to the right too
        rightTabBar = UITabBar(frame: CGRect(x: 0, y: self.view.bounds.height - 50, width: self.view.bounds.width, height: 50))
        
        self.view.addSubview(rightTabBar)
        
        // AutoLayout
        rightTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        rightTabBar.leadingAnchor.constraint(equalTo: tabBar.trailingAnchor).isActive = true
        rightTabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        rightTabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        rightTabBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
        // Set tab bar delegate
        weak var weakSelf = self
        tabBar.delegate = weakSelf
        
        // select right tab bar item
        let selectedTab = tabBar.items!.filter({ $0.title == selectedTabBarItemWithTitle })
        tabBar.selectedItem = selectedTab.first
    }
    
    // Create Minimized Music Player
    private func setupMinimizedPlayer() {
        
        miniPlayer = MinimizedPlayer.loadFromNib()
        miniPlayer.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        weak var weakSelf = self
        miniPlayer.minimizedPlayerDelegate = weakSelf
        
        self.view.addSubview(miniPlayer)
        
        // Autolayout
        miniPlayer.translatesAutoresizingMaskIntoConstraints = false
        
        compactConstraints.append(contentsOf: [
            miniPlayer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            miniPlayer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            miniPlayer.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -50),
            miniPlayer.heightAnchor.constraint(equalToConstant: 44)
            ])
        
        regularConstraints.append(contentsOf: [
            miniPlayer.leadingAnchor.constraint(equalTo: self.rightTabBar.leadingAnchor, constant: 20),
            miniPlayer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            miniPlayer.bottomAnchor.constraint(equalTo: self.rightTabBar.bottomAnchor, constant: -2),
            miniPlayer.heightAnchor.constraint(equalToConstant: 44)
            ])
        
        
        // Set progressBar
        musicProgressView.setProgress(0, animated: false)
        self.view.insertSubview(musicProgressView, aboveSubview: miniPlayer)
        
        // AutoLayout
        musicProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        compactConstraints.append(contentsOf: [
            musicProgressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            musicProgressView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            musicProgressView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -50),
            musicProgressView.heightAnchor.constraint(equalToConstant: 2)
            ])
        
        regularConstraints.append(contentsOf: [
            musicProgressView.leadingAnchor.constraint(equalTo: self.rightTabBar.leadingAnchor, constant: 20),
            musicProgressView.trailingAnchor.constraint(equalTo: self.rightTabBar.trailingAnchor, constant: 0),
            musicProgressView.bottomAnchor.constraint(equalTo: self.rightTabBar.bottomAnchor),
            musicProgressView.heightAnchor.constraint(equalToConstant: 5)
            ])
        
        updateAudioProgressView()
    }
    
    func updateMiniPlayer() {
        if musicPlayer.hasSong {
            if miniPlayer == nil {
                setupMinimizedPlayer()
            }
            
            if musicPlayer.isNotPlaying {
                if let buttonIndex = miniPlayer.items?.index(where: { $0 == (miniPlayer.musicPlayButton ?? miniPlayer.pauseButton) }) {
                    print(buttonIndex)
                    miniPlayer.items![buttonIndex] = miniPlayer.playButton
                    updateAudioProgressView()
                    print("updated")
                }
            } else {
                if let buttonIndex = miniPlayer.items?.index(where: { $0 == miniPlayer.playButton }) {
                    miniPlayer.items![buttonIndex] = miniPlayer.pauseButton
                    updateAudioProgressView()
                }
            }
        }
        self.traitCollectionDidChange(nil)
        setUpdater()
    }
    
    func updateAudioProgressView() {
        musicProgressView.setProgress(musicPlayer.progress, animated: true)
    }
    
    func setUpdater() {
        if musicPlayer.isPlaying {
            updater = CADisplayLink(target: self, selector: #selector(self.updateAudioProgressView))
            updater.preferredFramesPerSecond = 1
            updater.add(to: .current, forMode: .commonModes)
        }
    }
    
    
    // Minimized Player Delegate
    func present(_ view: UIViewController) {
        self.present(view, animated: true, completion: nil)
    }
}
