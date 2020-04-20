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
import Firebase
import AVKit
import Kingfisher
import SwiftyGif
import SwiftGifOrigin
import UserNotifications


class Dashboardvc: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, sidemenuDelegate, FeedSelectorDelegate, backgroundpostDelegate {
    
    func feedselectDashboard(selectitem: NSDictionary, selectName: String) {
        
    }
    @IBOutlet weak var progressView: UIImageView!

   @objc func backgroundloadingstop() {
    
    
        self.progressView.isHidden = true
        msg_lbl.isHidden = false
        loadviewcancelbutton.isHidden = false
    

    }
    
    @objc func backgroundpostloading() {
       
        self.loadingview.isHidden = false
        msg_lbl.isHidden = true
        loadviewcancelbutton.isHidden = true
        progressView.isHidden = false
        self.progressView.image = UIImage.gif(name: "animation")
       
    }
    
    // MARK: - Private Methods

       private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
           // Request Authorization
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
               if let error = error {
                   print("Request Authorization Failed (\(error), \(error.localizedDescription))")
               }

               completionHandler(success)
           }
       }

    func feddSelectDetail(userDetail: NSMutableArray, selectitemname: String) {
        
        let font = UIFont(name: "Arial", size: 16)
         let fontAttributes = [NSAttributedStringKey.font: font]
         let size = selectitemname.size(withAttributes: fontAttributes as [NSAttributedStringKey : Any])
        // print("select:\(selectitemname) \(size.width)")
        self.postvielname_lbl.frame = CGRect(x: 110, y: self.displayselectitem.frame.origin.y+5, width: size.width + 30, height: 30)
//         cell.select_text_width.constant = size.width + 5
//         cell.common_view_width.constant = cell.select_text_width.constant + 35
        //cell.detail_btn.setTitle(selectname, for: .normal)
        // cell.detail_btn.setImage(UIImage(named: ""), for: .normal)

        
        
        
        
        self.postvielname_lbl.text = " \(selectitemname)"
         self.postvielname_lbl.backgroundColor = UIColor.white
         self.postvielname_lbl.textColor = UIColor.gray
         self.postvielname_lbl.layer.cornerRadius = 10
         self.postvielname_lbl.layer.borderWidth = 0.5
         self.postvielname_lbl.layer.borderColor = UIColor.lightGray.cgColor
         self.postvielname_lbl.layer.masksToBounds = true
        self.postvielname_lbl.textAlignment = .left
        if(cancel_btn != nil)
        {
            cancel_btn.removeFromSuperview()
        }
         cancel_btn = UIButton()
          //let size = (selectitemname as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
         cancel_btn.frame = CGRect(x:self.postvielname_lbl.frame.origin.x + self.postvielname_lbl.frame.size.width - 25, y: 8, width: 25, height: 25)
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
        
        if(self.postvielname_lbl.text == "All Posts")
        {
           getFeedMethod()
        }
    }
    
   
    
    
    //@IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var post_tbl: UITableView!
    @IBOutlet weak var emptyfeed_img: UIImageView!
    @IBOutlet weak var postview_height: NSLayoutConstraint!
    @IBOutlet weak var postvielname_lbl: UILabel!
    @IBOutlet weak var displayselectitem: UIView!
    @IBOutlet weak var loadingview: UIView!
    @IBOutlet weak var  msg_lbl: UILabel!
    @IBOutlet weak var  loadviewcancelbutton: UIButton!

    var particularCellHeight: CGFloat!
     var Postcell:PostCell!
     var cancel_btn: UIButton!
    //var addOrder: UIView!
    var selectindexArray: NSMutableArray!


    //var isInfo: Bool = false
    var selectIndex: Int!
    var getuuid : String!

    var commonArray: NSMutableArray!
    var paused: Bool = false
   
    var selectRole: String!
    var videoplay_btn: UIButton!
    
    var db:DBHelper = DBHelper()
    
    var persons:[FeedPostData] = []
    
    var PeopleselectArray: NSMutableArray!
    var selectPeopleStr: String!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = self.view.frame.size.width - 70
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            let  menuVC: SidemenuVC = revealViewController()?.rearViewController as! SidemenuVC;
            menuVC.delegate = self;
           
                    }
        UNUserNotificationCenter.current().delegate = self

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

        if #available(iOS 10.0, *) {
            post_tbl.refreshControl = refreshControl
        } else {
            post_tbl.backgroundView = refreshControl
        }
        self.post_tbl.delegate = self
        self.post_tbl.dataSource = self
        self.loadingview.isHidden = true
        commonArray = NSMutableArray()
        selectindexArray = NSMutableArray()
        post_tbl.tableFooterView = UIView()
       // Postcell = self.post_tbl.dequeueReusableCell(withIdentifier: "post") as? PostCell

        let reachability: Reachability = Reachability.networkReachabilityForInternetConnection()!

        let netStatus = reachability.currentReachabilityStatus
        switch netStatus {
        case .notReachable:
        break
        case .reachableViaWiFi:
           wificonnectionlocaldatabaseupload()
        //print(netStatus)
        break
                           
        case .reachableViaWWAN:
        break
        }
        if(UserDefaults.standard.value(forKey: "Role") != nil)
        {
            selectRole = (UserDefaults.standard.value(forKey: "Role") != nil) ? UserDefaults.standard.value(forKey: "Role") as! String : ""
        }
        
        self.loadviewcancelbutton.layer.borderColor = UIColor.lightGray.cgColor
        self.loadviewcancelbutton.layer.borderWidth = 1
        self.loadviewcancelbutton.layer.masksToBounds = true
         NotificationCenter.default.addObserver(self,selector: #selector(Dashboardvc.backgroundpostloading),name: NSNotification.Name(rawValue: "backgroundpostloading"),object: nil)
         NotificationCenter.default.addObserver(self,selector: #selector(Dashboardvc.backgroundloadingstop),name: NSNotification.Name(rawValue: "backgroundloadingstop"),object: nil)

     

    }
    func wificonnectionlocaldatabaseupload()
    {

        let objpostvc: PostImageVC = (self.storyboard?.instantiateViewController(identifier: "postimage"))!
        objpostvc.localDatauploadfirebase()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LocalDatabase"), object: nil)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(UserDefaults.standard.bool(forKey: "selectPeople") == true)
             {
                 UserDefaults.standard.set(false, forKey: "selectPeople")
                 self.PeopleselectArray = NSMutableArray()
             let data  = UserDefaults.standard.object(forKey: "Team")
              self.PeopleselectArray = data as? NSMutableArray

                 let selectDic: NSDictionary = PeopleselectArray?[0] as! NSDictionary
                 if(selectDic.value(forKey: "user_name")as? String != nil && selectDic.value(forKey: "user_name")as? String != "")
                 {
                     self.feddSelectDetail(userDetail: PeopleselectArray, selectitemname: selectDic.value(forKey: "user_name") as! String)
                 }
                 else
                 {
                     self.feddSelectDetail(userDetail: PeopleselectArray, selectitemname: selectDic.value(forKey: "membergroup_name") as! String)
                 }
             }
              else
             {
              if(self.postvielname_lbl.text == "All Posts")
              {
                 getFeedMethod()
              }
              }
              
        
        
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
   
    @IBAction func loadviewCancel(_ sender: UIButton)
    {
        self.loadingview.isHidden = true
       // refreshControl.endRefreshing()
        getFeedMethod()
    }
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        // Do your job, when done:
        self.loadingview.isHidden = true

        refreshControl.endRefreshing()
        //getFeedMethod()

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commonArray.count
        }

        // create a cell for each table view row
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    Postcell = self.post_tbl.dequeueReusableCell(withIdentifier: "post") as? PostCell
    let Dic: NSDictionary = self.commonArray?[indexPath.row] as! NSDictionary
            
    Postcell.username_lbl?.text = "\(Dic.value(forKey: "feedPostedUser_firstName")!)" + " " + "\(Dic.value(forKey: "feedPostedUser_middleInitial")!)" + " " + "\(Dic.value(forKey: "feedPostedUser_lastName")!)" + " - " + "\(Dic.value(forKey: "feedPostedUser_role")!)" .capitalized
    
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

    Postcell.date_lbl.text = "Posted on \(dateFormatterPrint.string(from: datees as Date))"
    
    if(Dic.value(forKey: "tag_name")as? String  !=  nil  && Dic.value(forKey: "tag_name")as? String != "")
    {
        let size = (Dic.value(forKey: "tag_name") as! NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        Postcell.tag_btn.frame = CGRect(x: Postcell.date_lbl.frame.origin.x, y: Postcell.date_lbl.frame.origin.y + Postcell.date_lbl.frame.size.height+4, width: size.width, height: 25)
        Postcell.tag_btn.isHidden = false
        Postcell.tag_btn.setTitle(Dic.value(forKey: "tag_name") as? String, for: .normal)
        Postcell.tag_btn.titleLabel?.textAlignment = .left
    }
    else
    {
        Postcell.tag_btn.isHidden = true
        Postcell.tag_btn.frame.size.width = 0
    }
    if(Dic.value(forKey: "reaction")as? String != nil && Dic.value(forKey: "reaction")as! String != "")
    {
        let size = (Dic.value(forKey: "reaction") as! NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
        Postcell.reaction_btn.isHidden = false
        let getreaction: String = Dic.value(forKey: "reaction") as! String
        if(getreaction == "Neutral")
        {
            Postcell.reaction_btn.frame = CGRect(x: Postcell.tag_btn.frame.origin.x + Postcell.tag_btn.frame.size.width + 10, y: Postcell.date_lbl.frame.origin.y + Postcell.date_lbl.frame.size.height + 4, width: size.width*1.5, height: 25)
            Postcell.reaction_btn.setImage(UIImage(named: "happy"), for: .normal)
            Postcell.reaction_btn.setTitle("Neutral", for: .normal)

        }
        else if(getreaction == "Thumbs-Down")
        {
             Postcell.reaction_btn.frame = CGRect(x: Postcell.tag_btn.frame.origin.x + Postcell.tag_btn.frame.size.width + 10, y: Postcell.date_lbl.frame.origin.y + Postcell.date_lbl.frame.size.height + 4, width: size.width, height: 25)
            Postcell.reaction_btn.setImage(UIImage(named: "Thumbs_down"), for: .normal)
            Postcell.reaction_btn.setTitle("Thumbs-down", for: .normal)

        }
        else if(getreaction == "Thumbs_Up")
        {
             Postcell.reaction_btn.frame = CGRect(x: Postcell.tag_btn.frame.origin.x + Postcell.tag_btn.frame.size.width + 10, y: Postcell.date_lbl.frame.origin.y + Postcell.date_lbl.frame.size.height+4, width: size.width , height: 25)
            Postcell.reaction_btn.setImage(UIImage(named: "Thumbs_up"), for: .normal)
            Postcell.reaction_btn.setTitle("Thumbs-up", for: .normal)

        }
        Postcell.reaction_btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 5.0)
        Postcell.reaction_btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)
        Postcell.reaction_btn.tintColor = UIColor.black
        Postcell.reaction_btn.contentHorizontalAlignment = .left
    }
    else
    {
        Postcell.reaction_btn.isHidden = true
    }
            let profileImage = Dic.value(forKey: "feedPostedUser_avatar") as? String ?? ""
            let urls = NSURL(string: "\(profileImage)")
            if(urls?.absoluteString != "")
             {
                
                 Postcell.profileImg.layer.cornerRadius = Postcell.profileImg.frame.size.width/2
                 Postcell.profileImg.layer.masksToBounds = true
                 Postcell.profileImg.kf.setImage(with: urls! as URL)

             }
            let likeDic: NSDictionary = Dic.value(forKey: "likes") as! NSDictionary
            let userlist: NSArray = likeDic.value(forKey: "user_list") as! NSArray
            let contained = userlist.contains("\(getuuid!)")
            Postcell.like_btn.tintColor = (contained) ? UIColor.red : UIColor.lightGray
            Postcell.like_btn.setTitle("\(likeDic.value(forKey: "count")!)", for: .normal)
            let CommentDic: NSDictionary = Dic.value(forKey: "comments") as! NSDictionary
            Postcell.comment_btn.setTitle("\(CommentDic.value(forKey: "count")!)", for: .normal)
           let font = UIFont(name: "Arial", size: 16.0)

    var height = Constant.heightForView(text: "\(Dic.value(forKey: "feedText") as? String ?? "")", font: font!, width: Postcell.comment_lbl.frame.size.width)
    
    height = (height < 30) ? 50 : height
    Postcell.comment_lbl_height.constant = (Dic.value(forKey: "feedText") as? String != "" && Dic.value(forKey: "feedText") != nil) ? height : 0
    Postcell.comment_lbl.text = Dic.value(forKey: "feedText") as? String
   
           Postcell.infoview.isHidden = (Dic.value(forKey: "isInfo") as! Bool == true ) ? false : true
            Postcell.info_btn.tag = indexPath.row
            Postcell.like_btn.tag = indexPath.row
            Postcell.comment_btn.tag = indexPath.row
            Postcell.info_btn.addTarget(self, action: #selector(InformationDetail), for: .touchUpInside)
            Postcell.like_btn.addTarget(self, action: #selector(likeDetail), for: .touchUpInside)
            Postcell.comment_btn.addTarget(self, action: #selector(commentDetail), for: .touchUpInside)

           let postInfo: NSMutableArray = (Dic["feededLevelObject"]! as! NSArray).mutableCopy() as! NSMutableArray
           let postinfoDic: NSDictionary = postInfo[0] as! NSDictionary
    let infoDetail = NSMutableArray()
    if(postinfoDic.value(forKey:"organization_name") != nil && postinfoDic.value(forKey: "organization_name")as? String != "")
    {
        
        infoDetail.add(" Org:  \(postinfoDic.value(forKey:"organization_name") as! NSString)")
    }
    
    if(postinfoDic.value(forKey:"sport_name") != nil && postinfoDic.value(forKey:"sport_name")as? String != "")
      {
        infoDetail.add(" Sport:  \(postinfoDic.value(forKey:"sport_name") as! NSString)")
      }
    
    if(postinfoDic.value(forKey:"season_name") != nil && postinfoDic.value(forKey: "season_name")as? String != "")
         {
            infoDetail.add(" Season:  \(postinfoDic.value(forKey:"season_name") as! NSString)")
         }
         
    if(postinfoDic.value(forKey:"level_name") != nil && postinfoDic.value(forKey: "level_name")as? String != "")
         {
            infoDetail.add(" Level:  \(postinfoDic.value(forKey:"level_name") as! NSString)")

         }
         
    if(postinfoDic.value(forKey: "team_name") != nil && postinfoDic.value(forKey: "team_name")as? String != "")
          {
            infoDetail.add(" Team:  \(postinfoDic.value(forKey:"team_name") as! NSString)")

          }
          
    
    if(postinfoDic.value(forKey:"membergroup_name") != nil && postinfoDic.value(forKey: "membergroup_name")as? String != "")
    {
        infoDetail.add(" Group:  \(postinfoDic.value(forKey:"membergroup_name") as! NSString)")


    }
    
    if(postinfoDic.value(forKey:"user_name") != nil && postinfoDic.value(forKey: "user_name")as? String != "")
    {
        infoDetail.add(" Player:  \(postinfoDic.value(forKey:"user_name") as! NSString)")
    }
    
    Postcell.getInfoDetail(getinfodetailArray: infoDetail)
     
    
            var postimageArray = NSMutableArray()
            let keyExists = Dic.value(forKey: "feedImageURL") != nil
            let videoExists = Dic.value(forKey: "feedVideoURL") != nil
            if(keyExists || videoExists)
            {
                Postcell.postimageviewHeight.constant = 350

                let imageheight: CGFloat = Postcell.postimageScroll.frame.size.height
                let imagewidth : CGFloat = Postcell.postimageScroll.frame.size.width
                if(videoExists)
                {
                    
                    if(Postcell.postImg != nil)
                    {
                        Postcell.postImg.removeFromSuperview()
                        //cell.videoview.isHidden = false

                    }

                    let postvideo : String = Dic.value(forKey: "feedVideoURL") as! String
                    let videoURL = NSURL(string: "\(postvideo)")

                    Postcell.videoview = AGVideoPlayerView()
                    Postcell.videoview.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: imageheight)
                    Postcell.postimageScroll.addSubview(Postcell.videoview)

                    Postcell.videoview.videoUrl = videoURL as URL?
                    Postcell.videoview.previewImageUrl = nil
                    Postcell.videoview.shouldAutoplay = false
                    Postcell.videoview.shouldAutoRepeat = false
                    Postcell.videoview.showsCustomControls = false
                    Postcell.videoview.shouldSwitchToFullscreen = true

                }
                else
                {
                   
                   

                postimageArray = (Dic["feedImageURL"]! as! NSArray).mutableCopy() as! NSMutableArray
                    //(Dic.value(forKey: "feedImageURL") as? NSMutableArray ?? nil)!
                    

                for i in 0..<postimageArray.count
                {
                    Postcell.postImg = UIImageView()
                    
                    Postcell.postImg.frame = (i==0) ? CGRect(x: 0, y: 0, width: imagewidth, height: imageheight) : CGRect(x: CGFloat(i) * imagewidth, y: 0, width : imagewidth, height: imageheight)
                   // postImg.backgroundColor = UIColor.red
                    let posturl = URL(string: "\(postimageArray[i])")
                    Postcell.postImg.kf.setImage(with: posturl! as URL)
                    Postcell.postimageScroll.addSubview(Postcell.postImg)
                    Postcell.pageControl.numberOfPages = postimageArray.count
                    Postcell.pageControl.tag = i
                    

                }
//                    cell.postImg.isHidden = false
//                    cell.videoview.isHidden = true
                }
                Postcell.postimageScroll.contentSize = CGSize(width: CGFloat(postimageArray.count) * imagewidth, height: imageheight)
                Postcell.pageControl.isHidden = (postimageArray.count > 1) ? false : true

            }
            else{

                 Postcell.postimageviewHeight.constant = 0
                 Postcell.pageControl.isHidden = true
                
            }
    Postcell.infoviewHeight.constant = (Dic.value(forKey: "isInfo") as! Bool  == true) ? Postcell.addinfoview_height.constant + 35 : 0
            Postcell.postimageScroll.isPagingEnabled = true
            Postcell.postimageScroll.delegate = self
            Postcell.pageControl.currentPage = 0;
            Postcell.pageControl.numberOfPages = postimageArray.count;
            Postcell.selectionStyle = .none
     particularCellHeight = Postcell.infoviewHeight.constant + Postcell.comment_lbl_height.constant + Postcell.postimageviewHeight.constant + Postcell.profileview_height.constant + Postcell.likeview_height.constant
            return Postcell
        }

        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(self.commonArray.count>0)
        {
            //Postcell = self.post_tbl.dequeueReusableCell(withIdentifier: "post", for: indexPath) as? PostCell
            if let player = Postcell.avPlayerLayer?.player {
                if player.rate != 0 {
                    player.pause()
    }
}
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.commonArray.count>0)
        {
    let Dic: NSDictionary = self.commonArray?[indexPath.row] as! NSDictionary
    //let height: CGFloat = Postcell.infoviewHeight.constant + Postcell.comment_lbl_height.constant + Postcell.postimageviewHeight.constant + Postcell.profileview_height.constant + Postcell.likeview_height.constant
            print("cellheight:\(particularCellHeight)")
        let keyExists = Dic.value(forKey: "feedImageURL") != nil
        let videoExists = Dic.value(forKey: "feedVideoURL") != nil
        if(keyExists == true  || videoExists == true)
        {
            
            if(Dic.value(forKey: "isInfo") as! Bool == true)
            {
                if(Dic.value(forKey: "feedText") as? String != "" && Dic.value(forKey: "feedText") != nil)
                {
                   
                   return particularCellHeight  //705.0
                }
                else
                {
                    return particularCellHeight  //655.0
                }
                
            }
            else
            {
               
                if(Dic.value(forKey: "feedText") as? String != "" && Dic.value(forKey: "feedText") != nil)
                {
                            
                    return particularCellHeight  //565.0
                }
                else
                {
                    //return cell.postimageviewHeight.constant + cell.comment_lbl_height.constant + cell.infoviewHeight.constant
                    return particularCellHeight //515.0
                }
                
            }

        }
        else
        {
            if(Dic.value(forKey: "isInfo") as! Bool == true)
            {
                return particularCellHeight  //360.0
            }
            else
            {
            return particularCellHeight  //220.0
            }

        }
        }
        return 0
    }
    @objc func videoplay(_ sender: UIButton)
    {
        let button = sender
        let cell = button.superview?.superview as? PostCell

        let dic: NSDictionary = commonArray?[sender.tag] as! NSDictionary
        let postvideo : String = dic.value(forKey: "feedVideoURL") as! String
        let videoURL = NSURL(string: "\(postvideo)")
       //avPlayer = AVPlayer(url: videoURL! as URL)
       
        //avPlayerLayer = AVPlayerLayer(player: avPlayer)
        //avPlayerLayer?.frame = cell!.bounds
        if(cell?.avPlayer?.rate == 0)
        {
            cell?.avPlayer!.play()
            
            videoplay_btn.setImage(UIImage(named: "pause"), for: .normal)
        }
        else
        {
            cell?.avPlayer?.pause()
            videoplay_btn.setImage(UIImage(named: "video_play"), for: .normal)

        }
       
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
            newDict.setValue(false, forKey: "isInfo")
        }
        commonArray.replaceObject(at: indexno, with: newDict)
        selectIndex = indexno
        let indexPosition = IndexPath(row: selectIndex, section: 0)
       // self.post_tbl.beginUpdates()
        //self.post_tbl.reloadRows(at: [indexPosition], with: .none)
        //self.post_tbl.endUpdates()
        self.post_tbl.reloadData()
    }
    func refresh(sender: UIRefreshControl)
    {
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
        objpostvc.delegate = self
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
           Constant.showInActivityIndicatory()
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
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
                                Constant.showInActivityIndicatory()

                            }
                            else
                            {
                                self.commonArray = NSMutableArray()
                                self.post_tbl.reloadData()
                                self.emptyfeed_img.isHidden = (self.commonArray.count == 0) ? false : true
                                Constant.showInActivityIndicatory()

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
extension Dashboardvc: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}

