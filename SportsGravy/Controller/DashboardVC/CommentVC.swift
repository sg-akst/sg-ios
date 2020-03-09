//
//  CommentVC.swift
//  SportsGravy
//
//  Created by CSS on 06/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class CommentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var like_btn: UIButton!
    @IBOutlet weak var comment_btn: UIButton!
    @IBOutlet weak var comment_txt: UITextField!
    @IBOutlet weak var comment_tbl: UITableView!
    @IBOutlet weak var send_btn: UIButton!
    @IBOutlet weak var commentlist_view: UIView!

    var selectComment: NSDictionary!
    var commentArray: NSMutableArray!
    var getuuid: String!
   
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.comment_tbl.delegate = self
        self.comment_tbl.dataSource = self
        getuuid = UserDefaults.standard.string(forKey: "UUID")
        self.commentArray = NSMutableArray()
        getcommentlist()

//        let likeDic: NSDictionary = self.selectComment.value(forKey: "likes") as! NSDictionary
//        let userlist: NSMutableArray = likeDic.value(forKey: "user_list") as! NSMutableArray
//        let containeds = userlist.contains("\(getuuid!)")
//        like_btn.setTitle("\(likeDic.value(forKey: "count")!)", for: .normal)
//        like_btn.tintColor = (containeds) ? UIColor.red : UIColor.lightGray
//        let commentDic: NSDictionary = self.selectComment.value(forKey: "comments") as! NSDictionary
//        //commentArray = commentDic.value(forKey: "user_list") as? NSMutableArray
//        comment_btn.setTitle("\(commentDic.value(forKey: "count")!)", for: .normal)
//        let feedId = selectComment.value(forKey: "feed_id")
       // commentListMethod(feedid: feedId as! String)
        comment_tbl.sizeToFit()
        comment_tbl.tableFooterView = UIView()

        
    }
    func getcommentlist()
    {
       let db = Firestore.firestore()
       //let docRef = db.collection("feed").document("\(getuuid!)")
        db.collection("feed").whereField("feed_id", isEqualTo: selectComment.value(forKey: "feed_id")!).getDocuments() { (querySnapshot, err) in
           if let err = err {
               print("Error getting documents: \(err)")
               Constant.showInActivityIndicatory()

           } else {
               self.commentArray = NSMutableArray()

               for document in querySnapshot!.documents {
                   let data: NSDictionary = document.data() as NSDictionary
                   let likeDic: NSDictionary = data.value(forKey: "likes") as! NSDictionary
                   let userlist: NSMutableArray = likeDic.value(forKey: "user_list") as! NSMutableArray
                let containeds = userlist.contains("\(self.getuuid!)")
                self.like_btn.setTitle("\(likeDic.value(forKey: "count")!)", for: .normal)
                self.like_btn.tintColor = (containeds) ? UIColor.red : UIColor.lightGray
                let commentDic: NSDictionary = data.value(forKey: "comments") as! NSDictionary
                //self.commentArray = commentDic.value(forKey: "user_list") as? NSMutableArray
                self.comment_btn.setTitle("\(commentDic.value(forKey: "count")!)", for: .normal)
                let feedId = self.selectComment.value(forKey: "feed_id")
                   //self.commentArray.add(data)
               }

              self.comment_tbl.reloadData()
               Constant.showInActivityIndicatory()
            self.commentListMethod(feedid: self.selectComment.value(forKey: "feed_id") as! String)

           }
        }
    }
    @IBAction func likebtnAction(_ sender: UIButton)
    {
        let likeDic: NSDictionary = selectComment.value(forKey: "likes") as! NSDictionary
        var userlist: NSArray = likeDic.value(forKey: "user_list") as! NSArray
        let contained = userlist.contains("\(getuuid!)")
        let feedId = selectComment.value(forKey: "feed_id")
        if(contained == false)
        {
            self.like_btn.tintColor = UIColor.red
            let likecount: Int = Int("\(likeDic.value(forKey: "count")!)")! + 1
            self.like_btn.setTitle("\(likecount)", for: .normal)
            let addUserlist: NSMutableArray = NSMutableArray()
            addUserlist.add(getuuid)
            userlist = addUserlist.copy() as! NSArray
            let maplike: NSMutableDictionary = NSMutableDictionary()
            maplike.setValue(likecount, forKey: "count")
            maplike.setValue(userlist, forKey: "user_list")
            
            var newDict: NSMutableDictionary  = NSMutableDictionary()
            let oldDict: NSDictionary = selectComment
            newDict = oldDict.mutableCopy() as! NSMutableDictionary
            newDict.setValue(maplike.copy(), forKey: "likes")
            self.selectComment = newDict.copy() as? NSDictionary
            
            likeUpdatemethod(updateDetail: maplike.copy() as! NSDictionary, userFeedid: feedId as! String, selectIdexdetail: selectComment)
            
        }
        else
        {
            self.like_btn.tintColor = UIColor.lightGray
            let likecount: Int = Int("\(likeDic.value(forKey: "count")!)")! - 1
            self.like_btn.setTitle("\(likecount)", for: .normal)
            let addUserlist: NSMutableArray = NSMutableArray()
            addUserlist.remove(getuuid)
            userlist = addUserlist.copy() as! NSArray
            let maplike: NSMutableDictionary = NSMutableDictionary()
            maplike.setValue(likecount, forKey: "count")
            maplike.setValue(userlist, forKey: "user_list")
            
            var newDict: NSMutableDictionary  = NSMutableDictionary()
            let oldDict: NSDictionary = selectComment
            newDict = oldDict.mutableCopy() as! NSMutableDictionary
            newDict.setValue(maplike.copy(), forKey: "likes")
            self.selectComment = newDict.copy() as? NSDictionary
            
            
            DislikeMethod(updateDetail: maplike.copy() as! NSDictionary, userFeedid: feedId as! String)
            
           
        }
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
    @IBAction func commentSend(_ sender: UIButton)
    {
        let commentDic: NSDictionary = selectComment.value(forKey: "comments") as! NSDictionary
        var userlist: NSArray = commentDic.value(forKey: "user_list") as! NSArray
       // let contained = userlist.contains("\(getuuid!)")
        let feedId = selectComment.value(forKey: "feed_id")
//        if(contained == false)
//        {
            //self.comment_btn.tintColor = UIColor.red
            let Commentcount: Int = Int("\(commentDic.value(forKey: "count")!)")! + 1
            self.comment_btn.setTitle("\(Commentcount)", for: .normal)
            let addUserlist: NSMutableArray = NSMutableArray()
            addUserlist.add(getuuid)
            userlist = addUserlist.copy() as! NSArray
            let maplike: NSMutableDictionary = NSMutableDictionary()
            maplike.setValue(Commentcount, forKey: "count")
            maplike.setValue(userlist, forKey: "user_list")
        CommentUpdatemethod(updateDetail: maplike.copy() as! NSDictionary, userFeedid: feedId! as! String, selectIdexdetail: selectComment)
            

    }
    
    func commentListMethod(feedid: String)
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
       let db = Firestore.firestore()
        let docRef = db.collection("feed").document("\(feedid)")
        docRef.collection("feedComments").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                Constant.showInActivityIndicatory()

            } else {
                self.commentArray = NSMutableArray()
                for document in querySnapshot!.documents {
                    let data: NSDictionary = document.data() as NSDictionary
                    self.commentArray.add(data)
                }

               self.comment_tbl.reloadData()
                Constant.showInActivityIndicatory()
            }
            
            if(self.commentArray.count>0)
            {
                self.commentlist_view.isHidden = true
            }
            else
            {
                self.commentlist_view.isHidden = false

            }
            
        }
        
    }
    func CommentUpdatemethod(updateDetail: NSDictionary, userFeedid: String, selectIdexdetail: NSDictionary)
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let db = Firestore.firestore()
        db.collection("feed").document("\(userFeedid)").updateData(["comments": updateDetail])
                   { err in
                       if let err = err {
                           print("Error updating document: \(err)")
                           Constant.showInActivityIndicatory()

                       } else {
                        db.collection("feed").document("\(userFeedid)").collection("feedComments").document().setData(["avatar": "\(selectIdexdetail.value(forKey: "feedPostedUser_avatar")!)","created_dateTime" : Date(),"created_userid": "\(self.getuuid!)","first_name": "\(selectIdexdetail.value(forKey: "feedPostedUser_firstName")!)","last_name": "\(selectIdexdetail.value(forKey: "feedPostedUser_lastName")!)","middle_initial": "\(selectIdexdetail.value(forKey: "feedPostedUser_middleInitial")!)","suffix": "\(selectIdexdetail.value(forKey: "feedPostedUser_suffix")!)","update_userid": "","updated_dateTime": "","user_id":"\(self.getuuid!)", "comment_desc": "\(self.comment_txt.text!)"])
                        { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                                Constant.showInActivityIndicatory()

                            } else {
                                print("Document successfully updated")
                                //self.comment_tbl.reloadData()
                                Constant.showInActivityIndicatory()
                                self.comment_txt.text = ""
                                self.commentListMethod(feedid: userFeedid)


                            }
                        }
                    }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.commentArray.count
            }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

       
           return 80.0
        
     }

            // create a cell for each table view row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: CommentCell = self.comment_tbl.dequeueReusableCell(withIdentifier: "commentcell") as! CommentCell
        let dic: NSDictionary = self.commentArray?[indexPath.row] as! NSDictionary
        cell.username_lbl?.text = "\(dic.value(forKey: "first_name")!)" + " " + "\(dic.value(forKey: "middle_initial")!)" + " " + "\(dic.value(forKey: "last_name")!)"
        //cell.postdate_lbl.text = dic.value(forKey: "created_dateTime") as? String
        cell.comment_lbl.text = dic.value(forKey: "comment_desc") as? String
        let timestamp: Timestamp = dic.value(forKey: "created_dateTime") as! Timestamp
        let datees: Date = timestamp.dateValue()
        print(datees)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        print(dateFormatterPrint.string(from: datees as Date))

        cell.postdate_lbl.text = "Post on \(dateFormatterPrint.string(from: datees as Date))"
        let url = URL(string: "\(dic.value(forKey: "avatar")!)")
        if(url != nil)
        {
          cell.profile_img.kf.setImage(with: url)
            cell.profile_img.layer.cornerRadius = cell.profile_img.frame.size.width/2
           cell.profile_img.layer.backgroundColor = UIColor.lightGray.cgColor
            cell.profile_img.contentMode = .scaleAspectFill

        }
        
            cell.selectionStyle = .none
                return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You tapped cell number \(indexPath.row).")
       
        
    }
    
    @IBAction func backcommentbtn(_ sender: UIButton)
           {
             self.navigationController?.popViewController(animated: true)
           }
       
}
