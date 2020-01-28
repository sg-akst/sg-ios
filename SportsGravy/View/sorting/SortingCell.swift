//
//  SortingCell.swift
//  SportsGravy
//
//  Created by CSS on 28/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class SortingCell: UITableViewCell {

    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var detail_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
