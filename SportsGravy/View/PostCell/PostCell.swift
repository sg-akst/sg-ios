//
//  PostCell.swift
//  SportsGravy
//
//  Created by CSS on 08/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PostCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var comment_lbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var postimageScroll: UIScrollView!
    @IBOutlet weak var pageControl : UIPageControl!
   // @IBOutlet weak var postImageview: UIView!
    @IBOutlet weak var postimageviewHeight: NSLayoutConstraint!
    @IBOutlet weak var comment_lbl_height: NSLayoutConstraint!

    @IBOutlet weak var postVideoviewHeight: NSLayoutConstraint!

    @IBOutlet weak var infoview: UIView!
    @IBOutlet weak var infoviewHeight: NSLayoutConstraint!
    @IBOutlet weak var info_btn: UIButton!
    @IBOutlet weak var like_btn: UIButton!
    @IBOutlet weak var comment_btn: UIButton!


    @IBOutlet weak var org_title_lbl: UILabel!
    @IBOutlet weak var sport_title_lbl: UILabel!
    @IBOutlet weak var season_title_lbl: UILabel!
    @IBOutlet weak var level_title_lbl: UILabel!
    @IBOutlet weak var team_title_lbl: UILabel!
    @IBOutlet weak var group_title_lbl: UILabel!
    @IBOutlet weak var player_title_lbl: UILabel!


    
    @IBOutlet weak var org_lbl: UILabel!
    @IBOutlet weak var sport_lbl: UILabel!
    @IBOutlet weak var season_lbl: UILabel!
    @IBOutlet weak var team_lbl: UILabel!
    @IBOutlet weak var level_lbl: UILabel!
    @IBOutlet weak var group_lbl: UILabel!
    @IBOutlet weak var player_lbl: UILabel!

    
    
    
    @IBOutlet weak var video_view: UIView!
    @IBOutlet weak var tag_btn: UIButton!
    @IBOutlet weak var reaction_btn: UIButton!
    @IBOutlet weak var profile_view: UIView!

    

   


    override func awakeFromNib() {
        super.awakeFromNib()
        
    }


     //after at the end of scroll u need update the current page in the page control
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
