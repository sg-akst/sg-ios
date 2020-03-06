//
//  PostImageVC.swift
//  SportsGravy
//
//  Created by CSS on 07/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import Alamofire
import Photos


struct PostGroupSection {
    let title: String
    var userlist: NSDictionary
}

class PostImageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectuserGroubDelegate, SelectPostTagDelegate, SelectpostCanDelegate,SelectReactionDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    func selectReactionDetail(userDetail: NSDictionary) {
        let userTeam: NSDictionary = userDetail
        Reaction = userTeam.value(forKey: "reation_title") as? String
        for index in self.postsections.indices {
             if(index == 2)
             {
               postsections[index].userlist = userTeam
                 
             }
         }
         let sectionIndex = IndexSet(integer: 2)
         self.postteam_tbl.reloadSections(sectionIndex, with: .none)
        
         postTbl_height.constant = CGFloat(self.postsections.count * 60) + CGFloat(60)
        

    }
    
    
    func selectPostCanDetail(userDetail: NSDictionary) {
        let userTeam: NSDictionary = userDetail
         //teamList = userTeam
         cannedResponseTitle = userTeam.value(forKey: "cannedResponseTitle") as? String
        cannedResponseDesc = userTeam.value(forKey: "cannedResponseDesc") as? String
        self.post_content_txt.text = cannedResponseDesc
        
         for index in postsections.indices {
             if(index == 3)
             {
               postsections[index].userlist = userTeam
                 
             }// Ok
         }
         let sectionIndex = IndexSet(integer: 3)
         self.postteam_tbl.reloadSections(sectionIndex, with: .none)
        // postTbl_height.constant = CGFloat(self.postsections.count * 60) + CGFloat(60)

    }
    
    func selectPostTagDetail(userDetail: NSDictionary) {
        let userTeam: NSDictionary = userDetail
         //teamList = userTeam
         selectTag = userTeam.value(forKey: "tag_id") as? String
        
         for index in postsections.indices {
             if(index == 1)
             {
               postsections[index].userlist = userTeam
             }

         }
          print("usercount:\(sectionCount!)")
         let sectionIndex = IndexSet(integer: 1)

         self.postteam_tbl.reloadSections(sectionIndex, with: .none)
       // postTbl_height.constant = CGFloat(self.postsections.count * 60) + CGFloat(60)

    }
    
    let imageviewcontroller = UIImagePickerController()
    
    func selectuserGroubDetail(userDetail: NSMutableArray) {
        let userTeam: NSDictionary = userDetail[0] as! NSDictionary
        teamList = userTeam
        
        SelectgetrolebySeasonid = userTeam.value(forKey: "role_by_season_id") as? String
        getSportid = userTeam.value(forKey: "sport_id") as? String
        getOrganizationid = userTeam.value(forKey: "organization_id") as? String
        SelectgetLevelid = userTeam.value(forKey: "level_id") as? String
        SelectgetTeamId = userTeam.value(forKey: "team_id") as? String
        
        selectTeamName = userTeam.value(forKey: "team_name") as? String
        usergroupid = userTeam.value(forKey: "membergroup_id") as? String
        playergroupid = userTeam.value(forKey: "user_id") as? String
        
        for index in postsections.indices {
            if(index == 0)
            {
              postsections[index].userlist = userTeam
                
            }// Ok
        }
        let sectionIndex = IndexSet(integer: 0)
        self.postteam_tbl.reloadSections(sectionIndex, with: .none)
        //postTbl_height.constant = CGFloat(self.postsections.count * 60)

        
    }
    
    
    @IBOutlet weak var postteam_tbl: UITableView!
    @IBOutlet weak var post_content_txt: UITextField!
    @IBOutlet weak var postimage: UIImageView!
    @IBOutlet weak var postvideo: UIImageView!
    @IBOutlet weak var postTbl_height: NSLayoutConstraint!
    var postsections = [PostGroupSection]()
    var sectionCount: Int!

    var teamList: NSDictionary = [:]
    var tagList = [String: String]()
    var reactionList = [String: String]()
    var canresponseList = [String: String]()
    var getUserdetails: NSDictionary!
    var getPostimageUrl: NSMutableArray!
    var getPostVideoUrl: String!
    var selectTeamName: String!
    var selectTag: String!
    var cannedResponseTitle : String!
    var cannedResponseDesc: String!
   var Reaction :String!
    var orderArray : NSArray!
    var SelectgetrolebySeasonid: String!
    var SelectgetTeamId: String!
    var SelectgetLevelid: String!
    var getSportid: String!
    var getOrganizationid: String!
    var usergroupid: String!
    var playergroupid: String!
    var getUserInfo: NSDictionary!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postteam_tbl.delegate = self
        postteam_tbl.dataSource = self
        getPostimageUrl = NSMutableArray()
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: post_content_txt.frame.height - 1, width: self.view.frame.width, height: 0.5)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        post_content_txt.borderStyle = UITextBorderStyle.none
        post_content_txt.layer.addSublayer(bottomLine)
        
        
        let addHeader: [String] = ["Who would you like to share this post with?", "How would you like to tag this post?","What was your reaction?","Select a canned response"]

        
        for i in 0..<addHeader.count
        {
            if(i==0)
            {
                self.postsections.append(PostGroupSection(title:"\(addHeader[i])", userlist: teamList as NSDictionary))
            }
            else if(i==1)
            {
                self.postsections.append(PostGroupSection(title:"\(addHeader[i])", userlist: tagList as NSDictionary))

            }
            else if(i == 2)
            {
                self.postsections.append(PostGroupSection(title:"\(addHeader[i])", userlist: reactionList as NSDictionary))

            }
            else if(i==3)
            {
                self.postsections.append(PostGroupSection(title:"\(addHeader[i])", userlist: canresponseList as NSDictionary))

            }
        }
        getuserDetail()
        postteam_tbl.allowsMultipleSelection = true
        postteam_tbl.tableFooterView = UIView()
        self.postteam_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        postteam_tbl.sizeToFit()
       
    }

    
    
     // MARK: - UITableViewDataSource

        func numberOfSections(in tableView: UITableView) -> Int {
            return self.postsections.count
        }
        func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
            let items = self.postsections[section].userlist
            
            if (items.count > 0) {
                return 1
            }
            sectionCount = items.count
            return self.postsections[section].userlist.count
           
        }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostImageDetailCell  = tableView.dequeueReusableCell(withIdentifier: "postDetail", for: indexPath) as! PostImageDetailCell
        let sections = postsections[indexPath.section]
        let dic: NSDictionary = sections.userlist
      print("dfsdfgdfg\(indexPath.section)")
        cell.cancel_btn.tag = indexPath.section
        if(indexPath.section == 0)
       {
        if(dic.value(forKey: "user_id") as! String != "")
        {
            cell.detail_btn.setTitle(dic.value(forKey: "user_id") as? String, for: .normal)

        }
        else
        {
        let selectname = (dic.value(forKey: "membergroup_id") as! String != "") ? dic.value(forKey: "membergroup_id") as! String : dic.value(forKey: "team_name") as! String
        cell.detail_btn.setTitle(selectname, for: .normal)

        }
        }
        else if(indexPath.section == 1)
       {
        cell.detail_btn.setTitle(dic.value(forKey: "tag_name") as? String, for: .normal)
       // cell.cancel_btn.tag = indexPath.row

        }
        else if(indexPath.section  == 2)
       {
        //cell.detail_btn.setTitle(dic.value(forKey: "reation_title") as? String, for: .normal)
       // cell.detail_btn.setImage(UIImage(named: "\(dic.value(forKey: "reaction_image")!)"), for: .normal)
        cell.detail_btn.setImage(UIImage(named: "\(dic.value(forKey: "reaction_image")!)"), for: .normal)
        cell.detail_btn.setTitle(dic.value(forKey: "reation_title") as? String, for: .normal)
       cell.detail_btn.titleEdgeInsets = UIEdgeInsetsMake(0.0,10.0, 0.0, 0.0)
        cell.detail_btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)

        cell.detail_btn.contentHorizontalAlignment = .left

        }
        else if(indexPath.section == 3)
       {
        cell.detail_btn.setTitle(dic.value(forKey: "cannedResponseTitle") as? String, for: .normal)

        }

     cell.cancel_btn.tag = indexPath.row
        cell.commonview.layer.cornerRadius = 20
    
        cell.commonview.layer.masksToBounds = true
        cell.cancel_btn.addTarget(self, action: #selector(RemovepostItem), for: .touchUpInside)

        
       return cell
       }

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  45.0
       }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return UITableViewAutomaticDimension
        }

        func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
            return 45.0
        }
    
    
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueReusableCell(withIdentifier: "postheader") as? PostimageHeaderCell
            let sections = postsections[section].title
            header?.name_lbl.text = "\(sections)"
            header?.add_btn.layer.cornerRadius = 2
            header?.add_btn.layer.borderWidth = 1
            header?.add_btn.layer.borderColor = UIColor.white.cgColor
            header?.add_btn.tag = section
            
            header?.add_btn.addTarget(self, action: #selector(directview), for: .touchUpInside)
        let sepFrame: CGRect = CGRect(x: 0, y: (header?.frame.size.height)!-1, width: self.view.frame.size.width, height: 1);
            let seperatorView = UIView.init(frame: sepFrame)
            seperatorView.backgroundColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        header?.addSubview(seperatorView)
            return header?.contentView
        }
   
        func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            return false
        }

        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
            return .none
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            print("You tapped cell number \(indexPath.section).")

        }
    @objc func RemovepostItem(_ sender: UIButton)
    {
       let button = sender.tag
        print(sender.tag)
        let userTeam: NSDictionary = NSDictionary()

        for index in postsections.indices {
            if(index == sender.tag)
            {
                postsections[index].userlist = userTeam
                
            }// Ok
        }
        let sectionIndex = IndexSet(integer: sender.tag)
        self.postteam_tbl.reloadSections(sectionIndex, with: .none)

    }
        
    @objc func directview(_ sender: UIButton)
    {
        let button = sender.tag
        print(button)
        if(button == 0)
        {
          let objPosttag: PostUsergroupVC = (self.storyboard?.instantiateViewController(identifier: "postuser"))!
            objPosttag.delegate = self
            self.navigationController?.pushViewController(objPosttag, animated: true)
        }
        else if(button == 1)
        {
            if(SelectgetrolebySeasonid != nil)
            {
            let objPosttag: PostTagVC = (self.storyboard?.instantiateViewController(identifier: "posttag"))!
            objPosttag.TeamId = SelectgetrolebySeasonid
            objPosttag.delegate = self
                self.navigationController?.pushViewController(objPosttag, animated: true)
                
            }
            else{
                Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please select user group above team to get hash tag ")
            }
            
        }
            
        else if(button == 2)
        {
            let objReaction: ReactionVC = (self.storyboard?.instantiateViewController(identifier:"reactionvc"))!
            objReaction.delegate = self
            self.navigationController?.pushViewController(objReaction, animated: true)
            
        }
        else if(button == 3)
        {
            if(SelectgetrolebySeasonid != nil)
            {
            let objcanned: PostCannedVC = (self.storyboard?.instantiateViewController(identifier:"PostCannedVC"))!
            objcanned.TeamId = SelectgetrolebySeasonid
            objcanned.delegate = self

            self.navigationController?.pushViewController(objcanned, animated: true)
            }
            else{
                 Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please select user group above team to get canned response")
            }
        }
    }
    @IBAction func PostImage(_ sender: UIButton)
    {
        let imageviewcontroller = UIImagePickerController()
        imageviewcontroller.allowsEditing = true
        imageviewcontroller.delegate = self
        getImage(fromSourceType: .camera)
        self.present(imageviewcontroller, animated: true, completion: nil)
    }
    
    @IBAction func postVideo(_ sender: UIButton)
    {
        let imageviewcontroller = UIImagePickerController()
        imageviewcontroller.allowsEditing = true
        imageviewcontroller.delegate = self
        imageviewcontroller.mediaTypes = [kUTTypeMovie as String];
        imageviewcontroller.sourceType = .camera
        imageviewcontroller.cameraCaptureMode = .video
        self.present(imageviewcontroller, animated: true, completion: nil)
    }
    @IBAction func postVideoandImage(_ sender: UIButton)
       {
           let imageviewcontroller = UIImagePickerController()
           imageviewcontroller.allowsEditing = true
           imageviewcontroller.delegate = self
           imageviewcontroller.mediaTypes = [kUTTypeImage as String , kUTTypeMovie as String];
        imageviewcontroller.sourceType = .photoLibrary
           self.present(imageviewcontroller, animated: true, completion: nil)
       }
    func getImage(fromSourceType sourceType: UIImagePickerControllerSourceType) {

        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
     }
     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
               self.dismiss(animated: true, completion: nil)
        
             let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
            print("movie")
            let tempMedia = info[UIImagePickerControllerMediaURL] as! NSURL!
            let pathString = tempMedia?.relativePath
           let metadata = StorageMetadata()
            metadata.contentType = "mp4"
            print("videourl",tempMedia)
            let user = Auth.auth().currentUser
            if let user = user{
                let storeref = Storage.storage().reference().child("feedpostvideo/\(user.uid).mp4")
                let videoRef = storeref.putFile(from: tempMedia! as URL, metadata: metadata) { (metadata, error) in
                               guard let _ = metadata else {
                                   print("error occurred: \(error.debugDescription)")
                                   return
                               }
                    let player = AVPlayer(url: tempMedia! as URL)
                        
                        let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = self.postimage.bounds
                        player.play()
                        let visdeoview = UIView()
                                           
                    visdeoview.frame =  CGRect(x: 0, y: 0, width: self.postimage.frame.size.width, height: self.postimage.frame.size.height)
                    visdeoview.layer.addSublayer(playerLayer)
                        visdeoview.layer.display()
                    self.postimage.addSubview(visdeoview)
                              // self.postimage.image = profileImageFromPicker

                               storeref.downloadURL { (URL, error) -> Void in
                                 if (error != nil) {
                                   // Handle any errors
                                 } else {
                                   // Get the download URL for 'images/stars.jpg'

                                   let UrlString = URL!.absoluteString
                                   print(UrlString)
                                    self.getPostVideoUrl = UrlString
                                    Constant.showInActivityIndicatory()

                                 }
                               }
                           }
            }
            
        }
         else
              {
               let profileImageFromPicker = info[UIImagePickerControllerOriginalImage] as! UIImage
                
               let metadata = StorageMetadata()
               metadata.contentType = "image/jpeg"
                
               let imageData: Data = UIImageJPEGRepresentation(profileImageFromPicker, 0.5)!
           Constant.showActivityIndicatory(uiView: self.view)
               let store = Storage.storage()
               let user = Auth.auth().currentUser
               if let user = user{
                   let storeRef = store.reference().child("feedpostImages/\(user.uid).jpg")
                   let _ = storeRef.putData(imageData, metadata: metadata) { (metadata, error) in
                       guard let _ = metadata else {
                           print("error occurred: \(error.debugDescription)")
                           return
                       }
        
                       self.postimage.image = profileImageFromPicker

                       storeRef.downloadURL { (URL, error) -> Void in
                         if (error != nil) {
                           // Handle any errors
                         } else {
                           // Get the download URL for 'images/stars.jpg'

                           let UrlString = URL!.absoluteString
                           print(UrlString)
                            self.getPostimageUrl = NSMutableArray()
                            self.getPostimageUrl.add(UrlString)
                            Constant.showInActivityIndicatory()

                         }
                       }
                   }
                }
        }
               }
                
    
    func getuserDetail()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
               
               let db = Firestore.firestore()
              let docRef = db.collection("users").document("\(getuuid!)")

              docRef.getDocument { (document, error) in
                  
                  if let document = document, document.exists {
                   let doc: NSDictionary = document.data()! as NSDictionary
                    self.getUserInfo = doc
                    Constant.showInActivityIndicatory()

                   
                  } else {
                      print("Document does not exist")
                    Constant.showInActivityIndicatory()

                  }
              }
    }
    
    @IBAction func FeedPost(_ sender: UIButton)
    {
        if(SelectgetrolebySeasonid == nil)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please select user gruop")
        }
        else if(self.post_content_txt.text == "" || self.post_content_txt.text == nil)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please type post content")
        }
        else
        {
        let getUserorgInfo: NSDictionary = teamList
            Constant.internetconnection(vc: self)
                       Constant.showActivityIndicatory(uiView: self.view)
                       let testStatusUrl: String = Constant.sharedinstance.FeedPostUrl
                        var param:[String:AnyObject] = [:]
        param["feedPostedUser_id"] = self.getUserInfo.value(forKey: "user_id") as AnyObject?
        param["feedPostedUser_firstName"] = getUserInfo.value(forKey: "first_name") as AnyObject?
        param["feedPostedUser_lastName"] = getUserInfo.value(forKey: "last_name") as AnyObject?
        param["feedPostedUser_middleInitial"] = getUserInfo.value(forKey: "middle_initial") as AnyObject
        param["feedPostedUser_suffix"] = getUserInfo.value(forKey: "suffix") as AnyObject
        param["feedPostedUser_role"] = UserDefaults.standard.string(forKey: "Role") as AnyObject?
        param["feedPostedUser_avatar"] = getUserInfo.value(forKey: "profile_image") as AnyObject?
        param["feedText"] = post_content_txt.text as AnyObject
        if(getPostimageUrl.count>0)
        {
        param["feedImageURL"] = getPostimageUrl.copy() as AnyObject
        
        }
        param["feedVideoURL"] = getPostVideoUrl as AnyObject?
        param["lastSelectedFeededLevel"] = selectTeamName as AnyObject?
        param["feedPostedOrg_id"] = getUserorgInfo.value(forKey: "organization_id") as AnyObject?
        param["feedPostedOrg_name"] = getUserorgInfo.value(forKey: "organization_name") as AnyObject?
        param["feedPostedOrg_abbre"] = getUserorgInfo.value(forKey: "organization_abbrev") as AnyObject
        param["tag_id"] = selectTag as AnyObject
        param["cannedResponseTitle"] = cannedResponseTitle as AnyObject
        param["cannedResponseDesc"] = cannedResponseDesc as AnyObject
        param["reaction"] = Reaction as AnyObject?
        let feedreceip: NSArray = NSArray()
        param["feedReceipients"] = feedreceip as AnyObject
        orderArray = NSArray()
        orderArray = ["\(getOrganizationid!)", "\(getSportid!)", "\(getOrganizationid!)","\(SelectgetLevelid!)", "\(SelectgetTeamId!)"]
        param["feededLevel"] = orderArray
        let feedlevelobj : NSMutableDictionary = NSMutableDictionary()
        feedlevelobj.setValue(self.teamList.value(forKey: "level_id"), forKey: "level_id")
            feedlevelobj.setValue(self.teamList.value(forKey: "level_name"), forKey: "level_name")
            feedlevelobj.setValue(self.teamList.value(forKey: "membergroup_id"), forKey: "membergroup_id")
            feedlevelobj.setValue(self.teamList.value(forKey: "membergroup_name"), forKey: "membergroup_name")
            feedlevelobj.setValue(self.teamList.value(forKey: "organization_id"), forKey: "organization_id")
            feedlevelobj.setValue(self.teamList.value(forKey: "organization_name"), forKey: "organization_name")
            feedlevelobj.setValue(self.teamList.value(forKey: "season_id"), forKey: "season_id")
            feedlevelobj.setValue(self.teamList.value(forKey: "season_label"), forKey: "season_name")
            feedlevelobj.setValue(self.teamList.value(forKey: "sport_id"), forKey: "sport_id")
            feedlevelobj.setValue(self.teamList.value(forKey: "sport_name"), forKey: "sport_name")
            feedlevelobj.setValue(self.teamList.value(forKey: "team_id"), forKey: "team_id")
            feedlevelobj.setValue(self.teamList.value(forKey: "team_name"), forKey: "team_name")
            feedlevelobj.setValue(self.teamList.value(forKey: "user_id"), forKey: "user_id")
            feedlevelobj.setValue(self.teamList.value(forKey: "user_name"), forKey: "user_name")
        let feedlevelobjArray: NSMutableArray = NSMutableArray()
        feedlevelobjArray.add(feedlevelobj)
        param["feededLevelObject"] = feedlevelobjArray.copy() as AnyObject
        param["feedPostedOrg_id"] = getOrganizationid as AnyObject?
            AF.request(testStatusUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response:AFDataResponse<Any>) in
                           if(!(response.error != nil)){
                               switch (response.result)
                               {
                               case .success(let json):
                                let jsonData = json

                                  // if let data = response.data{
                                       let info = jsonData as? NSDictionary
                                       let statusCode = info?["status"] as? Bool
                                       if(statusCode == true)
                                       {
                                           let result = info?["message"] as! String
                                        Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: result)
                                          Constant.showInActivityIndicatory()
                                       }
                                       Constant.showInActivityIndicatory()
                                   //}
                                   break

                               case .failure(_):
                                   Constant.showInActivityIndicatory()

                                   break
                               }
                           }
                           else
                           {
                               Constant.showInActivityIndicatory()

                           }
                       }
    }
    
    }
    
    @IBAction func backpostbtn(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
