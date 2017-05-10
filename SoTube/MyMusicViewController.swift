//
//  MyMusicViewController.swift
//  TableViewExperiments
//
//  Created by .jsber on 09/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class MyMusicViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("boe")
        navigationBarSetup()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func displayLibraryAs(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let showSongs = UIAlertAction(title: "Songs", style: UIAlertActionStyle.default, handler: { (alert :UIAlertAction!) in
            print("Songs")
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SongsVC") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        })
        alertController.addAction(showSongs)
        let showAlbums = UIAlertAction(title: "Albums", style: UIAlertActionStyle.default, handler: { (alert :UIAlertAction!) in
            print("Albums")
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlbumsVC") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        })
        alertController.addAction(showAlbums)
        let showArtists = UIAlertAction(title: "Artists", style: UIAlertActionStyle.default, handler: { (alert :UIAlertAction!) in
            print("Artists")
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ArtistsVC") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        })
        alertController.addAction(showArtists)
        let showGenres = UIAlertAction(title: "Genres", style: UIAlertActionStyle.default, handler: { (alert :UIAlertAction!) in
            print("Genres")
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "GenresVC") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        })
        alertController.addAction(showGenres)
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel/*.default*/, handler: {(alert :UIAlertAction!) in
            print("Cancel button tapped")
        })
        alertController.addAction(cancelAction)
        
        
        alertController.popoverPresentationController?.barButtonItem = sender
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func displaySortMenu(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
        
        let showSongs = UIAlertAction(title: "Name", style: UIAlertActionStyle.default, handler: { (alert :UIAlertAction!) in
            print("Name")
            //            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SongsVC") {
            //                UIApplication.shared.keyWindow?.rootViewController = viewController
            //                self.dismiss(animated: true, completion: nil)
            //            }
        })
        alertController.addAction(showSongs)
        let showAlbums = UIAlertAction(title: "Album", style: UIAlertActionStyle.default, handler: { (alert :UIAlertAction!) in
            print("Album")
            //            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlbumsVC") {
            //                UIApplication.shared.keyWindow?.rootViewController = viewController
            //                self.dismiss(animated: true, completion: nil)
            //            }
        })
        alertController.addAction(showAlbums)
        let showArtists = UIAlertAction(title: "Artist", style: UIAlertActionStyle.default, handler: { (alert :UIAlertAction!) in
            print("Artist")
            //            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ArtistsVC") {
            //                UIApplication.shared.keyWindow?.rootViewController = viewController
            //                self.dismiss(animated: true, completion: nil)
            //            }
        })
        alertController.addAction(showArtists)
        let showGenres = UIAlertAction(title: "Year", style: UIAlertActionStyle.default, handler: { (alert :UIAlertAction!) in
            print("Year")
            //            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "GenresVC") {
            //                UIApplication.shared.keyWindow?.rootViewController = viewController
            //                self.dismiss(animated: true, completion: nil)
            //            }
        })
        alertController.addAction(showGenres)
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel/*.default*/, handler: {(alert :UIAlertAction!) in
            print("Cancel button tapped")
        })
        alertController.addAction(cancelAction)
        
        
        alertController.popoverPresentationController?.barButtonItem = sender
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    // Set up navigation bar
    func navigationBarSetup() {
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 64))
        let navItem = UINavigationItem(title: "")
        let library = UIBarButtonItem(title: self.title ?? "", style: UIBarButtonItemStyle.plain, target: nil, action: #selector(displayLibraryAs(_:)))
        let sort = UIBarButtonItem(title: "Sort by", style: UIBarButtonItemStyle.plain, target: nil, action: #selector(displaySortMenu(_:)))
        //        let search = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
        
        navItem.leftBarButtonItem = library
        navItem.rightBarButtonItem = sort
        
        navBar.setItems([navItem], animated: false)
        
        self.view.addSubview(navBar)
        
        // Remove background and shadow
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        
        // Autolayout: Set navigationbar to top of view
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: navBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: navBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: navBar, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -20.0).isActive = true
        NSLayoutConstraint(item: navBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 64.0).isActive = true
        
    }
}
