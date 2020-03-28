//
//  PostImageDetailCell.swift
//  SportsGravy
//
//  Created by CSS on 07/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class PostImageDetailCell: UITableViewCell {

    @IBOutlet weak var detail_btn: UIButton!
    @IBOutlet weak var commonview: UIView!
    @IBOutlet weak var cancel_btn: UIButton!
    @IBOutlet weak var reaction_img: UIImageView!
    @IBOutlet weak var common_view_width: NSLayoutConstraint!
    @IBOutlet weak var select_text_width: NSLayoutConstraint!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
