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


class Dashboardvc: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var post_tbl: UITableView!
    @IBOutlet weak var emptyfeed_img: UIImageView!

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
              db.collection("feed").getDocuments() { (querySnapshot, err) in
                  if let err = err {
                      print("Error getting documents: \(err)")
                  } else {
                      //self.roleby_reasonArray = NSMutableArray()
                      for document in querySnapshot!.documents {
                          let data: NSDictionary = document.data() as NSDictionary
                        let feedUserId: NSMutableArray = data.value(forKey: "feedToUserId") as! NSMutableArray
                        for i in 0..<feedUserId.count
                        {
                            let roleDic: String = feedUserId[i] as! String
                           // let role: String = roleDic.value(forKey: "role") as! String
                            if(getuuid == roleDic as String)
                            {
                                self.commonArray.add(data)
                            }
                        }
                        self.post_tbl.reloadData()
                        self.emptyfeed_img.isHidden = (self.commonArray.count == 0) ? false : true
                          print("\(document.documentID) => \(data)")
                      }
                  }
              }

          
          Constant.showInActivityIndicatory()
      
        
        
        
          
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
            let Dic: NSDictionary = commonArray?[indexPath.row] as! NSDictionary
            
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
            let url = URL(string: "\(Dic.value(forKey: "feedImageURL") ?? "")")
             if(url != nil)
             {
               cell.profileImg.kf.setImage(with: url)
                 cell.profileImg.layer.cornerRadius = cell.profileImg.frame.size.width/2
                 cell.profileImg.layer.backgroundColor = UIColor.lightGray.cgColor
             }
            let likeDic: NSDictionary = Dic.value(forKey: "likes") as! NSDictionary
            cell.fav_count_lbl.text = likeDic.value(forKey: "count") as? String
            let CommentDic: NSDictionary = Dic.value(forKey: "comments") as! NSDictionary
            cell.comment_count_lbl.text = CommentDic.value(forKey: "count") as? String
            cell.comment_lbl.text = Dic.value(forKey: "feedText") as? String
            
            return cell
        }

        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 450.0
    }
    
    
    @IBAction func menuBtn(_ sender: UIButton)
    {
        self.revealViewController().revealToggle(self)

    }
    
}
