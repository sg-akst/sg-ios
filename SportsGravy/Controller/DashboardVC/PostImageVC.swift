import UIKit
import MobileCoreServices
import AVFoundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import Alamofire
import Photos
//import BSImagePicker
import AlamofireImage
import Kingfisher
//import Lightbox
import ImagePicker
import SwiftyJSON
import AVKit
import AVFoundation
import PINRemoteImage
import UserNotifications
import SWRevealViewController

protocol backgroundpostDelegate: AnyObject {
    
    func backgroundpostloading()
    func backgroundloadingstop()
    func backgroundofflineloadingstop()
   

}

struct PostGroupSection {
    let title: String
    var userlist: NSDictionary
}

class PostImageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectuserGroubDelegate, SelectPostTagDelegate, SelectpostCanDelegate,SelectReactionDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImagePickerDelegate, UITextViewDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
         self.getPostimageUrl = NSMutableArray()
        self.Select_post_image = images
        isImage = true
      for i in 0..<images.count
        {
            self.getPostimageUrl.add(images[i])
        }
        self.close_Btn.isHidden = false
        if(getPostimageUrl.count > 1)
        {
            self.post_collection_view.reloadData()

           //self.post_view.isHidden = false
            post_collection_view_height.constant = CGFloat(self.getPostimageUrl.count * 100)
            self.post_collection_view.isHidden = false
            let scrollheight = self.postTbl_height.constant + description_view_height.constant + post_collection_view_height.constant
            self.scroll_view.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: scrollheight)
            //self.scrollview_contentheight.constant = scrollheight
        }
        else
        {
            //self.post_view.isHidden = false
            self.postimage.isHidden = false
            self.videoview.isHidden = true
            self.post_collection_view.isHidden = true
            self.postimage.image = getPostimageUrl[0] as? UIImage
        }
        self.video_btn.isUserInteractionEnabled = false
        self.camera_btn.isUserInteractionEnabled = false
        self.gallery_btn.isUserInteractionEnabled = false
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
            imagePicker.dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
            imagePicker.dismiss(animated: true, completion: nil)
    }
    func selectReactionDetail(userDetail: NSDictionary) {
        let userTeam: NSDictionary = userDetail
        Reaction = userTeam.value(forKey: "reation_title") as? String
        sectionCount = 3

        for index in self.postsections.indices {
             if(index == 2)
             {
               postsections[index].userlist = userTeam
                 
             }
            if(postsections[index].userlist.count>0)
            {
                sectionCount = sectionCount + 1
            }
         }
         let sectionIndex = IndexSet(integer: 2)
         self.postteam_tbl.reloadSections(sectionIndex, with: .none)
        self.postTbl_height.constant = CGFloat(sectionCount * 45)
    }
    func selectPostCanDetail(userDetail: NSDictionary) {
        let userTeam: NSDictionary = userDetail
         cannedResponseTitle = userTeam.value(forKey: "cannedResponseTitle") as? String
        cannedResponseDesc = userTeam.value(forKey: "cannedResponseDesc") as? String
        if(self.post_content_txt.text == nil || self.post_content_txt.text == "")
        {
          self.post_content_txt.text = cannedResponseDesc
          content_count_lbl.text = "\(post_content_txt.text?.count ?? 0)/250"
        }

        sectionCount = 3

         for index in postsections.indices {
             if(index == 3)
             {
               postsections[index].userlist = userTeam
                 
             }
            if(postsections[index].userlist.count>0)
            {
                sectionCount = sectionCount + 1
            }
         }
         let sectionIndex = IndexSet(integer: 3)
         self.postteam_tbl.reloadSections(sectionIndex, with: .none)
        self.postTbl_height.constant = CGFloat(sectionCount * 45)

    }
    
    func selectPostTagDetail(userDetail: NSDictionary) {
        let userTeam: NSDictionary = userDetail
        selectTag = (userTeam.value(forKey: "tag_id") as! String)  
        selectTagname = (userTeam.value(forKey: "tag_name")  as! String)  
        sectionCount = 3

         for index in postsections.indices {
             if(index == 1)
             {
               postsections[index].userlist = userTeam
             }
            if(postsections[index].userlist.count>0)
            {
                sectionCount = sectionCount + 1
            }
         }
         let sectionIndex = IndexSet(integer: 1)

         self.postteam_tbl.reloadSections(sectionIndex, with: .none)
        
        self.postTbl_height.constant = CGFloat(sectionCount * 45)

    }
    
    let imageviewcontroller = UIImagePickerController()
    
    func selectuserGroubDetail(userDetail: NSMutableArray) {
        
        DoneBtn.isUserInteractionEnabled = true
        DoneBtn.setTitleColor(UIColor.blue, for: .normal)

        
        let userTeam: NSDictionary = userDetail[0] as! NSDictionary
        teamList = userTeam
        
        SelectgetrolebySeasonid = userTeam.value(forKey: "role_by_season_id") as? String
        getSportid = userTeam.value(forKey: "sport_id") as? String
        getOrganizationid = userTeam.value(forKey: "organization_id") as? String
        SelectgetLevelid = userTeam.value(forKey: "level_id") as? String
        SelectgetTeamId = userTeam.value(forKey: "team_id") as? String
        
        selectTeamName = userTeam.value(forKey: "team_name") as? String
         usergroupid = userTeam.value(forKey: "membergroup_id") as? String
        let usergroupname = userTeam.value(forKey: "membergroup_name") as? String
        playergroupid = userTeam.value(forKey: "user_id") as? String
        sectionCount = 3
        for index in postsections.indices {
            
            if(index == 0)
            {
              postsections[index].userlist = userTeam
                
            }
            if(postsections[index].userlist.count>0)
            {
                sectionCount = sectionCount + 1
            }
            
        }
        let sectionIndex = IndexSet(integer: 0)
        self.postteam_tbl.reloadSections(sectionIndex, with: .none)
        postTbl_height.constant = CGFloat(sectionCount * 45)

        
    }
    

    @IBOutlet weak var postteam_tbl: UITableView!
    @IBOutlet weak var post_content_txt: UITextView!
    @IBOutlet weak var postimage: UIImageView!
    
   // @IBOutlet weak var postvideo: UIImageView!
    @IBOutlet weak var postTbl_height: NSLayoutConstraint!
    @IBOutlet weak var post_collection_view: UICollectionView!
    @IBOutlet weak var post_collection_view_height: NSLayoutConstraint!

    @IBOutlet weak var description_view_height: NSLayoutConstraint!
    @IBOutlet weak var scrollview_contentheight: NSLayoutConstraint!

    @IBOutlet weak var post_view: UIView!
    @IBOutlet weak var close_Btn: UIButton!
    @IBOutlet weak var video_btn: UIButton!
    @IBOutlet weak var camera_btn: UIButton!
    @IBOutlet weak var gallery_btn: UIButton!
    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var content_count_lbl: UILabel!
    @IBOutlet weak var DoneBtn: UIButton!
    @IBOutlet weak var videoview : UIView!
     weak var delegate:backgroundpostDelegate?
    var postsections = [PostGroupSection]()
    var sectionCount: Int!

    var teamList: NSDictionary = [:]
    var tagList = [String: String]()
    var reactionList = [String: String]()
    var canresponseList = [String: String]()
    var getUserdetails: NSDictionary!
    var getPostimageUrl: NSMutableArray!
    var getMutiImageUrl: NSMutableArray!
    var getPostVideoUrl: String!
    var selectTeamName: String!
    var selectTag: String!
    var selectTagname: String!

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
    
    var Select_post_image: [Image]!
    var tempMedia: URL?
    var videoPath: String!
    var isImage: Bool!
    var peopleselector: Bool!
    var userDetailPeopleselector: NSMutableArray!
   
    var db:DBHelper = DBHelper()
    var reachability: Reachability!
    var persons:[FeedPostData] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        reachability = Reachability.networkReachabilityForInternetConnection()!

        //let netStatus = reachability.currentReachabilityStatus
        
        peopleselector = false
        postteam_tbl.delegate = self
        postteam_tbl.dataSource = self
        post_collection_view.delegate = self
        post_collection_view.dataSource = self
        post_content_txt.delegate = self
        getPostimageUrl = NSMutableArray()
        content_count_lbl.text = "\(post_content_txt.text?.count ?? 0)/250"
        
        close_Btn.backgroundColor = .black
        close_Btn.layer.cornerRadius = close_Btn.frame.size.width/2
        close_Btn.layer.borderWidth = 1
        close_Btn.layer.borderColor = UIColor.white.cgColor
        close_Btn.isHidden = true
        DoneBtn.isUserInteractionEnabled = true

        //scroll_view.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
        isImage = false
        
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
        
        NotificationCenter.default.addObserver(self,selector: #selector(PostImageVC.localDatauploadfirebase),name: NSNotification.Name(rawValue: "LocalDatabase"),object: nil)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        if(UserDefaults.standard.bool(forKey: "peopleselector") == true)
       {
        UserDefaults.standard.set(false, forKey: "peopleselector")
         self.selectuserGroubDetail(userDetail: userDetailPeopleselector)
         
       }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "")
            {
                DoneBtn.isUserInteractionEnabled = false
                DoneBtn.setTitleColor(UIColor.darkGray, for: .normal)
        }
        else
            {
                DoneBtn.isUserInteractionEnabled = true
                DoneBtn.setTitleColor(UIColor.blue, for: .normal)
        }
              if let _ = textView.text{
                  //let text = textView.text! as NSString
                let fullText = "\(textView.text!)" + "\(text)" //text.replacingCharacters(in: range, with: text as String)
                 let  wordCount = fullText.count
                  print(wordCount)
               content_count_lbl.text =  "\(wordCount)/250" // Set value of the label
                
                if(wordCount > 249)
                {
                    textView.resignFirstResponder()
                }
              }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        description_view_height.constant = newSize.height
       // textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
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
            //sectionCount = items.count
            return self.postsections[section].userlist.count
           
        }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostImageDetailCell  = tableView.dequeueReusableCell(withIdentifier: "postDetail", for: indexPath) as! PostImageDetailCell
        let sections = postsections[indexPath.section]
        let dic: NSDictionary = sections.userlist
     // print("dfsdfgdfg\(indexPath.section)")
        cell.cancel_btn.tag = indexPath.section
        if(indexPath.section == 0)
       {
        
        if(dic.value(forKey: "user_id") as! String != "")
        {
            let font = UIFont(name: "Arial", size: 16)
            let fontAttributes = [NSAttributedStringKey.font: font]
            let myText = dic.value(forKey: "user_id") as? String
            let size = myText?.size(withAttributes: fontAttributes as [NSAttributedStringKey : Any])
            cell.select_text_width.constant = size!.width + 5
            cell.common_view_width.constant = cell.select_text_width.constant + 35
            cell.detail_btn.setTitle(dic.value(forKey: "user_id") as? String, for: .normal)
            cell.detail_btn.setImage(UIImage(named: ""), for: .normal)

        }
        else
        {
        let selectname = (dic.value(forKey: "membergroup_name") as! String != "") ? dic.value(forKey: "membergroup_name") as! String : dic.value(forKey: "team_name") as! String
            let font = UIFont(name: "Arial", size: 16)
            let fontAttributes = [NSAttributedStringKey.font: font]
            let size = selectname.size(withAttributes: fontAttributes as [NSAttributedStringKey : Any])
            print("select:\(selectname) \(size.width)")
            cell.select_text_width.constant = size.width + 5
            cell.common_view_width.constant = cell.select_text_width.constant + 35
           cell.detail_btn.setTitle(selectname, for: .normal)
            cell.detail_btn.setImage(UIImage(named: ""), for: .normal)


        }
        }
        else if(indexPath.section == 1)
       {
        let tagname = dic.value(forKey: "tag_name") as! String
       let font = UIFont(name: "Arial", size: 16)
       let fontAttributes = [NSAttributedStringKey.font: font]
        let size = tagname.size(withAttributes: fontAttributes as [NSAttributedStringKey : Any])
        cell.select_text_width.constant = size.width + 5
        cell.common_view_width.constant = cell.select_text_width.constant + 35
        cell.detail_btn.setTitle(tagname, for: .normal)
        cell.detail_btn.setImage(UIImage(named: ""), for: .normal)

        }
        else if(indexPath.section  == 2)
       {
        let reaction = dic.value(forKey: "reation_title") as! String
        let font = UIFont(name: "Arial", size: 16)
        let fontAttributes = [NSAttributedStringKey.font: font]
         let size = reaction.size(withAttributes: fontAttributes as [NSAttributedStringKey : Any])
         cell.select_text_width.constant = size.width + 35
         cell.common_view_width.constant = cell.select_text_width.constant + 35
        
        cell.detail_btn.setImage(UIImage(named: "\(dic.value(forKey: "reaction_image")!)"), for: .normal)
        cell.detail_btn.setTitle(reaction, for: .normal)
       cell.detail_btn.titleEdgeInsets = UIEdgeInsetsMake(0.0,10.0, 0.0, 0.0)
        cell.detail_btn.imageEdgeInsets = UIEdgeInsetsMake(5.0, 0.0, 5.0, 10.0)
        cell.detail_btn.contentHorizontalAlignment = .left
        }
        else if(indexPath.section == 3)
       {
        let cantitle = dic.value(forKey: "cannedResponseTitle") as! String
        let font = UIFont(name: "Arial", size: 16)
        let fontAttributes = [NSAttributedStringKey.font: font]
         let size = cantitle.size(withAttributes: fontAttributes as [NSAttributedStringKey : Any])
        cell.select_text_width.constant = (size.width < 20) ? size.width+20: size.width + 5
        cell.common_view_width.constant = cell.select_text_width.constant + 35
        cell.detail_btn.setTitle(cantitle, for: .normal)
        cell.detail_btn.setImage(UIImage(named: ""), for: .normal)

        }
        cell.cancel_btn.tag = indexPath.section
        cell.commonview.layer.cornerRadius = 15
        cell.commonview.layer.masksToBounds = true
        cell.detail_btn.titleLabel?.textAlignment = .left
        cell.cancel_btn.addTarget(self, action: #selector(RemovepostItem), for: .touchUpInside)
       return cell
       }

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  40.0
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
        header?.seprated_lbl.isHidden = (postsections[section].userlist.count > 0) ? true : false
            return header?.contentView
        }
   
        func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            return false
        }

        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
            return .none
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            //print("You tapped cell number \(indexPath.section).")

        }
    @objc func RemovepostItem(_ sender: UIButton)
    {
       let button = sender.tag
       // print(button)
        let userTeam: NSDictionary = NSDictionary()

        for index in postsections.indices {
            if(index == sender.tag)
            {
                postsections[index].userlist = userTeam
                
            }// Ok
        }
        let sectionIndex = IndexSet(integer: sender.tag)
        self.postteam_tbl.reloadSections(sectionIndex, with: .none)
        postTbl_height.constant = postTbl_height.constant - 45


    }
        
    @objc func directview(_ sender: UIButton)
    {
        let button = sender.tag
        //print(button)
        if(button == 0)
        {
            if(selectTeamName != nil && selectTeamName != "")
            {
                RemovepostItem(sender)
            }
            if #available(iOS 13.0, *) {
                let objPosttag: PostUsergroupVC = (self.storyboard?.instantiateViewController(identifier: "postuser"))!
                objPosttag.delegate = self
                self.navigationController?.pushViewController(objPosttag, animated: true)
            } else {
                let objPosttag: PostUsergroupVC = (self.storyboard?.instantiateViewController(withIdentifier: "postuser"))! as! PostUsergroupVC
                objPosttag.delegate = self
                self.navigationController?.pushViewController(objPosttag, animated: true)
            }
           
        }
        else if(button == 1)
        {
            if(selectTag != nil && selectTag != "")
            {
                RemovepostItem(sender)
            }
            if(SelectgetrolebySeasonid != nil)
            {
                if #available(iOS 13.0, *) {
                    let objPosttag: PostTagVC = (self.storyboard?.instantiateViewController(identifier: "posttag"))!
                    objPosttag.TeamId = SelectgetTeamId
                        objPosttag.rolebySeasonId = SelectgetrolebySeasonid
                    objPosttag.delegate = self
                        self.navigationController?.pushViewController(objPosttag, animated: true)
                        
                } else {
                    let objPosttag: PostTagVC = (self.storyboard?.instantiateViewController(withIdentifier: "posttag"))! as! PostTagVC
                    objPosttag.TeamId = SelectgetTeamId
                        objPosttag.rolebySeasonId = SelectgetrolebySeasonid
                    objPosttag.delegate = self
                        self.navigationController?.pushViewController(objPosttag, animated: true)
                }
            
            }
            else{
                Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Select User Group Above Team To Get Hash Tag ")
            }
            
        }
            
        else if(button == 2)
        {
            if(Reaction != nil && Reaction != "")
            {
                RemovepostItem(sender)
            }
            if #available(iOS 13.0, *) {
                let objReaction: ReactionVC = (self.storyboard?.instantiateViewController(identifier:"reactionvc"))!
                objReaction.delegate = self
                self.navigationController?.pushViewController(objReaction, animated: true)
                
            } else {
                let objReaction: ReactionVC = (self.storyboard?.instantiateViewController(withIdentifier:"reactionvc"))! as! ReactionVC
                objReaction.delegate = self
                self.navigationController?.pushViewController(objReaction, animated: true)
            }
            
        }
        else if(button == 3)
        {
            if(cannedResponseTitle != nil && cannedResponseTitle != "")
            {
                RemovepostItem(sender)
            }
            
            if(SelectgetrolebySeasonid != nil)
            {
                if #available(iOS 13.0, *) {
                    let objcanned: PostCannedVC = (self.storyboard?.instantiateViewController(identifier:"PostCannedVC"))!
                    objcanned.TeamId = SelectgetTeamId
                    objcanned.rolebyseasonid = SelectgetrolebySeasonid
                    objcanned.delegate = self

                    self.navigationController?.pushViewController(objcanned, animated: true)
                } else {
                    let objcanned: PostCannedVC = (self.storyboard?.instantiateViewController(withIdentifier:"PostCannedVC"))! as! PostCannedVC
                    objcanned.TeamId = SelectgetTeamId
                    objcanned.rolebyseasonid = SelectgetrolebySeasonid
                    objcanned.delegate = self

                    self.navigationController?.pushViewController(objcanned, animated: true)
                }
            
            }
            else{
                 Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Select User Group Above Team To Get Canned Response")
            }
        }
    }
    @IBAction func PostImage(_ sender: UIButton)
    {
        let config = Configuration()
        config.doneButtonTitle = "Cancel"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        config.allowVideoSelection = true
        let imagePicker = ImagePickerController(configuration: config)
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
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
    imageviewcontroller.allowsEditing = false
    imageviewcontroller.delegate = self
    imageviewcontroller.mediaTypes = [kUTTypeMovie as String];
    imageviewcontroller.sourceType = .photoLibrary

    self.present(imageviewcontroller, animated: true, completion: nil)

}
    func getImage(fromSourceType sourceType: UIImagePickerControllerSourceType) {

        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.cameraCaptureMode = .photo
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
     }
     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
               self.dismiss(animated: true, completion: nil)
        DoneBtn.setTitleColor(UIColor.blue, for: .normal)
       
       let mediaType = info[UIImagePickerControllerMediaType] as! NSString

        if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
            //print("movie")
            if picker.sourceType == UIImagePickerControllerSourceType.photoLibrary {
                tempMedia = info[UIImagePickerControllerMediaURL]  as? URL
                self.videoPath = tempMedia?.absoluteString
                       
                   } else {
                tempMedia = info[UIImagePickerControllerMediaURL] as! NSURL as URL?
                self.videoPath = tempMedia?.absoluteString
                   }
            tempMedia = info[UIImagePickerControllerMediaURL] as? URL

            
           let videoplayview = AGVideoPlayerView()
            videoplayview.frame =  CGRect(x: 0, y: 0, width: self.videoview.frame.size.width, height: self.videoview.frame.size.height)
                videoview.addSubview(videoplayview)

                               videoplayview.videoUrl = tempMedia as URL?
                               videoplayview.previewImageUrl = nil
                               videoplayview.shouldAutoplay = false
                               videoplayview.shouldAutoRepeat = false
                               videoplayview.showsCustomControls = false
                               videoplayview.shouldSwitchToFullscreen = true
            
            
            self.close_Btn.isHidden = false
            self.postimage.isHidden = true
            self.videoview.isHidden = false
            self.post_collection_view.isHidden = true
            self.video_btn.isUserInteractionEnabled = false
            self.camera_btn.isUserInteractionEnabled = false
            self.gallery_btn.isUserInteractionEnabled = false
            isImage = false
            
        }
         else
              {
               let profileImageFromPicker = info[UIImagePickerControllerOriginalImage] as! UIImage
                self.postimage.image = profileImageFromPicker
                isImage = true

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
                Constant.showInActivityIndicatory()

                  
                  if let document = document, document.exists {
                   let doc: NSDictionary = document.data()! as NSDictionary
                    self.getUserInfo = doc
                  //  Constant.showInActivityIndicatory()

                   
                  } else {
                      print("Document does not exist")
                    //Constant.showInActivityIndicatory()

                  }
              }
    }
    
    @IBAction func FeedPost(_ sender: UIButton)
    {
        if(SelectgetrolebySeasonid == nil)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Select User Gruop")
        }
        else if(self.post_content_txt.text == "" || self.post_content_txt.text == nil)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Type Post Content")
        }
        else
        {
            self.delegate?.backgroundpostloading()

            post_content_txt.resignFirstResponder()
            //let reachability: Reachability = Reachability.networkReachabilityForInternetConnection()!

            let netStatus = reachability.currentReachabilityStatus

            if (UserDefaults.standard.bool(forKey: "feedpost") == true && netStatus != .reachableViaWiFi)
            {
            UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                                              switch notificationSettings.authorizationStatus {
                                              case .notDetermined:
                                                  self.requestAuthorization(completionHandler: { (success) in
                                                      guard success else { return }

                                                      // Schedule Local Notification
                                                      self.scheduleLocalNotification(msg: "Feed Posting, Please wait")
                                                   
                                                  })
                                              case .authorized:
                                                  // Schedule Local Notification
                                                  self.scheduleLocalNotification(msg: "Feed Posting, Please wait")
                                            
                                              case .denied:
                                                  print("Application Not Allowed to Display Notifications")
                                              case .provisional:
                                                  break
                                              }
                                          }
            }
            
            if(getPostimageUrl.count > 0)
            {
            uploadImageOrvideo()
            }
           else if(tempMedia != nil)
            {
                uploadImageOrvideo()

            }
            else
            {
                self.feedPostMethod()

            }
        
        
    }
    }
    @objc func localDatauploadfirebase()
    {
 
        let group = DispatchGroup() // create a group.

        persons = db.read()
        if(persons.count > 0){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backgroundpostloading"), object: nil)
            self.getPostimageUrl = NSMutableArray()
            print(persons.count)
            for i in 0..<persons.count
            {
                group.enter()
                
                let idno = persons[i].id
                var offlineparam:[String:AnyObject] = [:]
                offlineparam["feedPostedUser_id"] = "\(persons[i].feedPostedUser_id)" as AnyObject
                offlineparam["feedPostedUser_firstName"] = persons[i].feedPostedUser_firstName as AnyObject
                offlineparam["feedPostedUser_lastName"] = persons[i].feedPostedUser_lastName as AnyObject
                offlineparam["feedPostedUser_middleInitial"] = persons[i].feedPostedUser_middleInitial as AnyObject
                offlineparam["feedPostedUser_suffix"] = persons[i].feedPostedUser_suffix as AnyObject
                offlineparam["feedPostedUser_role"] =  persons[i].feedPostedUser_role as AnyObject
                offlineparam["feedPostedUser_avatar"] = persons[i].feedPostedUser_avatar as AnyObject
                offlineparam["feedText"] = persons[i].feedText as AnyObject
            
              
                let imag = persons[i].feedImageURL
                if(imag != "(\n)")
                {
                    
                self.getPostimageUrl.add(imag!)
                   let jsonData = imag?.data(using: .utf8)
                    var abc = NSArray()

                        do {
                            if let jsonData = jsonData {
                            abc = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! NSArray
                                                 }
                                } catch {
                                             }
                if(abc.count>0)
                {
                offlineparam["feedImageURL"] = abc as AnyObject
                }
                }
                let videourl = persons[i].feedVideoURL as AnyObject?
                if(videourl as! String != "")
                {
                offlineparam["feedVideoURL"] = persons[i].feedVideoURL as AnyObject?
                }
                offlineparam["lastSelectedFeededLevel"] = persons[i].lastSelectedFeededLevel as AnyObject?
                offlineparam["feedPostedOrg_id"] = persons[i].feedPostedOrg_id as AnyObject?
                offlineparam["feedPostedOrg_name"] = persons[i].feedPostedOrg_name as AnyObject?
                offlineparam["feedPostedOrg_abbre"] = persons[i].feedPostedOrg_abbre as AnyObject
                offlineparam["tag_id"] = persons[i].tag_id as AnyObject
                offlineparam["tag_name"] = persons[i].tag_name as AnyObject
                offlineparam["cannedResponseTitle"] = persons[i].cannedResponseTitle as AnyObject
                offlineparam["cannedResponseDesc"] = persons[i].cannedResponseDesc as AnyObject
                offlineparam["reaction"] = persons[i].reaction as AnyObject?
                let feedreceip: NSArray = NSArray()
                offlineparam["feedReceipients"] = feedreceip as AnyObject
                orderArray = NSArray()
                orderArray = ["\(persons[i].organization_id)", "\(persons[i].sport_id)", "\(persons[i].season_id)","\(persons[i].level_id)", "\(persons[i].team_id)"]
                offlineparam["feededLevel"] = orderArray
                let feedlevelobj : NSMutableDictionary = NSMutableDictionary()
                feedlevelobj.setValue(persons[i].level_id, forKey: "level_id")
                feedlevelobj.setValue(persons[i].level_name, forKey: "level_name")
                feedlevelobj.setValue(persons[i].membergroup_id, forKey: "membergroup_id")
                feedlevelobj.setValue(persons[i].membergroup_name, forKey: "membergroup_name")
                feedlevelobj.setValue(persons[i].organization_id, forKey: "organization_id")
                feedlevelobj.setValue(persons[i].organization_name, forKey: "organization_name")
                feedlevelobj.setValue(persons[i].season_id, forKey: "season_id")
                feedlevelobj.setValue(persons[i].season_label, forKey: "season_name")
                feedlevelobj.setValue(persons[i].sport_id, forKey: "sport_id")
                feedlevelobj.setValue(persons[i].sport_name, forKey: "sport_name")
                feedlevelobj.setValue(persons[i].team_id, forKey: "team_id")
                feedlevelobj.setValue(persons[i].team_name, forKey: "team_name")
                feedlevelobj.setValue(persons[i].user_id, forKey: "user_id")
                feedlevelobj.setValue(persons[i].user_name, forKey: "user_name")
                let feedlevelobjArray: NSMutableArray = NSMutableArray()
                feedlevelobjArray.add(feedlevelobj)
                offlineparam["feededLevelObject"] = feedlevelobjArray.copy() as AnyObject
                offlineparam["feedPostedOrg_id"] = persons[i].organization_id as AnyObject?

                Constant.internetconnection(vc: self)
                      Constant.showActivityIndicatory(uiView: self.view)
                      let testStatusUrl: String = Constant.sharedinstance.FeedPostUrl
                      let header: HTTPHeaders = [
                                     "idtoken": UserDefaults.standard.string(forKey: "idtoken") ?? ""]
                          AF.request(testStatusUrl, method: .post, parameters: offlineparam, encoding: JSONEncoding.default, headers: header).responseJSON{ (response:AFDataResponse<Any>) in
                              Constant.showInActivityIndicatory()

                                         if(!(response.error != nil)){
                                             switch (response.result)
                                             {

                                             case .success(let json):
                                              let jsonData = json
                                             // self.delegate?.backgroundloadingstop()
                                              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backgroundloadingstop"), object: nil)

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
                                            group.leave()
                                           

                                         }

                                         else
                                         {
                                             Constant.showInActivityIndicatory()

                                         }
                                     }
                
                self.db.deleteByID(id: idno)
                //self.persons = self.db.read()
            }
        }
    }
    
    func feedPostMethod()
    {

    let netStatus = reachability.currentReachabilityStatus


        if (UserDefaults.standard.bool(forKey: "feedpost") == true && netStatus != .reachableViaWiFi)
        {

            
            //tag_name is insert 
            let paramsJSON = JSON(getPostimageUrl)
            let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
           let getUserorgInfo: NSDictionary = teamList
            DispatchQueue.main.async {
                self.db.insert(Id: 0, postuser_id: "\(self.getUserInfo.value(forKey: "user_id") as? String ?? "")", postuser_firstName: "\(self.getUserInfo.value(forKey: "first_name") as? String ?? "")", postuser_lastName: "\(self.getUserInfo.value(forKey: "last_name") as? String ?? "")", postuser_middleInitial: "\(self.getUserInfo.value(forKey: "middle_initial") as? String ?? "")", postuser_suffix: "\(self.getUserInfo.value(forKey: "suffix") as? String ?? "")", postuser_role: "\(UserDefaults.standard.string(forKey: "Role") ?? "")", postuser_avatar: "\(self.getUserInfo.value(forKey: "profile_image") as? String ?? "" )", postuser_feedText: "\(self.post_content_txt.text! )", postuser_feedImageURL: "\(paramsString)", postuser_feedVideoURL: "\(self.getPostVideoUrl as? String ?? "")", postuser_Level: "\(self.selectTeamName as? String ?? "")", postuserOrg_id : "\(getUserorgInfo.value(forKey: "organization_id") as? String ?? "")", postuser_Org_name: "\(getUserorgInfo.value(forKey: "organization_name") as? String ?? "")", postuser_Org_abbre: "\(getUserorgInfo.value(forKey: "organization_abbrev") as? String ?? "")", postuser_tag_id: "\(self.selectTag as? String ?? "")", postuser_tag_name: "\(self.selectTagname as? String ?? "")",postuser_Title: "\(self.cannedResponseTitle as? String ?? "")", cannedResponseDesc: "\(self.cannedResponseDesc as? String ?? "")", reaction: "\(self.Reaction as? String ?? "")", feedOrg_id: "\(self.getOrganizationid as? String ?? "")", level_id: "\(self.teamList.value(forKey: "level_id")!)", level_name: "\(self.teamList.value(forKey: "level_name")!)", membergroup_id: "\(self.teamList.value(forKey: "membergroup_id")!)", membergroup_name: "\(self.teamList.value(forKey: "membergroup_name")!)", organization_id: "\(self.teamList.value(forKey: "organization_id")!)", organization_name: "\(self.teamList.value(forKey: "organization_name")!)", season_id: "\(self.teamList.value(forKey: "season_id")!)", season_name: "\(self.teamList.value(forKey: "season_label")!)", sport_id: "\(self.teamList.value(forKey: "sport_id")!)", sport_name: "\(self.teamList.value(forKey: "sport_name")!)", team_id: "\(self.teamList.value(forKey: "team_id")!)", team_name: "\(self.teamList.value(forKey: "team_name")!)", user_id: "\(self.teamList.value(forKey: "user_id")!)", user_name: "\(self.teamList.value(forKey: "user_name")!)")
            }
            UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                                              switch notificationSettings.authorizationStatus {
                                              case .notDetermined:
                                                  self.requestAuthorization(completionHandler: { (success) in
                                                      guard success else { return }

                                                      // Schedule Local Notification
                                                      self.scheduleLocalNotification(msg: "Feed Post Completed")
                                                  })
                                              case .authorized:
                                                  // Schedule Local Notification
                                                  self.scheduleLocalNotification(msg: "Feed Post Completed")
                                               // self.delegate?.backgroundloadingstop()
                                              
//                                               let timer = Timer.scheduledTimer(timeInterval: 0.5,
//                                                target: self,
//                                                selector: #selector(eventWith),
//                                                userInfo: nil,
//                                                repeats: false)
                                              case .denied:
                                                  print("Application Not Allowed to Display Notifications")
                                              case .provisional:
                                                  break
                                              }
                                        }
            self.navigationController?.popViewController(animated: false)
           
            let myTimer : Timer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(myPerformeCode), userInfo: nil, repeats: false)

//            let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { timer in
//                    print("FIRE!!!")
//                self.delegate?.backgroundofflineloadingstop()
//
//            })
        }
         else
            {
                self.delegate?.backgroundpostloading()

            self.navigationController?.popViewController(animated: false)
        let getUserorgInfo: NSDictionary = teamList
        Constant.internetconnection(vc: self)
        //Constant.showActivityIndicatory(uiView: self.view)
        let testStatusUrl: String = Constant.sharedinstance.FeedPostUrl
        let header: HTTPHeaders = [
                       "idtoken": UserDefaults.standard.string(forKey: "idtoken") ?? ""]
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
        param["tag_name"] = selectTagname as AnyObject
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
        
        AF.request(testStatusUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON{ (response:AFDataResponse<Any>) in
                Constant.showInActivityIndicatory()

                           if(!(response.error != nil)){
                               switch (response.result)
                               {
                               case .success(let json):
                                let jsonData = json
//                                UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
//                                switch notificationSettings.authorizationStatus {
//                                case .notDetermined:
//                                self.requestAuthorization(completionHandler: { (success) in
//                                guard success else { return }
//
//                                                                          // Schedule Local Notification
//                            self.scheduleLocalNotification(msg: "Feed Post Completed")
//                                                                      })
//                            case .authorized:
//                                                                      // Schedule Local Notification
//                            self.scheduleLocalNotification(msg: "Feed Post Completed")
//                                        case .denied:
//                                                                      print("Application Not Allowed to Display Notifications")
//                                                                  case .provisional:
//                                                                      break
//                                                                  }
//                                                              }
                                
                                self.delegate?.backgroundloadingstop()
                                  // if let data = response.data{
                                       let info = jsonData as? NSDictionary
                                       let statusCode = info?["status"] as? Bool
                                       if(statusCode == true)
                                       {
                                           let result = info?["message"] as! String
                                        Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: result)
                                          Constant.showInActivityIndicatory()
                                       // self.navigationController?.popViewController(animated: false)

                                       }
                                       Constant.showInActivityIndicatory()
                                //self.navigationController?.popViewController(animated: false)
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
    @objc func myPerformeCode(timer : Timer) {

       self.delegate?.backgroundofflineloadingstop()
    }
    @IBAction func backpostbtn(_ sender: UIButton)
    {
        if(teamList.count > 0)
        {
            let alert = UIAlertController(title: "SportsGravy", message: "Are You Sure Want To Discard".capitalized, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { _ in
               }))
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { _ in
            if #available(iOS 13.0, *) {
                let swrvc: SWRevealViewController = (self.storyboard?.instantiateViewController(identifier: "revealvc"))!
                self.navigationController?.pushViewController(swrvc, animated: true)

            } else {
                let swrvc: SWRevealViewController = (self.storyboard?.instantiateViewController(withIdentifier: "revealvc"))! as! SWRevealViewController
                self.navigationController?.pushViewController(swrvc, animated: true)
            }
                }))
        self.present(alert, animated: true, completion: nil)
    }
        else
        {
           self.navigationController?.popViewController(animated: true)

        }
    }
    // Collectionview
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getPostimageUrl.count
    }

    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // get a reference to our storyboard cell
        let cell: MutiplephotoCell = self.post_collection_view.dequeueReusableCell(withReuseIdentifier: "Muti", for: indexPath as IndexPath) as! MutiplephotoCell
        cell.collectionImage.image = getPostimageUrl[indexPath.row] as? UIImage
        return cell
    }

    // MARK: - UICollectionViewDelegate protocol

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            let vc: ImageviewVC = (self.storyboard?.instantiateViewController(identifier: "PageImage"))!
            vc.ImageCount = getPostimageUrl
                  self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc: ImageviewVC = (self.storyboard?.instantiateViewController(withIdentifier: "PageImage"))! as! ImageviewVC
            vc.ImageCount = getPostimageUrl
                  self.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
           let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (self.post_collection_view.frame.size.width - space) / 2.05
           return CGSize(width: size, height: size)
       }
    
    @IBAction func didClickCloseBtn(_ sender: UIButton)
    {
        video_btn.isUserInteractionEnabled = true
        camera_btn.isUserInteractionEnabled = true
        gallery_btn.isUserInteractionEnabled = true
        close_Btn.isHidden = true
        if(self.getPostimageUrl.count>1)
        {
        self.getPostimageUrl = NSMutableArray()
            self.post_collection_view.reloadData()
        }
        else
        {
            if(isImage)
            {
            postimage.isHidden = true
            postimage.image = UIImage(named: "")
            }
            else
            {
                videoview.isHidden = true
            }
        }
    }
    
    func uploadImageOrvideo() {

        if self.isImage! {
            Constant.showActivityIndicatory(uiView: self.view)
            getPostimageUrl = NSMutableArray()
            for i in 0..<self.Select_post_image.count{
                        let profileImageFromPicker = self.Select_post_image[i]
                        let metadata = StorageMetadata()
                            metadata.contentType = "image/jpeg"
                            let imageData: Data = UIImageJPEGRepresentation(profileImageFromPicker, 0.5)!
                        let fileName = NSUUID().uuidString
            
                            let store = Storage.storage()
                            let user = Auth.auth().currentUser
                            if let user = user{
                                let storeRef = store.reference().child("feedpostimages/\(user.uid).jpg").child(fileName)
                                storeRef.putData(imageData, metadata: metadata) { (metadata, error) in
                                   
            
                                           guard let _ = metadata else {
                                               print("error occurred: \(error.debugDescription)")
                                             Constant.showInActivityIndicatory()
                                               return
                                           }
                                           storeRef.downloadURL { (URL, error) -> Void in
                                             if (error != nil) {
                                               // Handle any errors
                                                 Constant.showInActivityIndicatory()
                                             } else {
                                               let UrlString = URL!.absoluteString
                                               print(UrlString)
                                                self.getPostimageUrl.add(UrlString)
                                                 Constant.showInActivityIndicatory()
                                                if(self.getPostimageUrl.count == self.Select_post_image.count)
                                                {
                                                    self.feedPostMethod()

                                                }
            
                                             }
            
                                           }
            
                                       }
            
                                    }
                    }

        } else {
           Constant.showActivityIndicatory(uiView: self.view)
            let metadata = StorageMetadata()
            metadata.contentType = "mp4"
             let dynamicuuid = UUID().uuidString
            print("uuidstr:\(dynamicuuid)")
            let fileUrl = NSURL(string: videoPath)
            let storageReference = Storage.storage().reference().child("feedpostvideo/\(dynamicuuid).mp4")
                                        do {
                                            let data = try Data(contentsOf: fileUrl! as URL, options: .mappedIfSafe)
                                            print(data)
                                             storageReference.putData(data, metadata: nil) { (metadata, error) in
                                            if error == nil {
                                            print("Successful video upload")
                    storageReference.downloadURL { (URL, error) -> Void in
                    if (error != nil) {
                                    print("success")
                        } else {
                                                                                            
            let UrlString: String = URL!.absoluteString
            print(UrlString)
            self.getPostVideoUrl = UrlString
            self.feedPostMethod()
            Constant.showInActivityIndicatory()
                                                            }
                                        }
                                                
                                            } else {
                                            print(error?.localizedDescription)
                                            }
                                        }
                           
                                        } catch  {
                            }
            
        }

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
    private func scheduleLocalNotification(msg: String) {
            // Create Notification Content
            let notificationContent = UNMutableNotificationContent()

            // Configure Notification Content
            notificationContent.title = "SportsGravy Feed"
            notificationContent.subtitle = ""
            notificationContent.body = msg

            // Add Trigger
            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)

            // Create Notification Request
            let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)

            // Add Request to User Notification Center
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
        
    }
}
