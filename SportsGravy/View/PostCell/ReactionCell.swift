//
//  ReactionCell.swift
//  SportsGravy
//
//  Created by CSS on 14/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class ReactionCell: UITableViewCell {
    
    @IBOutlet weak var reation_image: UIImageView!
    @IBOutlet weak var reaction_title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
