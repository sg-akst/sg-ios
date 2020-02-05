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


class Dashboardvc: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var post_tbl: UITableView!
    @IBOutlet weak var emptyfeed_img: UIImageView!
    var isInfo: Bool = false
    var selectIndex: Int!

    var commonArray: NSMutableArray!

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
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
               
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
            
            cell.username_lbl?.text = "\(Dic.value(forKey: "feedPostedUser_firstName")!)" + " " + "\(Dic.value(forKey: "feedPostedUser_middleInitial")!)" + " " + "\(Dic.value(forKey: "feedPostedUser_lastName")!)" + "-" + "\(Dic.value(forKey: "feedPostedUser_role")!)"
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
            cell.fav_count_lbl.text = "\(likeDic.value(forKey: "count")!)"
            let CommentDic: NSDictionary = Dic.value(forKey: "comments") as! NSDictionary
            cell.comment_count_lbl.text = "\(CommentDic.value(forKey: "count")!)"
            cell.comment_lbl.text = Dic.value(forKey: "feedText") as? String
            cell.infoviewHeight.constant = (isInfo == true) ? 100 : 0
            
            cell.infoview.isHidden = (isInfo == true) ? false : true
            cell.info_btn.tag = indexPath.row
            cell.like_btn.tag = indexPath.row
            cell.comment_btn.tag = indexPath.row
            cell.info_btn.addTarget(self, action: #selector(InformationDetail), for: .touchUpInside)
            //cell.like_btn.addTarget(self, action: #selector(likeDetail), for:. touchUpInside)
            cell.comment_btn.addTarget(self, action: #selector(commentDetail), for: . touchUpInside)

           let postInfo: NSMutableArray = Dic.value(forKey: "feededLevelObject") as! NSMutableArray
           let postinfoDic: NSDictionary = postInfo[0] as! NSDictionary
            cell.org_lbl.text = postinfoDic.value(forKey: "organization_name") as? String
            cell.season_lbl.text = postinfoDic.value(forKey: "season_name") as? String
            cell.sport_lbl.text = postinfoDic.value(forKey: "sport_name") as? String
            cell.team_lbl.text = postinfoDic.value(forKey: "team_name") as? String
           
            var postimageArray = NSMutableArray()
            let keyExists = Dic.value(forKey: "feedImageURL") != nil
            if(keyExists)
            {
                postimageArray = (Dic.value(forKey: "feedImageURL") as? NSMutableArray ?? nil)!
                 //cell.postImageview.isHidden = false
                cell.postimageviewHeight.constant = 350

                let imageheight: CGFloat = cell.postimageScroll.frame.size.height
                let imagewidth : CGFloat = cell.postimageScroll.frame.size.width

                for i in 0..<postimageArray.count
                {
                    let postImg: UIImageView = UIImageView()
                    
                    postImg.frame = (i==0) ? CGRect(x: CGFloat (5), y: 0, width: imagewidth, height: imageheight) : CGRect(x: CGFloat(i) * imagewidth, y: 0, width : imagewidth, height: imageheight)
                    postImg.backgroundColor = UIColor.red
                    let posturl = NSURL(string: "\(postimageArray[i])")
                    postImg.af_setImage(withURL: posturl! as URL)
                    cell.postimageScroll.addSubview(postImg)
                    cell.pageControl.numberOfPages = postimageArray.count
                    //cell.pageControl.tag = i
                    

                }
                cell.postimageScroll.contentSize = CGSize(width: CGFloat(postimageArray.count) * imagewidth, height: imageheight)
                cell.pageControl.isHidden = (postimageArray.count > 1) ? false : true

            }
            else{
               // cell.postimageScroll.isHidden = true
                cell.postimageviewHeight.constant = 0
                cell.pageControl.isHidden = true
            }
            
            return cell
        }

        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
    let Dic: NSDictionary = self.commonArray?[indexPath.row] as! NSDictionary
        
        let keyExists = Dic.value(forKey: "feedImageURL") != nil
        if(keyExists)
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
    
    @objc func likeDetail(_ sender: UIButton)
    {
        let button = sender
        let cell = button.superview?.superview as? PostCell
        if((cell?.like_btn.isSelected)!)
        {
            cell?.like_btn.tintColor = UIColor.red
            let likecount: Int = Int((cell?.fav_count_lbl.text)!)! + 1
            cell?.fav_count_lbl.text = "\(likecount)"
        }
        else
        {
            cell?.like_btn.tintColor = UIColor.lightGray
            let likecount: Int = Int((cell?.fav_count_lbl.text)!)! + 1
            cell?.fav_count_lbl.text = "\(likecount)"

        }
        
        
    }
    @objc func commentDetail(_ sender: UIButton)
    {
           
    }
    
    @IBAction func menuBtn(_ sender: UIButton)
    {
        self.revealViewController().revealToggle(self)

    }
    
}
