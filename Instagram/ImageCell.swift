//
//  ImageCell.swift
//  Instagram
//
//  Created by Lawrence Chong on 3/15/16.
//  Copyright © 2016 Lawrence Chong. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ImageCell: UITableViewCell {

    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var photoImage: PFImageView!
    
    
    var post: PFObject! {
        didSet {
            self.photoImage.file = post["media"] as? PFFile
            self.photoImage.loadInBackground()
            self.captionLabel.text = post["caption"] as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
