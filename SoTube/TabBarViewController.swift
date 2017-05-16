//
//  TabBarViewController.swift
//  TableViewExperiments
//
//  Created by .jsber on 10/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController, UITabBarDelegate,MinimizedPlayerDelegate {
    // MARK: - Properties
    var selectedTabBarItemWithTitle = "My music"
    var updater: CADisplayLink! = nil
    let musicProgressView = UIProgressView()
    let player = MinimizedPlayer()
    
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
        
        if musicPlayer.hasSong {
            setupMinimizedPlayer()
            
            if musicPlayer.isNotPlaying {
                if let buttonIndex = player.items?.index(where: { $0 == (player.musicPlayButton ?? player.pauseButton) }) {
                    print(buttonIndex)
                    player.items![buttonIndex] = player.playButton
                    updateAudioProgressView()
                    print("updated")
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if updater != nil {
            updater.invalidate()
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
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as? TabBarViewController {
                print("will navigate")
                
                viewController.selectedTabBarItemWithTitle = tabBarItemTitle
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        case "My music":
            print("My music")
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlbumsVC") as? TabBarViewController {
                if selectedTabBarItemWithTitle != tabBar.selectedItem?.title {
                    viewController.selectedTabBarItemWithTitle = tabBarItemTitle
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
            }
        case "Store":
            print("Store")
            selectedTabBarItemWithTitle = tabBarItemTitle
        default:
            break
        }
    }
    
    // MARK: - Private Methodes
    private func setupTabBar() {
        
        // Create tab bar
        let tabBar = UITabBar(frame: CGRect(x: 0, y: self.view.bounds.height - 50, width: self.view.bounds.width, height: 50))
        
        let tabOneBarItem = UITabBarItem(title: "Account", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        let tabTwoBarItem = UITabBarItem(title: "My music", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named:"selectedImage2.png"))
        let tabThreeBarItem = UITabBarItem(title: "Store", image: UIImage(named: "defaultImage3.png"), selectedImage: UIImage(named:"selectedImage3.png"))
        
        // Add all tab bar items to our tab bar
        tabBar.setItems([tabOneBarItem, tabTwoBarItem, tabThreeBarItem], animated: false)
        
        // Load tab bar in view
        self.view.addSubview(tabBar)
        
        // Autolayout: Set navigationbar to top of view
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: tabBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: tabBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 200).isActive = true
        NSLayoutConstraint(item: tabBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: tabBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50.0).isActive = true
        
        
        // Add an empty tab bar to the left too
        let leftTabBar = UITabBar(frame: CGRect(x: 0, y: self.view.bounds.height - 50, width: self.view.bounds.width, height: 50))
        
        self.view.addSubview(leftTabBar)
        
        // AutoLayout
        leftTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: leftTabBar, attribute: .leading, relatedBy: .equal, toItem: tabBar, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: leftTabBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: leftTabBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: leftTabBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50.0).isActive = true
        
        
        
        
        // Set tab bar delegate
        weak var weakSelf = self
        tabBar.delegate = weakSelf
        
        // select right tab bar item
        let selectedTab = tabBar.items!.filter({ $0.title == self.selectedTabBarItemWithTitle })
        tabBar.selectedItem = selectedTab.first
    }
    
    // Create Minimized Music Player
    func setupMinimizedPlayer() {
        
        let player = MinimizedPlayer.loadFromNib()
        player.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        weak var weakSelf = self
        player.minimizedPlayerDelegate = weakSelf
        
        self.view.addSubview(player)
        
        // Autolayout
        player.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: player, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: player, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: player, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: -50.0).isActive = true
        NSLayoutConstraint(item: player, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 44.0).isActive = true
        
        
        
        // Set progressBar
        musicProgressView.setProgress(0, animated: false)
        self.view.insertSubview(musicProgressView, aboveSubview: player)
        
        
        // AutoLayout
        musicProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: musicProgressView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: musicProgressView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: musicProgressView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: -50.0).isActive = true
        NSLayoutConstraint(item: musicProgressView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 2.0).isActive = true

        updateAudioProgressView()
        
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
