//
//  InviteCell.swift
//  SportsGravy
//
//  Created by CSS on 10/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class InviteCell: UITableViewCell {
    
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var playername: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
