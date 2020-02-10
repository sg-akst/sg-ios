//
//  CommentCell.swift
//  SportsGravy
//
//  Created by CSS on 06/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var postdate_lbl: UILabel!
    @IBOutlet weak var comment_lbl: UILabel!
    @IBOutlet weak var profile_img: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
