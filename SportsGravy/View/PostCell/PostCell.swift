//
//  PostCell.swift
//  SportsGravy
//
//  Created by CSS on 08/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var comment_lbl: UILabel!
    @IBOutlet weak var fav_count_lbl: UILabel!
    @IBOutlet weak var comment_count_lbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var postimageScroll: UIScrollView!
    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var postImageview: UIView!
    @IBOutlet weak var postimageviewHeight: NSLayoutConstraint!
    @IBOutlet weak var infoview: UIView!
    @IBOutlet weak var infoviewHeight: NSLayoutConstraint!
    @IBOutlet weak var info_btn: UIButton!
    @IBOutlet weak var like_btn: UIButton!
    @IBOutlet weak var comment_btn: UIButton!


    @IBOutlet weak var org_lbl: UILabel!
    @IBOutlet weak var sport_lbl: UILabel!
    @IBOutlet weak var season_lbl: UILabel!
    @IBOutlet weak var team_lbl: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        self.postimageScroll.isPagingEnabled = true
        self.postimageScroll.delegate = self
        self.pageControl.addTarget(self, action: #selector(turnPage), for: .valueChanged)
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = 5;
    }
  @objc func turnPage( aPageControl:UIPageControl)
    {
        let selectedPage: NSInteger  = self.pageControl.currentPage
        var frame: CGRect = self.bounds
        frame.origin.x = frame.size.width * CGFloat(selectedPage)
       frame.origin.y = 0
        self.postimageScroll.scrollRectToVisible(frame, animated: true)
      
       pageControl.currentPage = selectedPage;
    }

     //after at the end of scroll u need update the current page in the page control
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView )
    {
       let pageWidth: CGFloat = self.postimageScroll.frame.size.width;
        let page: Int =  Int((self.postimageScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1
      print("Current page -> %d",page)
      let xoffset: CGFloat = CGFloat(page) * self.postimageScroll.bounds.size.width;
        self.postimageScroll.contentOffset = CGPoint(x: xoffset, y: 0);
      self.pageControl.currentPage = page;
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
