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
        
        let showSongs = UIAlertAction(title: "Songs", style: UIAlertActionStyle.destructive, handler: nil)
        alertController.addAction(showSongs)
        let showAlbums = UIAlertAction(title: "Albums", style: UIAlertActionStyle.destructive, handler: nil)
        alertController.addAction(showAlbums)
        let showArtists = UIAlertAction(title: "Artists", style: UIAlertActionStyle.destructive, handler: nil)
        alertController.addAction(showArtists)
        let showGenres = UIAlertAction(title: "Genres", style: UIAlertActionStyle.destructive, handler: nil)
        alertController.addAction(showGenres)
        
        
        alertController.popoverPresentationController?.barButtonItem = sender
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        present(alertController, animated: true, completion: nil)
    }
}
