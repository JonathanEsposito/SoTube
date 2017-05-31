//
//  StoreTrackTableViewCell.swift
//  SoTube
//
//  Created by .jsber on 31/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

protocol SearchTrakCellDelegate {
    func buySong(_: SearchTrackTableViewCell)
}

class SearchTrackTableViewCell: UITableViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var buyTrackButton: UIButton!
    
    // MARK: - Delegate
    var delegate: SearchTrakCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    // MARK: - IBActions
    @IBAction func buySong(_ sender: UIButton) {
        print("clicked")
        weak var weakSelf = self
        self.delegate?.buySong(weakSelf!)
    }
}
