//
//  PostCell.swift
//  SportsGravy
//
//  Created by CSS on 08/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var comment_lbl: UILabel!
    @IBOutlet weak var fav_count_lbl: UILabel!
    @IBOutlet weak var comment_count_lbl: UILabel!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
