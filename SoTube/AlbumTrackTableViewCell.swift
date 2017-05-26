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
    
    // MARK: - Delegate
    var delegate: AlbumTrakCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }

//    // MARK: - LifeCycle
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    // MARK: - IBActions
    @IBAction func buySong(_ sender: UIButton) {
        print("clicked")
        self.delegate?.buySong(self)
    }
}
