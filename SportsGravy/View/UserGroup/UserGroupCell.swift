//
//  UserGroupCell.swift
//  SportsGravy
//
//  Created by CSS on 14/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class UserGroupCell: UITableViewCell {
    @IBOutlet weak var delete_enable_img: UIImageView!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var displayName_lbl: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
