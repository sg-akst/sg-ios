//
//  PostCell.swift
//  SportsGravy
//
//  Created by CSS on 08/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
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
    @IBOutlet weak var addinfoview_height: NSLayoutConstraint!
    @IBOutlet weak var shotImageView: UIImageView!


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
    @IBOutlet weak var addinfoview: UIView!
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var addinfo: UIView!
    var postImg: UIImageView!
       var videoview: AGVideoPlayerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func getInfoDetail(getinfodetailArray: NSMutableArray){

                let buttons: NSMutableArray = NSMutableArray()
                var indexOfLeftmostButtonOnCurrentLine: Int = 0
                var runningWidth: CGFloat = 0.0
                let maxWidth: CGFloat = UIScreen.main.bounds.size.width
                let horizontalSpaceBetweenButtons: CGFloat = 8.0
                let verticalSpaceBetweenButtons: CGFloat = 0.0
                if(self.addinfo != nil)
                {
                   self.addinfo.removeFromSuperview()
                }
                addinfo = UIView()
        addinfo.frame = addinfoview.bounds
                for i in 0..<getinfodetailArray.count
                {
                    let button_title = UIButton(type: .roundedRect)
        
                    button_title.titleLabel?.font = UIFont(name: "Arial", size: 14)
                    button_title.titleLabel?.textAlignment = .left
                    button_title.setTitleColor(UIColor.lightGray, for: .normal)
                    button_title.isUserInteractionEnabled = false
                    let title: String = getinfodetailArray[i] as! String
                    let index = title.index(of: ":")!
                    let prefix = title.suffix(from: index)

                    let substr = title.prefix(upTo: index)

                    if(title != "" && title != nil)
                    {
                      button_title.setTitle("\(getinfodetailArray[i] as! String)", for: .normal)
                    button_title.translatesAutoresizingMaskIntoConstraints = false
                    let attrStr = NSMutableAttributedString(string: "\(button_title.title(for: .normal) ?? "")")
                    button_title.titleLabel?.textColor = UIColor.lightGray
                    if(substr != "")
                    {
                        attrStr.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: substr.count+1))
                        button_title.setTitleColor(UIColor.black, for: .normal)
                    }
                   button_title.setAttributedTitle(attrStr, for: .normal)
                    button_title.sizeToFit()
                    button_title.tag = i
                    addinfo.addSubview(button_title)
                    if ((i == 0) || (runningWidth + button_title.frame.size.width > maxWidth))
                     {
                         runningWidth = button_title.frame.size.width
                        if(i==0)
                        {
                            // first button (top left)
                            // horizontal position: same as previous leftmost button (on line above)
                           let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button_title, attribute: .left, relatedBy: .equal, toItem: addinfo, attribute: .left, multiplier: 1.0, constant: horizontalSpaceBetweenButtons)
                           button_title.setAttributedTitle(attrStr, for: .normal)
                            addinfo.addConstraint(horizontalConstraint)
                            
                            // vertical position:
                            let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button_title, attribute: .top, relatedBy: .equal, toItem: addinfo, attribute: .top, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                            addinfo.addConstraint(verticalConstraint)

                        }
                        else{
                            // put it in new line
                            let previousLeftmostButton: UIButton = buttons.object(at: indexOfLeftmostButtonOnCurrentLine) as! UIButton

                            // horizontal position: same as previous leftmost button (on line above)
                            let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button_title, attribute: .left, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .left, multiplier: 1.0, constant: 0.0)
                            addinfo.addConstraint(horizontalConstraint)

                            // vertical position:
                            let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button_title, attribute: .top, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .bottom, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                            addinfo.addConstraint(verticalConstraint)
                            indexOfLeftmostButtonOnCurrentLine = i
                        }
                    }
                    else
                    {
                        runningWidth += button_title.frame.size.width + horizontalSpaceBetweenButtons;

                        let previousButton: UIButton = buttons.object(at: i-1) as! UIButton  //[buttons objectAtIndex:(i-1)];

                                   // horizontal position: right from previous button
                        let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button_title, attribute: .left, relatedBy: .equal, toItem: previousButton, attribute: .right, multiplier: 1.0, constant: horizontalSpaceBetweenButtons)
                        addinfo.addConstraint(horizontalConstraint)
                            
                                   // vertical position same as previous button
                        let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button_title, attribute: .top, relatedBy: .equal, toItem: previousButton, attribute: .top, multiplier: 1.0, constant: 0.0)
                        addinfo.addConstraint(verticalConstraint)

                    }
                    buttons.add(button_title)
                }
                    
                }
               
                self.addinfoview.addSubview(addinfo)
                addinfoview_height.constant = 60
               if(indexOfLeftmostButtonOnCurrentLine > 0)
                {
                self.addinfoview_height.constant = (indexOfLeftmostButtonOnCurrentLine > 0) ? 80 : 60
                if(indexOfLeftmostButtonOnCurrentLine > 5)
                                             {
                                                        
                self.addinfoview_height.constant = (indexOfLeftmostButtonOnCurrentLine > 0) ? 110 : 80
                                                        
                                             }
                                             }
            }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
