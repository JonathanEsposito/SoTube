//
//  TabBarViewController.swift
//  TableViewExperiments
//
//  Created by .jsber on 10/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController, UITabBarDelegate {
    // MARK: - Properties
    var selectedTabBarItemWithTitle = "My music"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up all tabbar related navigations
        tabBarSetup()
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
    private func tabBarSetup() {
        
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
}
