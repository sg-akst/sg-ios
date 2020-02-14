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
import Kingfisher
import AlamofireImage
import Firebase
import AVKit


class Dashboardvc: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var post_tbl: UITableView!
    @IBOutlet weak var emptyfeed_img: UIImageView!
    var isInfo: Bool = false
    var selectIndex: Int!
    var getuuid : String!

    var commonArray: NSMutableArray!
    
    var avPlayer: AVPlayer?
       var avPlayerLayer: AVPlayerLayer?
       var paused: Bool = false
    var postImg: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

                if revealViewController() != nil {
                    revealViewController().rearViewRevealWidth = self.view.frame.size.width - 70
                    view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
        post_tbl.tableFooterView = UIView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFeedMethod()
        
    }
    func getFeedMethod()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        getuuid = UserDefaults.standard.string(forKey: "UUID")
               
        let db = Firestore.firestore()
        db.collection("feed").whereField("feedToUserId", arrayContains: getuuid!).order(by: "feedPostedDatetime", descending: true).getDocuments() { (querySnapshot, err) in
                  if let err = err {
                      print("Error getting documents: \(err)")
                  } else {
                      //self.roleby_reasonArray = NSMutableArray()
                      for document in querySnapshot!.documents {
                          let data: NSDictionary = document.data() as NSDictionary
                        self.commonArray.add(data)
                       print("\(document.documentID) =>\(data)")

                      }
                    
                    self.post_tbl.reloadData()
                    self.emptyfeed_img.isHidden = (self.commonArray.count == 0) ? false : true
                    Constant.showInActivityIndicatory()

                  }
              }

        }
   
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        // Do your job, when done:
        refreshControl.endRefreshing()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return commonArray.count
        }

        // create a cell for each table view row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:PostCell = self.post_tbl.dequeueReusableCell(withIdentifier: "post") as! PostCell
            let Dic: NSDictionary = self.commonArray?[indexPath.row] as! NSDictionary
            
            cell.username_lbl?.text = "\(Dic.value(forKey: "feedPostedUser_firstName")!)" + " " + "\(Dic.value(forKey: "feedPostedUser_middleInitial")!)" + " " + "\(Dic.value(forKey: "feedPostedUser_lastName")!)" + " - " + "\(Dic.value(forKey: "feedPostedUser_role")!)" .capitalized
            let timestamp: Timestamp = Dic.value(forKey: "feedPostedDatetime") as! Timestamp
             let datees: Date = timestamp.dateValue()
             print(datees)
             let dateFormatterGet = DateFormatter()
             dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

             let dateFormatterPrint = DateFormatter()
             dateFormatterPrint.dateFormat = "MMM dd,yyyy HH:mm:ss a"
             print(dateFormatterPrint.string(from: datees as Date))

             cell.date_lbl.text = "Posted on \(dateFormatterPrint.string(from: datees as Date))"
            let profileImage = Dic.value(forKey: "feedPostedUser_avatar") as? String ?? ""
            let urls = NSURL(string: "\(profileImage)")
            if(urls?.absoluteString != "")
             {
                cell.profileImg.af_setImage(withURL: urls! as URL)
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
            cell.comment_lbl.text = Dic.value(forKey: "feedText") as? String
            cell.infoviewHeight.constant = (isInfo == true) ? 100 : 0
            
            cell.infoview.isHidden = (isInfo == true) ? false : true
            cell.info_btn.tag = indexPath.row
            cell.like_btn.tag = indexPath.row
            cell.comment_btn.tag = indexPath.row
            cell.info_btn.addTarget(self, action: #selector(InformationDetail), for: .touchUpInside)
            cell.like_btn.addTarget(self, action: #selector(likeDetail), for: .touchUpInside)
            cell.comment_btn.addTarget(self, action: #selector(commentDetail), for: .touchUpInside)

           let postInfo: NSMutableArray = Dic.value(forKey: "feededLevelObject") as! NSMutableArray
           let postinfoDic: NSDictionary = postInfo[0] as! NSDictionary
            cell.org_lbl.text = postinfoDic.value(forKey: "organization_name") as? String
            cell.season_lbl.text = postinfoDic.value(forKey: "season_name") as? String
            cell.sport_lbl.text = postinfoDic.value(forKey: "sport_name") as? String
            cell.team_lbl.text = postinfoDic.value(forKey: "team_name") as? String
          // cell.video_view.isHidden = true

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
                    let player = AVPlayer(url: videoURL! as URL)
                    
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = cell.bounds
                    player.play()
                    let visdeoview = UIView()
                                       
                visdeoview.frame =  CGRect(x: 0, y: 0, width: imagewidth, height: imageheight)
                visdeoview.layer.addSublayer(playerLayer)
                    visdeoview.layer.display()
                cell.postimageScroll.addSubview(visdeoview)
                
                    
                }
                else
                {
                postimageArray = (Dic.value(forKey: "feedImageURL") as? NSMutableArray ?? nil)!
                

                for i in 0..<postimageArray.count
                {
                     postImg = UIImageView()
                    
                    postImg.frame = (i==0) ? CGRect(x: 0, y: 0, width: imagewidth, height: imageheight) : CGRect(x: CGFloat(i) * imagewidth, y: 0, width : imagewidth, height: imageheight)
                   // postImg.backgroundColor = UIColor.red
                    let posturl = NSURL(string: "\(postimageArray[i])")
                    postImg.af_setImage(withURL: posturl! as URL)
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
                
//                let videoExists = Dic.value(forKey: "feedVideoURL") != nil
//                 if(videoExists)
//                 {
//                   // cell.video_view.isHidden = false
//                    let postvideo : String = Dic.value(forKey: "feedVideoURL") as! String
//                    let videoURL = NSURL(string: "\(postvideo)")
//                    let player = AVPlayer(url: videoURL! as URL)
//
//                    let playerLayer = AVPlayerLayer(player: player)
//                    playerLayer.frame = cell.bounds
//                    cell.postimageScroll.layer.addSublayer(playerLayer)
//                 cell.postimageviewHeight.constant = 350
//
//                }
                
            }
            cell.postimageScroll.isPagingEnabled = true
            cell.postimageScroll.delegate = self
            cell.pageControl.addTarget(self, action: #selector(turnPage), for: .valueChanged)
            cell.pageControl.currentPage = 0;
            cell.pageControl.numberOfPages = postimageArray.count;
            return cell
        }

        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
    let Dic: NSDictionary = self.commonArray?[indexPath.row] as! NSDictionary
        
        let keyExists = Dic.value(forKey: "feedImageURL") != nil
        let videoExists = Dic.value(forKey: "feedVideoURL") != nil

        if(keyExists == true  || videoExists == true)
        {
            if(isInfo == true && indexPath.row == selectIndex)
            {
                return 650.0
            }
            else
            {
            return 550.0
            }

        }
        else
        {
            if(isInfo == true)
            {
                return 305.0
            }
            else
            {
            return 205.0
            }

        }
    }

    @objc func InformationDetail(_ sender: UIButton)
    {
        let indexno = sender.tag
        if(isInfo == false)
        {
        isInfo = true
        selectIndex = indexno
        }
        else
        {
          isInfo = false
          selectIndex = nil
        }
        let indexPosition = IndexPath(row: indexno, section: 0)
        self.post_tbl.reloadRows(at: [indexPosition], with: .none)

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
        
        //cell?.like_btn.tintColor = (contained) ? UIColor.red : UIColor.lightGray
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
                    likeUpdatemethod(updateDetail: maplike.copy() as! NSDictionary, userFeedid: feedId as! String, selectIdexdetail: Dic)
                    
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
                    DislikeMethod(updateDetail: maplike.copy() as! NSDictionary, userFeedid: feedId as! String)
                    
                   
                }
        //let indexPosition = IndexPath(row: indexno, section: 0)
        //self.post_tbl.reloadRows(at: [indexPosition], with: .none)
    }
    func likeUpdatemethod(updateDetail: NSDictionary, userFeedid: String, selectIdexdetail: NSDictionary)
    {
        Constant.internetconnection(vc: self)
        //Constant.showActivityIndicatory(uiView: self.view)
        let db = Firestore.firestore()
        db.collection("feed").document("\(userFeedid)").updateData(["likes": updateDetail])
                   { err in
                       if let err = err {
                           print("Error updating document: \(err)")
                          // Constant.showInActivityIndicatory()

                       } else {
                    
                        db.collection("feed").document("\(userFeedid)").collection("feedLikes").document("\(self.getuuid!)").setData(["avatar": "\(selectIdexdetail.value(forKey: "feedPostedUser_avatar")!)","created_dateTime" : Date(),"created_userid": "\(self.getuuid!)","first_name": "\(selectIdexdetail.value(forKey: "feedPostedUser_firstName")!)","last_name": "\(selectIdexdetail.value(forKey: "feedPostedUser_lastName")!)","middle_initial": "\(selectIdexdetail.value(forKey: "feedPostedUser_middleInitial")!)","suffix": "\(selectIdexdetail.value(forKey: "feedPostedUser_suffix")!)","update_userid": "","updated_dateTime": "","user_id":"\(self.getuuid!)"])
                        { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                                //Constant.showInActivityIndicatory()

                            } else {
                                print("Document successfully updated")
                               // Constant.showInActivityIndicatory()

                            }
                        }
                    }
        }
    }
    
    func DislikeMethod(updateDetail: NSDictionary, userFeedid: String)
    {
        Constant.internetconnection(vc: self)
        //Constant.showActivityIndicatory(uiView: self.view)
        let db = Firestore.firestore()
        db.collection("feed").document("\(userFeedid)").updateData(["likes": updateDetail])
                   { err in
                       if let err = err {
                           print("Error updating document: \(err)")
                          // Constant.showInActivityIndicatory()

                       } else {
db.collection("feed").document("\(userFeedid)").collection("feedLikes").document("\(self.getuuid!)").delete()
                        { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                                //Constant.showInActivityIndicatory()

                            } else {
                                print("Document successfully updated")
                               // Constant.showInActivityIndicatory()

                            }
                        }
                    }
        }
    }
    
    @objc func turnPage( aPageControl:UIPageControl)
    {
//        let selectedPage: NSInteger  = self.pageControl.currentPage
//        var frame: CGRect = self.bounds
//        frame.origin.x = frame.size.width * CGFloat(selectedPage)
//       frame.origin.y = 0
//        self.postimageScroll.scrollRectToVisible(frame, animated: true)
//
//       pageControl.currentPage = selectedPage;
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
        self.navigationController?.pushViewController(objCommentvc, animated: true)
        
    }
    @IBAction func postVideoandImage(_ sender: UIButton)
    {
       let objpostvc: PostImageVC = (self.storyboard?.instantiateViewController(identifier: "postimage"))!
        self.navigationController?.pushViewController(objpostvc, animated: true)
        
    }
    @IBAction func menuBtn(_ sender: UIButton)
    {
        self.revealViewController().revealToggle(self)

    }
    
}
