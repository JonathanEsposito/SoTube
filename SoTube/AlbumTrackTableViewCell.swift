//
//  AlbumTrackTableViewCell.swift
//  SoTube
//
//  Created by .jsber on 26/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

protocol AlbumTrakCellDelegate {
    func buySong(_: AlbumTrackTableViewCell)
}

class AlbumTrackTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var trackNumberLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackDurationLabel: UILabel!
    @IBOutlet weak var buyTrackButton: UIButton!
    
    // MARK: - Delegate
    var delegate: AlbumTrakCellDelegate?
    
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
