//
//  Playercell.swift
//  SportsGravy
//
//  Created by CSS on 24/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class Playercell: UITableViewCell {
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var gender_lbl: UILabel!
    @IBOutlet weak var active_user_imag: UIImageView!
    @IBOutlet weak var invite_btn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
