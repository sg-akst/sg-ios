//
//  SideMenuCell.swift
//  SportsGravy
//
//  Created by CSS on 09/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    @IBOutlet weak var roleTitle_lbl: UILabel!
    @IBOutlet weak var roletype_lbl: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
         sizeToFit()
         layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
