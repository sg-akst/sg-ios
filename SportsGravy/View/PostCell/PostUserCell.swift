//
//  PostUserCell.swift
//  SportsGravy
//
//  Created by CSS on 17/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class PostUserCell: UITableViewCell {
    
    @IBOutlet weak var title_name_lbl: UILabel!
    @IBOutlet weak var groub_img: UIButton!
    @IBOutlet weak var imageBtn: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
