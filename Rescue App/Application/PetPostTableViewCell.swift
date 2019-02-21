//
//  PetPostTableViewCell.swift
//  Rescue App
//
//  Created by Christopher Horton on 1/30/19.
//  Copyright © 2019 Unikorn. All rights reserved.
//

import UIKit

class PetPostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postImage.contentMode = UIView.ContentMode.scaleAspectFill
        postImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
