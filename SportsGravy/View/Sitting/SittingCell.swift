//
//  SittingCell.swift
//  SportsGravy
//
//  Created by CSS on 27/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class SittingCell: UITableViewCell {
    
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var subtitle_lbl: UILabel!
    @IBOutlet weak var segment_btn: UISwitch!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
