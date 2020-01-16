//
//  TagCell.swift
//  SportsGravy
//
//  Created by CSS on 16/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {

    @IBOutlet weak var delete_enable_img: UIButton!
    @IBOutlet weak var username_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
