//
//  UsergroupCreateCell.swift
//  SportsGravy
//
//  Created by CSS on 20/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class UsergroupCreateCell: UITableViewCell {
    
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var member_name_lbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
