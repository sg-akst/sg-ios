//
//  FeedSelectorCell.swift
//  SportsGravy
//
//  Created by CSS on 03/03/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class FeedSelectorCell: UITableViewCell {
    @IBOutlet weak var feed_name_Btn: UIButton!
    @IBOutlet weak var feed_img_Btn: UIButton!
    @IBOutlet weak var feed_count_Btn: UIButton!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
