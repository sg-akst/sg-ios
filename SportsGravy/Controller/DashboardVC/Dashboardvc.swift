//
//  Dashboardvc.swift
//  SportsGravy
//
//  Created by CSS on 07/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import SWRevealViewController
import FirebaseFirestore
import Alamofire
//import AlamofireImage
import Firebase
import AVKit
import Kingfisher


class Dashboardvc: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, sidemenuDelegate, FeedSelectorDelegate {
    func feedselectDashboard(selectitem: NSDictionary, selectName: String) {
        
        
    }
    
    
    
    func feddSelectDetail(userDetail: NSMutableArray, selectitemname: String) {
        
        self.postvielname_lbl.text = selectitemname
         self.postvielname_lbl.backgroundColor = UIColor.white
         self.postvielname_lbl.textColor = UIColor.gray
         self.postvielname_lbl.layer.cornerRadius = 5
         self.postvielname_lbl.layer.borderWidth = 0.5
         self.postvielname_lbl.layer.borderColor = UIColor.lightGray.cgColor
         self.postvielname_lbl.layer.masksToBounds = true
        if(cancel_btn != nil)
        {
            cancel_btn.removeFromSuperview()
        }
         cancel_btn = UIButton()
          //let size = (selectitemname as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
         cancel_btn.frame = CGRect(x:self.postvielname_lbl.frame.origin.x + self.postvielname_lbl.frame.size.width-30, y: 10, width: 25, height: 25)
         cancel_btn.addTarget(self, action: #selector(selectitemRemove), for: .touchUpInside)
         cancel_btn.isHidden  = false
         cancel_btn.setImage(UIImage(named: "cancel"), for: .normal)
         cancel_btn.tintColor = UIColor.black
        cancel_btn.addTarget(self, action: #selector(CancelFeedFilter), for: .touchUpInside)
         self.displayselectitem.addSubview(cancel_btn)
         
        
         self.feedfilter(feeddetail: userDetail[0] as! NSDictionary)
         
    }
    
    func sidemenuselectRole(role: String, roleArray: NSMutableArray) {
        selectRole = role
        if(role == "Guardian" || role == "Player")
        {
            self.postview_height.constant = 40
        }
        else if(roleArray.count > 1)
        {
            self.postview_height.constant = 80
        }
        else if(roleArray.count > 0)
        {
            let dic: NSDictionary = roleArray[0] as! NSDictionary
            let team: String = (dic.value(forKey: "team_id") as? String ?? nil)!
            if(team == "")
            {
                self.postview_height.constant = 40

            }
        
        }
        getFeedMethod()
    }
    
   
    
    
    //@IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var post_tbl: UITableView!
    @IBOutlet weak var emptyfeed_img: UIImageView!
    @IBOutlet weak var postview_height: NSLayoutConstraint!
    @IBOutlet weak var postvielname_lbl: UILabel!
    @IBOutlet weak var displayselectitem: UIView!
     var cancel_btn: UIButton!
    var addOrder: UIView!
    var selectindexArray: NSMutableArray!


    //var isInfo: Bool = false
    var selectIndex: Int!
    var getuuid : String!

    var commonArray: NSMutableArray!
    
    var avPlayer: AVPlayer?
       var avPlayerLayer: AVPlayerLayer?
       var paused: Bool = false
    var postImg: UIImageView!
    var videoview: UIView!
    var selectRole: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = self.view.frame.size.width - 70
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            let  menuVC: SidemenuVC = revealViewController()?.rearViewController as! SidemenuVC;
            menuVC.delegate = self;
                    }
        

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

        if #available(iOS 10.0, *) {
            post_tbl.refreshControl = refreshControl
        } else {
            post_tbl.backgroundView = refreshControl
        }
        self.post_tbl.delegate = self
        self.post_tbl.dataSource = self
        commonArray = NSMutableArray()
        selectindexArray = NSMutableArray()
        post_tbl.tableFooterView = UIView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(UserDefaults.standard.value(forKey: "Role") != nil)
        {
            selectRole = (UserDefaults.standard.value(forKey: "Role") != nil) ? UserDefaults.standard.value(forKey: "Role") as! String : ""
        }
        getFeedMethod()
        
    }
    @objc func selectitemRemove(_ sender: UIButton)
    {
        self.postvielname_lbl.text = "All Posts"
        self.postvielname_lbl.backgroundColor = .clear
        self.postvielname_lbl.textColor = UIColor.white
        self.postvielname_lbl.layer.cornerRadius = 0
        self.postvielname_lbl.layer.borderWidth = 0
        cancel_btn.removeFromSuperview()
    }
    func getFeedMethod()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        getuuid = UserDefaults.standard.string(forKey: "UUID")
               
        let db = Firestore.firestore()
        db.collection("feed").whereField("feedToUserId", arrayContains: getuuid!).order(by: "feedPostedDatetime", descending: true).getDocuments() { (querySnapshot, err) in
            Constant.showInActivityIndicatory()

                  if let err = err {
                  } else {
                    self.commonArray = NSMutableArray()
                      for document in querySnapshot!.documents {
                      let data: NSDictionary = document.data() as NSDictionary
                        let getDataDic: NSMutableDictionary = data.mutableCopy() as! NSMutableDictionary
                        getDataDic.setValue(false, forKey: "isInfo")
                        if(self.selectRole != "" && self.selectRole != nil)
                        {
                            if(self.selectRole == getDataDic.value(forKey: "feedPostedUser_role") as? String)
                        {
                            self.commonArray.add(getDataDic.copy())
                        }
                        }
                        else
                        {
                            self.commonArray.add(getDataDic.copy())
                        }

                      }
                    
                    self.post_tbl.reloadData()
                    self.emptyfeed_img.isHidden = (self.commonArray.count == 0) ? false : true
                   // Constant.showInActivityIndicatory()

                  }
              }

        }
   
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        // Do your job, when done:
        refreshControl.endRefreshing()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commonArray.count
        }

        // create a cell for each table view row
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:PostCell = self.post_tbl.dequeueReusableCell(withIdentifier: "post") as! PostCell
            let Dic: NSDictionary = self.commonArray?[indexPath.row] as! NSDictionary
            
            cell.username_lbl?.text = "\(Dic.value(forKey: "feedPostedUser_firstName")!)" + " " + "\(Dic.value(forKey: "feedPostedUser_middleInitial")!)" + " " + "\(Dic.value(forKey: "feedPostedUser_lastName")!)" + " - " + "\(Dic.value(forKey: "feedPostedUser_role")!)" .capitalized
    
    var datees = Date()
    if(Dic.value(forKey: "feedPostedDatetime") as? Timestamp != nil)
    {
        let timestamp: Timestamp = Dic.value(forKey: "feedPostedDatetime") as! Timestamp
        datees = timestamp.dateValue()
    }
     let dateFormatterGet = DateFormatter()
             dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

             let dateFormatterPrint = DateFormatter()
             dateFormatterPrint.dateFormat = "MMM dd,yyyy hh:mm:ss a"

    cell.date_lbl.text = "Posted on \(dateFormatterPrint.string(from: datees as Date))"
    
    if(Dic.value(forKey: "tag_name") != nil && Dic.value(forKey: "tag_name")as? String != "")
    {
        let size = (Dic.value(forKey: "tag_name") as! NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
        cell.tag_btn.frame = CGRect(x: cell.date_lbl.frame.origin.x, y: cell.date_lbl.frame.origin.y+cell.date_lbl.frame.size.height+4, width: size.width, height: 25)
        cell.tag_btn.isHidden = false
        cell.tag_btn.setTitle(Dic.value(forKey: "tag_name") as? String, for: .normal)
        //cell.tag_btn.sizeToFit()
        cell.tag_btn.titleLabel?.textAlignment = .left
    }
    else
    {
        cell.tag_btn.isHidden = true
    }
    if(Dic.value(forKey: "reaction") != nil && Dic.value(forKey: "reaction")as! String != "")
    {
        let size = (Dic.value(forKey: "reaction") as! NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)])
        cell.reaction_btn.isHidden = false
        let getreaction: String = Dic.value(forKey: "reaction") as! String
        if(getreaction == "neutral")
        {
             cell.reaction_btn.frame = CGRect(x: cell.tag_btn.frame.origin.x + cell.tag_btn.frame.size.width + 10, y: cell.date_lbl.frame.origin.y+cell.date_lbl.frame.size.height + 4, width: size.width * 1.5, height: 25)
            cell.reaction_btn.setImage(UIImage(named: "happy"), for: .normal)
            cell.reaction_btn.setTitle("neutral", for: .normal)

        }
        else if(getreaction == "unhappy")
        {
             cell.reaction_btn.frame = CGRect(x: cell.tag_btn.frame.origin.x + cell.tag_btn.frame.size.width + 10, y: cell.date_lbl.frame.origin.y+cell.date_lbl.frame.size.height + 4, width: size.width * 1.7, height: 25)
            cell.reaction_btn.setImage(UIImage(named: "Thumbs_down"), for: .normal)
            cell.reaction_btn.setTitle("Thumbs-down", for: .normal)

        }
        else if(getreaction == "happy")
        {
             cell.reaction_btn.frame = CGRect(x: cell.tag_btn.frame.origin.x + cell.tag_btn.frame.size.width + 10, y: cell.date_lbl.frame.origin.y+cell.date_lbl.frame.size.height+4, width: size.width * 1.9, height: 25)
            cell.reaction_btn.setImage(UIImage(named: "Thumbs_up"), for: .normal)
            cell.reaction_btn.setTitle("Thumbs-up", for: .normal)

        }
        cell.reaction_btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 5.0)
        cell.reaction_btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)
        cell.reaction_btn.tintColor = UIColor.black

        cell.reaction_btn.contentHorizontalAlignment = .left


    }
    else
    {
        cell.reaction_btn.isHidden = true
    }
            let profileImage = Dic.value(forKey: "feedPostedUser_avatar") as? String ?? ""
            let urls = NSURL(string: "\(profileImage)")
            if(urls?.absoluteString != "")
             {
                
                cell.profileImg.kf.setImage(with: urls! as URL)

            
                 cell.profileImg.layer.cornerRadius = cell.profileImg.frame.size.width/2
                 cell.profileImg.layer.backgroundColor = UIColor.lightGray.cgColor
             }
            let likeDic: NSDictionary = Dic.value(forKey: "likes") as! NSDictionary
            let userlist: NSArray = likeDic.value(forKey: "user_list") as! NSArray
            let contained = userlist.contains("\(getuuid!)")
            cell.like_btn.tintColor = (contained) ? UIColor.red : UIColor.lightGray
            cell.like_btn.setTitle("\(likeDic.value(forKey: "count")!)", for: .normal)
            let CommentDic: NSDictionary = Dic.value(forKey: "comments") as! NSDictionary
            cell.comment_btn.setTitle("\(CommentDic.value(forKey: "count")!)", for: .normal)
            
    cell.comment_lbl_height.constant = (Dic.value(forKey: "feedText") as? String != "" && Dic.value(forKey: "feedText") != nil) ? 50 : 0
    cell.comment_lbl.text = Dic.value(forKey: "feedText") as? String
           cell.infoviewHeight.constant = (Dic.value(forKey: "isInfo") as! Bool  == true) ? 140 : 0
           cell.infoview.isHidden = (Dic.value(forKey: "isInfo") as! Bool == true ) ? false : true
            cell.info_btn.tag = indexPath.row
            cell.like_btn.tag = indexPath.row
            cell.comment_btn.tag = indexPath.row
            cell.info_btn.addTarget(self, action: #selector(InformationDetail), for: .touchUpInside)
            cell.like_btn.addTarget(self, action: #selector(likeDetail), for: .touchUpInside)
            cell.comment_btn.addTarget(self, action: #selector(commentDetail), for: .touchUpInside)

           let postInfo: NSMutableArray = (Dic["feededLevelObject"]! as! NSArray).mutableCopy() as! NSMutableArray
           let postinfoDic: NSDictionary = postInfo[0] as! NSDictionary
    
    if(postinfoDic.value(forKey:"organization_name") != nil && postinfoDic.value(forKey: "organization_name")as? String != "")
    {
        let size = ("Org:" as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)])
        let width: CGFloat = size.width
        cell.org_title_lbl.frame = CGRect(x: cell.infoview.frame.origin.x + 10, y: 40, width: width, height: 30)
        
        
        let org_name = (postinfoDic.value(forKey:"organization_name") as! NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)])
               let width_org: CGFloat = org_name.width
        
        cell.org_lbl.frame = CGRect(x: cell.org_title_lbl.frame.origin.x + cell.org_title_lbl.frame.size.width , y: cell.org_title_lbl.frame.origin.y, width: width_org, height: 30)
        cell.org_lbl.text = postinfoDic.value(forKey:"organization_name") as! NSString as String
        cell.org_lbl.isHidden = false
        cell.org_title_lbl.isHidden = false
       // cell.org_lbl.sizeToFit()
       // cell.org_title_lbl.sizeToFit()

    }
    else
    {
        cell.org_lbl.isHidden = true
        cell.org_title_lbl.isHidden = true
    }
    if(postinfoDic.value(forKey:"sport_name") != nil && postinfoDic.value(forKey:"sport_name")as? String != "")
      {
          let size = ("Sport:" as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)])
          let width: CGFloat = size.width
        cell.sport_title_lbl.frame = CGRect(x: cell.org_lbl.frame.origin.x + cell.org_lbl.frame.size.width, y: cell.org_title_lbl.frame.origin.y, width: width, height: 30)
          
          let org_name = (postinfoDic.value(forKey:"sport_name") as! NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
                 let width_org: CGFloat = org_name.width
          
          cell.sport_lbl.frame = CGRect(x: cell.sport_title_lbl.frame.origin.x + cell.sport_title_lbl.frame.size.width , y: cell.org_title_lbl.frame.origin.y, width: width_org, height: 30)
        cell.sport_lbl.text = postinfoDic.value(forKey:"sport_name") as? String

          cell.sport_lbl.isHidden = false
          cell.sport_title_lbl.isHidden = false
        //cell.sport_lbl.sizeToFit()
        //cell.sport_title_lbl.sizeToFit()

      }
      else
      {
          cell.sport_lbl.isHidden = true
          cell.sport_title_lbl.isHidden = true
      }
    
    if(postinfoDic.value(forKey:"season_name") != nil && postinfoDic.value(forKey: "season_name")as? String != "")
         {
             let size = ("Season:" as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
             let width: CGFloat = size.width
           cell.season_title_lbl.frame = CGRect(x: cell.sport_lbl.frame.origin.x + cell.sport_lbl.frame.size.width, y: cell.sport_lbl.frame.origin.y, width: width, height: 30)
             
             let org_name = (postinfoDic.value(forKey:"season_name") as! NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
                    let width_org: CGFloat = org_name.width
             
             cell.season_lbl.frame = CGRect(x: cell.season_title_lbl.frame.origin.x + cell.season_title_lbl.frame.size.width , y: cell.sport_lbl.frame.origin.y, width: width_org, height: 30)
            
            cell.season_lbl.text = postinfoDic.value(forKey:"season_name") as? String

             cell.season_title_lbl.isHidden = false
             cell.season_lbl.isHidden = false
           // cell.season_title_lbl.sizeToFit()
            //cell.season_lbl.sizeToFit()

         }
         else
         {
             cell.season_lbl.isHidden = true
             cell.season_title_lbl.isHidden = true
         }
    if(postinfoDic.value(forKey:"level_name") != nil && postinfoDic.value(forKey: "level_name")as? String != "")
         {
             let size = ("Leavel:" as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
             let width: CGFloat = size.width
            cell.level_title_lbl.frame = CGRect(x: cell.org_title_lbl.frame.origin.x, y: cell.org_title_lbl.frame.origin.y + cell.org_title_lbl.frame.size.height, width: width, height: 30)
             
             let org_name = (postinfoDic.value(forKey: "level_name") as! NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
                    let width_org: CGFloat = org_name.width
             
             cell.level_lbl.frame = CGRect(x: cell.level_title_lbl.frame.origin.x + cell.level_title_lbl.frame.size.width , y: cell.level_title_lbl.frame.origin.y, width: width_org, height: 30)
            cell.level_lbl.text = postinfoDic.value(forKey: "level_name") as? String

             cell.level_title_lbl.isHidden = false
             cell.level_lbl.isHidden = false

         }
         else
         {
             cell.level_lbl.isHidden = true
             cell.level_title_lbl.isHidden = true
         }
    if(postinfoDic.value(forKey: "team_name") != nil && postinfoDic.value(forKey: "team_name")as? String != "")
          {
              let size = ("Team:" as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
              let width: CGFloat = size.width
            cell.team_title_lbl.frame = CGRect(x: cell.level_lbl.frame.origin.x + cell.level_lbl.frame.size.width, y: cell.level_title_lbl.frame.origin.y, width: width, height: 30)
              
              let org_name = (postinfoDic.value(forKey: "team_name") as! NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
                     let width_org: CGFloat = org_name.width
              
              cell.team_lbl.frame = CGRect(x: cell.team_title_lbl.frame.origin.x + cell.team_title_lbl.frame.size.width , y: cell.team_title_lbl.frame.origin.y, width: width_org, height: 30)
            cell.team_lbl.text = postinfoDic.value(forKey: "team_name") as? String
              cell.team_title_lbl.isHidden = false
              cell.team_lbl.isHidden = false

          }
          else
          {
              cell.team_lbl.isHidden = true
              cell.team_title_lbl.isHidden = true
          }
    
    if(postinfoDic.value(forKey:"membergroup_name") != nil && postinfoDic.value(forKey: "membergroup_name")as? String != "")
    {
        let size = ("Group:" as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
        let width: CGFloat = size.width
      cell.group_title_lbl.frame = CGRect(x: cell.team_lbl.frame.origin.x + cell.team_lbl.frame.size.width, y: cell.team_lbl.frame.origin.y, width: width, height: 30)
        
        let org_name = (postinfoDic.value(forKey:"membergroup_name") as! NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
               let width_org: CGFloat = org_name.width
        
        cell.group_lbl.frame = CGRect(x: cell.group_title_lbl.frame.origin.x + cell.group_title_lbl.frame.size.width , y: cell.group_title_lbl.frame.origin.y , width: width_org, height: 30)
      cell.group_lbl.text = postinfoDic.value(forKey: "membergroup_name") as? String
        cell.group_title_lbl.isHidden = false
        cell.group_lbl.isHidden = false

    }
    else
    {
        cell.group_lbl.isHidden = true
        cell.group_title_lbl.isHidden = true
    }
    if(postinfoDic.value(forKey:"user_name") != nil && postinfoDic.value(forKey: "user_name")as? String != "")
    {
        let size = ("Player:" as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
        let width: CGFloat = size.width
        cell.player_title_lbl.frame = CGRect(x: cell.level_title_lbl.frame.origin.x, y: cell.group_lbl.frame.origin.y + cell.group_lbl.frame.size.height, width: width, height: 30)
        
        let org_name = (postinfoDic.value(forKey: "user_name") as! NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
               let width_org: CGFloat = org_name.width
        
        cell.player_lbl.frame = CGRect(x: cell.player_title_lbl.frame.origin.x + cell.player_title_lbl.frame.size.width , y: cell.player_title_lbl.frame.origin.y, width: width_org, height: 30)
      cell.player_lbl.text = postinfoDic.value(forKey: "user_name") as? String
        cell.player_title_lbl.isHidden = false
        cell.player_lbl.isHidden = false

    }
    else
    {
        cell.player_lbl.isHidden = true
        cell.player_title_lbl.isHidden = true
    }
    
//    let feedlevobj: NSMutableArray = NSMutableArray()
//     if(postinfoDic.value(forKey: "organization_name") as? String != "" && postinfoDic.value(forKey: "organization_name") != nil)
//     {
//        feedlevobj.add("org: \(postinfoDic.value(forKey: "organization_name") as! String )")
//    }
//   if(postinfoDic.value(forKey: "sport_name") as? String != "" || postinfoDic.value(forKey: "sport_name") != nil)
//     {
//        feedlevobj.add("Sport: \(postinfoDic.value(forKey: "sport_name") as! String )")
//
//    }
//    if(postinfoDic.value(forKey: "season_name") as? String != "" || postinfoDic.value(forKey: "season_name") != nil)
//     {
//        feedlevobj.add("Season: \(postinfoDic.value(forKey: "season_name") as! String )")
//
//    }
// if(postinfoDic.value(forKey: "level_name") as? String != "" || postinfoDic.value(forKey: "level_name") != nil)
//    {
//       feedlevobj.add("Leavel: \(postinfoDic.value(forKey: "level_name") as! String )")
//
//   }
//   if(postinfoDic.value(forKey: "team_name") as? String != "" || postinfoDic.value(forKey: "team_name") != nil)
//     {
//        feedlevobj.add("Team: \(postinfoDic.value(forKey: "team_name") as! String )")
//
//    }
//    if(postinfoDic.value(forKey: "membergroup_name") as? String != "" || postinfoDic.value(forKey: "membergroup_name") != nil)
//     {
//        feedlevobj.add("Group: \(postinfoDic.value(forKey: "membergroup_name") as! String )")
//
//    }
//     if(postinfoDic.value(forKey: "user_name") as? String != "" || postinfoDic.value(forKey: "user_name") != nil)
//     {
//        feedlevobj.add("Player: \(postinfoDic.value(forKey: "user_name") as! String )")
//
//    }
       //cell.infoviewHeight.constant = (feedlevobj.count < 8) ? 140 : 100

    

//            cell.org_lbl.text = postinfoDic.value(forKey: "organization_name") as? String
//            cell.season_lbl.text = postinfoDic.value(forKey: "season_name") as? String
//            cell.sport_lbl.text = postinfoDic.value(forKey: "sport_name") as? String
//            cell.team_lbl.text = postinfoDic.value(forKey: "team_name") as? String
//          // cell.video_view.isHidden = true

            var postimageArray = NSMutableArray()
            let keyExists = Dic.value(forKey: "feedImageURL") != nil
            let videoExists = Dic.value(forKey: "feedVideoURL") != nil
            if(keyExists || videoExists)
            {
                cell.postimageviewHeight.constant = 350

                let imageheight: CGFloat = cell.postimageScroll.frame.size.height
                let imagewidth : CGFloat = cell.postimageScroll.frame.size.width
                if(videoExists)
                {
                    
                    if(postImg != nil)
                    {
                        postImg.removeFromSuperview()
                    }
                    let postvideo : String = Dic.value(forKey: "feedVideoURL") as! String
                    let videoURL = NSURL(string: "\(postvideo)")
                    avPlayer = AVPlayer(url: videoURL! as URL)
                    
                     avPlayerLayer = AVPlayerLayer(player: avPlayer)
                    avPlayerLayer?.frame = cell.bounds
                    videoview = UIView()
                                       
                    videoview.frame =  CGRect(x: 0, y: 0, width: imagewidth, height: imageheight)
                    videoview.layer.addSublayer(avPlayerLayer!)
                    videoview.layer.display()
                    let videoplay_btn: UIButton = UIButton()
                    videoplay_btn.frame = CGRect(x: videoview.frame.size.width/2, y: videoview.frame.size.height/2, width: 30, height: 30)
                    videoplay_btn.setImage(UIImage(named: "video"), for: .normal)
                    videoplay_btn.tag = indexPath.row
                    videoplay_btn.addTarget(self, action: #selector(videoplay), for: .touchUpInside)
                    videoview.addSubview(videoplay_btn)
                    avPlayer?.pause()
                cell.postimageScroll.addSubview(videoview)
                
                    
                }
                else
                {
                    
                postimageArray = (Dic["feedImageURL"]! as! NSArray).mutableCopy() as! NSMutableArray
                    //(Dic.value(forKey: "feedImageURL") as? NSMutableArray ?? nil)!
                    

                for i in 0..<postimageArray.count
                {
                    self.postImg = UIImageView()
                    
                    postImg.frame = (i==0) ? CGRect(x: 0, y: 0, width: imagewidth, height: imageheight) : CGRect(x: CGFloat(i) * imagewidth, y: 0, width : imagewidth, height: imageheight)
                   // postImg.backgroundColor = UIColor.red
                    let posturl = URL(string: "\(postimageArray[i])")
                    postImg.kf.setImage(with: posturl! as URL)
                    cell.postimageScroll.addSubview(postImg)
                    cell.pageControl.numberOfPages = postimageArray.count
                    cell.pageControl.tag = i
                    

                }
                }
                cell.postimageScroll.contentSize = CGSize(width: CGFloat(postimageArray.count) * imagewidth, height: imageheight)
                cell.pageControl.isHidden = (postimageArray.count > 1) ? false : true

            }
            else{

                 cell.postimageviewHeight.constant = 0
                 cell.pageControl.isHidden = true
                
            }
            cell.postimageScroll.isPagingEnabled = true
            cell.postimageScroll.delegate = self
            cell.pageControl.currentPage = 0;
            cell.pageControl.numberOfPages = postimageArray.count;
            cell.selectionStyle = .none
            return cell
        }

        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
    let Dic: NSDictionary = self.commonArray?[indexPath.row] as! NSDictionary
        
        let keyExists = Dic.value(forKey: "feedImageURL") != nil
        let videoExists = Dic.value(forKey: "feedVideoURL") != nil
      print("fdfghsghfsfs:\(Dic.value(forKey: "feedText") as? String)")
        if(keyExists == true  || videoExists == true)
        {
            
            if(Dic.value(forKey: "isInfo") as! Bool == true)
            {
                if(Dic.value(forKey: "feedText") as? String != "" && Dic.value(forKey: "feedText") != nil)
                {
                
                   return 705.0
                }
                else
                {
                    return 655.0
                }
                
            }
            else
            {
               
                if(Dic.value(forKey: "feedText") as? String != "" && Dic.value(forKey: "feedText") != nil)
                {
                                   
                    return 565.0
                }
                else
                {
                    return 515.0
                }
                
            }

        }
        else
        {
            if(Dic.value(forKey: "isInfo") as! Bool == true)
            {
                return 360.0
            }
            else
            {
            return 220.0
            }

        }
    }
   
    @objc func videoplay(_ sender: UIButton)
    {
        let button = sender
        let cell = button.superview?.superview as? PostCell

        let dic: NSDictionary = commonArray?[sender.tag] as! NSDictionary
        let postvideo : String = dic.value(forKey: "feedVideoURL") as! String
        let videoURL = NSURL(string: "\(postvideo)")
       // avPlayer = AVPlayer(url: videoURL! as URL)

        //let playerLayer = AVPlayerLayer(player: avPlayer)
        //playerLayer.frame = videoview.bounds
//        cell?.postimageScroll.insertSubview(postImg, at: button.tag)
        if(avPlayer?.rate == 0)
        {
        avPlayer!.play()
        
        }
        else
        {
            avPlayer?.pause()
        }
        //let indexPosition = IndexPath(row: button.tag, section: 0)
        //self.post_tbl.reloadRows(at: [indexPosition], with: .none)

       
    }
    @objc func InformationDetail(_ sender: UIButton)
    {
        let indexno = sender.tag
        let replaceDic: NSDictionary = self.commonArray?[indexno] as! NSDictionary
        let newDict: NSMutableDictionary  = NSMutableDictionary()
        let oldDict: NSDictionary = commonArray.object(at: indexno) as! NSDictionary
        newDict.addEntries(from: oldDict as! [AnyHashable : Any])
       
        if(replaceDic.value(forKey: "isInfo") as! Bool == false)
        {
            newDict.setValue(true, forKey: "isInfo")


        }
        else{
           // replaceDic.setValue(false, forKey: "isInfo")
            newDict.setValue(false, forKey: "isInfo")


        }
        commonArray.replaceObject(at: indexno, with: newDict)
        //[dataArray replaceObjectAtIndex:0 withObject:newDict];

        selectIndex = indexno
        let indexPosition = IndexPath(row: selectIndex, section: 0)
        self.post_tbl.reloadRows(at: [indexPosition], with: .none)


       

    }
    func refresh(sender: UIRefreshControl)
    {
        // Updating your data here...

        self.post_tbl.reloadData()
        sender.endRefreshing()
    }
    
    @objc func likeDetail(sender: UIButton) {
        let button = sender
        let indexno = sender.tag

        let cell = button.superview?.superview as? PostCell
        let Dic: NSDictionary = self.commonArray?[indexno] as! NSDictionary
        let likeDic: NSDictionary = Dic.value(forKey: "likes") as! NSDictionary
        var userlist: NSArray = likeDic.value(forKey: "user_list") as! NSArray
        let contained = userlist.contains("\(getuuid!)")
        let feedId = Dic.value(forKey: "feed_id")
        if(contained == false)
        {
                    cell?.like_btn.tintColor = UIColor.red
                    let likecount: Int = Int("\(likeDic.value(forKey: "count")!)")! + 1
                    cell!.like_btn.setTitle("\(likecount)", for: .normal)
                    let addUserlist: NSMutableArray = NSMutableArray()
                    addUserlist.add(getuuid)
                    userlist = addUserlist.copy() as! NSArray
                    let maplike: NSMutableDictionary = NSMutableDictionary()
                    maplike.setValue(likecount, forKey: "count")
                    maplike.setValue(userlist, forKey: "user_list")
            
            let newDict: NSMutableDictionary  = NSMutableDictionary()
            let oldDict: NSDictionary = self.commonArray.object(at: indexno) as! NSDictionary
            newDict.addEntries(from: oldDict as! [AnyHashable : Any])
            newDict.setValue(maplike.copy(), forKey: "likes")
            self.commonArray.replaceObject(at: indexno, with: newDict)
            likeUpdatemethod(updateDetail: maplike.copy() as! NSDictionary, userFeedid: feedId as! String, selectIdexdetail: Dic, selectIndex: indexno)
                
        }
                else
                {
                    cell!.like_btn.tintColor = UIColor.lightGray
                    let likecount: Int = Int("\(likeDic.value(forKey: "count")!)")! - 1
                    cell!.like_btn.setTitle("\(likecount)", for: .normal)
                    let addUserlist: NSMutableArray = NSMutableArray()
                    addUserlist.remove(getuuid)
                    userlist = addUserlist.copy() as! NSArray
                    let maplike: NSMutableDictionary = NSMutableDictionary()
                    maplike.setValue(likecount, forKey: "count")
                    maplike.setValue(userlist, forKey: "user_list")
                    
                    let newDict: NSMutableDictionary  = NSMutableDictionary()
                    let oldDict: NSDictionary = self.commonArray.object(at: indexno) as! NSDictionary
                    newDict.addEntries(from: oldDict as! [AnyHashable : Any])
                    newDict.setValue(maplike.copy(), forKey: "likes")
                    self.commonArray.replaceObject(at: indexno, with: newDict)
                    
                    
                    DislikeMethod(updateDetail: maplike.copy() as! NSDictionary, userFeedid: feedId as! String, selectlikindex: indexno)
                    
                   
                }
        
    }
    func likeUpdatemethod(updateDetail: NSDictionary, userFeedid: String, selectIdexdetail: NSDictionary, selectIndex: Int)
    {
        Constant.internetconnection(vc: self)
       //Constant.showActivityIndicatory(uiView: self.view)
        let db = Firestore.firestore()
        db.collection("feed").document("\(userFeedid)").updateData(["likes": updateDetail])
                   { err in
                    
                       if let err = err {
                           Constant.showInActivityIndicatory()
                       } else {
                db.collection("feed").document("\(userFeedid)").collection("feedLikes").document("\(self.getuuid!)").setData(["avatar": "\(selectIdexdetail.value(forKey: "feedPostedUser_avatar") ?? "")","created_dateTime" : Date(),"created_userid": "\(self.getuuid!)","first_name": "\(selectIdexdetail.value(forKey: "feedPostedUser_firstName")!)","last_name": "\(selectIdexdetail.value(forKey: "feedPostedUser_lastName")!)","middle_initial": "\(selectIdexdetail.value(forKey: "feedPostedUser_middleInitial")!)","suffix": "\(selectIdexdetail.value(forKey: "feedPostedUser_suffix")!)","update_userid": "","updated_dateTime": "","user_id":"\(self.getuuid!)"])
                        { err in
                            if let err = err {
                               // Constant.showInActivityIndicatory()

                            } else {
                               // Constant.showInActivityIndicatory()
//                                let replaceDic: NSDictionary = self.commonArray?[selectIndex] as! NSDictionary
//                                let newDict: NSMutableDictionary  = NSMutableDictionary()
//                                let oldDict: NSDictionary = self.commonArray.object(at: selectIndex) as! NSDictionary
//                                newDict.addEntries(from: oldDict as! [AnyHashable : Any])
//                                newDict.setValue(true, forKey: "isInfo")
//
//                                self.commonArray.replaceObject(at: selectIndex, with: newDict)

                             //   let indexPosition = IndexPath(row: selectIndex, section: 0)
                              //  self.post_tbl.reloadRows(at: [indexPosition], with: .none)

                            }
                        }
                    }
        }
    }
    
    func DislikeMethod(updateDetail: NSDictionary, userFeedid: String, selectlikindex: Int)
    {
        Constant.internetconnection(vc: self)
        //Constant.showActivityIndicatory(uiView: self.view)
        let db = Firestore.firestore()
        db.collection("feed").document("\(userFeedid)").updateData(["likes": updateDetail])
                   { err in
                       if let err = err {
                         //  Constant.showInActivityIndicatory()

                       } else {
db.collection("feed").document("\(userFeedid)").collection("feedLikes").document("\(self.getuuid!)").delete()
                        { err in
                            if let err = err {
                               // Constant.showInActivityIndicatory()

                            } else {
                               // Constant.showInActivityIndicatory()
                                let indexPosition = IndexPath(row: selectlikindex, section: 0)
                                self.post_tbl.reloadRows(at: [indexPosition], with: .none)
                            }
                        }
                    }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView )
    {
        let button = scrollView
        let cell = button.superview?.superview as? PostCell
        
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let page: Int = Int(x/w)
        cell?.pageControl.currentPage = page
    }
    
  
    @objc func commentDetail(_ sender: UIButton)
    {
        let button = sender
        let indexno = button.tag
        //let cell = button.superview?.superview as? PostCell
        let Dic: NSDictionary = self.commonArray?[indexno] as! NSDictionary
        let objCommentvc: CommentVC = (self.storyboard?.instantiateViewController(identifier: "comment"))!
        objCommentvc.selectComment = Dic
        self.navigationController?.pushViewController(objCommentvc, animated: false)
        
    }
    @IBAction func postVideoandImage(_ sender: UIButton)
    {
       let objpostvc: PostImageVC = (self.storyboard?.instantiateViewController(identifier: "postimage"))!
        self.navigationController?.pushViewController(objpostvc, animated: false)
        
    }
    @IBAction func feedSelector(_ sender: UIButton)
    {
        let objPosttag: FeedSelectorVC = (self.storyboard?.instantiateViewController(identifier: "FeedSelectorVc"))!
        objPosttag.delegate = self
        self.navigationController?.pushViewController(objPosttag, animated: false)
    }
    
    func feedfilter(feeddetail: NSDictionary)
    {
        Constant.internetconnection(vc: self)
        //Constant.showActivityIndicatory(uiView: self.view)
        let testStatusUrl: String = Constant.sharedinstance.getFeedFilter
        let header: HTTPHeaders = [
            "idtoken": UserDefaults.standard.string(forKey: "idtoken")!]
         var param:[String:AnyObject] = [:]
        param["user_id"] = UserDefaults.standard.string(forKey: "UUID") as AnyObject?  //feeddetail.value(forKey: "") as AnyObject?
        param["feededLevel"] = feeddetail.value(forKey: "feedLevel") as AnyObject?
        param["pageNo"] = 1 as AnyObject?
        param["itemPerPage"] = 10 as AnyObject?
        
        AF.request(testStatusUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if(!(response.error != nil)){
                switch (response.result)
                {
                case .success(let json):
                   // if let data = response.data{

                        let jsonData = json
                        let info = jsonData as? NSDictionary
                        let statusCode = info?["status"] as? Bool
                        let message = info?["message"] as? String

                        if(statusCode == true)
                        {
                            let resut = info?["data"] as! NSDictionary

                            let getData = resut["data"] as! NSArray
                            self.commonArray = NSMutableArray()
                            for i in 0..<getData.count
                            {
                                let olddic: NSDictionary = getData[i] as! NSDictionary
                                let getDataDic: NSMutableDictionary = olddic.mutableCopy() as! NSMutableDictionary
                                getDataDic.setValue(false, forKey: "isInfo")
                                self.commonArray.add(getDataDic.copy())

                            }
                            Constant.showInActivityIndicatory()
                            self.post_tbl.reloadData()

                            
                        }
                        else
                        {
                            if(message == "unauthorized user")
                            {
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.timerAction()
                               // self.getplayerlist()
                            }
                            else
                            {
                                self.commonArray = NSMutableArray()
                                self.post_tbl.reloadData()
                                self.emptyfeed_img.isHidden = (self.commonArray.count == 0) ? false : true

                            }
                           
                        }
                        Constant.showInActivityIndicatory()

                  //  }
                    break

                case .failure(_):
                    Constant.showInActivityIndicatory()

                    break
                }
            }
            else
            {
                //Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: "\(Constant.sharedinstance.errormsgDetail)")
                Constant.showInActivityIndicatory()

            }
        }
    }
    @objc func CancelFeedFilter(_ sender: UIButton)
    {
         getFeedMethod()
    }
    
    @IBAction func menuBtn(_ sender: UIButton)
    {
        self.revealViewController().revealToggle(self)

    }
    
}
