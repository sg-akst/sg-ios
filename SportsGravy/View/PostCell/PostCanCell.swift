//
//  PostCanCell.swift
//  SportsGravy
//
//  Created by CSS on 18/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class PostCanCell: UITableViewCell {
    
    @IBOutlet weak var can_title_lbl: UILabel!
    @IBOutlet weak var can_desc_lbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
