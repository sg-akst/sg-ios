//
//  AccountProfileVC.swift
//  SportsGravy
//
//  Created by CSS on 21/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import Kingfisher
import FirebaseStorage
import Alamofire
import SwiftyJSON

struct Category {
    let name : String
    var items : [[String:Any]]
}

class AccountProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UsernameEditDelegate,mobileEditDelegate,genderEditDelegate,addressEditDelegate, UITableViewDelegate, UITableViewDataSource {
   
    func addressupdateSuccess() {
        isdelegate = true
        getInformation()

    }
    
    func genderupdateSuccess() {
        isdelegate = true

        getInformation()

    }
    
    func mobileupdateSuccess() {
        isdelegate = true

       getInformation()

    }
    
    func usernameupdateSuccess() {
        isdelegate = true

        getInformation()
    }
    
    
    @IBOutlet weak var role_lbl: UILabel!
    @IBOutlet weak var email_lbl: UILabel!
    @IBOutlet weak var password_lbl: UILabel!
    @IBOutlet weak var mobile_no_lbl: UILabel!
    @IBOutlet weak var dob_lbl: UILabel!
    @IBOutlet weak var gender_lbl: UILabel!
    @IBOutlet weak var address_lbl: UILabel!
    //@IBOutlet weak var organization_abbv_lbl: UILabel!
   // @IBOutlet weak var organization_lbl: UILabel!

    @IBOutlet weak var username_lbl: UILabel!
//    @IBOutlet weak var usernameEdit_btn: UIButton!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var porfile_img: UIButton!
    @IBOutlet weak var profile_imag: UIImageView!
    @IBOutlet weak var profile_scroll: UIScrollView!
    var getAllrole: NSMutableArray!
    var alldoc: NSDictionary!
    var playerListArray: NSMutableArray!
    var guardiansListArray: NSMutableArray!
    var organizationListArray: NSMutableArray!
    var isdelegate: Bool!

    @IBOutlet weak var player_tbl: UITableView!
    @IBOutlet weak var player_tbl_height: NSLayoutConstraint!

    var sections = [Category]()


    override func viewDidLoad() {
        super.viewDidLoad()
       var filteredEvents: [String] = self.getAllrole.value(forKeyPath: "@distinctUnionOfObjects.role") as! [String]
       filteredEvents.sort(){$0 < $1}
      
        var filtered = String ()

        for i in 0..<filteredEvents.count
        {
            let dic = filteredEvents[i]
            if(i == filteredEvents.count-1)
            {
                filtered.append(dic)
            }
            else
            {
                filtered.append(dic + ", ")
            }
        }
       player_tbl.delegate = self
       player_tbl.dataSource = self

        role_lbl.text = filtered.capitalized
        playerListArray = NSMutableArray()
        guardiansListArray = NSMutableArray()
        organizationListArray = NSMutableArray()
        self.player_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        isdelegate = false
        getInformation()
      
       
    }
    
    func getInformation()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
                       
                       let db = Firestore.firestore()
                      let docRef = db.collection("users").document("\(getuuid!)")

                      docRef.getDocument { (document, error) in
                          
                        Constant.showInActivityIndicatory()

                          if let document = document, document.exists {
                            self.alldoc = document.data()! as NSDictionary
                            self.username_lbl.text = "\(self.alldoc.value(forKey: "first_name")!)" + " " + "\(self.alldoc.value(forKey: "middle_initial")!)" + " " + "\(self.alldoc.value(forKey: "last_name")!)"
                            
                            let timestamp: Timestamp = self.alldoc.value(forKey: "created_datetime") as! Timestamp
                            let datees: Date = timestamp.dateValue()
                          
                            let dateFormatterGet = DateFormatter()
                            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

                            let dateFormatterPrint = DateFormatter()
                            dateFormatterPrint.dateFormat = "MMM dd,yyyy"
                            print(dateFormatterPrint.string(from: datees as Date))

                            self.date_lbl.text = "Joined \(dateFormatterPrint.string(from: datees as Date))"
                            let url = URL(string: "\(self.alldoc.value(forKey: "profile_image")!)")
                           
                            if(url != nil)
                            {
                                //self.profile_imag.isHidden = false
                                self.porfile_img.backgroundColor = UIColor.clear
                                self.profile_imag.layer.cornerRadius = self.profile_imag.frame.size.width/2
                                self.profile_imag.layer.masksToBounds = true
                                self.profile_imag.kf.setImage(with: url)
                            }
                            else
                            {
                                let name =  self.username_lbl.text
                                let nameFormatter = PersonNameComponentsFormatter()
                                if let nameComps  = nameFormatter.personNameComponents(from: name!), let firstLetter = nameComps.givenName?.first, let lastName = nameComps.familyName?.first {

                                     let sortName = "\(firstLetter)\(lastName)"
                                   // self.profile_imag.isHidden = true
                                   // self.porfile_img.isHidden = false
                                   self.porfile_img.layer.cornerRadius = self.porfile_img.frame.size.width/2
                                   self.porfile_img.layer.backgroundColor = UIColor.lightGray.cgColor
                                   self.porfile_img.contentMode = .scaleAspectFill
                                    self.porfile_img.setTitle(sortName, for: .normal)
                                 }
                            }

                            
                            self.email_lbl.text = self.alldoc.value(forKey: "email_address") as? String
                            self.gender_lbl.text = self.alldoc.value(forKey: "gender") as? String
                            self.mobile_no_lbl.text = self.alldoc.value(forKey: "mobile_phone") as? String
                            let dobstr: String = self.alldoc.value(forKey: "date_of_birth") as! String
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            let date = dateFormatter.date(from: "\(dobstr)")
                            dateFormatter.dateFormat = "MM-dd-yyyy"
                            if(date != nil)
                            {
                            let dobDate = dateFormatter.string(from: date!)
                            self.dob_lbl.text = "\(dobDate)"
                            }
                           // let getaddress: NSDictionary = self.alldoc.value(forKey: "address") as! NSDictionary
                            self.address_lbl.text = "\(self.alldoc.value(forKey: "street1") ?? "")" + ", " + "\(self.alldoc.value(forKey: "street2") ?? "")" + "\n" + "\(self.alldoc.value(forKey: "city") ?? "")" + "-" + "\(self.alldoc.value(forKey: "postal_code") ?? "")" + "\n" + "\(self.alldoc.value(forKey: "state") ?? self.alldoc.value(forKey: "state_name")!)" + "," + "\(self.alldoc.value(forKey: "country_code") ?? "")"
                
                           Constant.showInActivityIndicatory()
                            if(self.isdelegate == false)
                            {
                                self.GetOrganization()
                            }

                          } else {
                              print("Document does not exist")
                          }
                      }
    }
    @IBAction func updateprofileImage(_ sender: UIButton)
    {
        //Crashlytics.sharedInstance().crash()
        showAlert()
    }
    
    func showAlert() {

        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

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
            let profileImageFromPicker = info[UIImagePickerControllerOriginalImage] as! UIImage
             
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
//        let url = URL
//
//         if(url != nil)
        // {
             //self.profile_imag.isHidden = false
             self.porfile_img.backgroundColor = UIColor.clear
             self.profile_imag.layer.cornerRadius = self.profile_imag.frame.size.width/2
             self.profile_imag.layer.masksToBounds = true
             self.profile_imag.image = profileImageFromPicker
         //}
             
            let imageData: Data = UIImageJPEGRepresentation(profileImageFromPicker, 0.5)!
        Constant.showActivityIndicatory(uiView: self.view)
            let store = Storage.storage()
            let user = Auth.auth().currentUser
            if let user = user{
                let storeRef = store.reference().child("profileavatar/\(user.uid).jpg")
                let _ = storeRef.putData(imageData, metadata: metadata) { (metadata, error) in
                    guard let _ = metadata else {
                        print("error occurred: \(error.debugDescription)")
                        Constant.showInActivityIndicatory()

                        return
                    }
     
                    self.porfile_img.setImage(UIImage(named: "\(profileImageFromPicker)"), for: .normal)
                    storeRef.downloadURL { (URL, error) -> Void in
                      if (error != nil) {
                        // Handle any errors
                        Constant.showInActivityIndicatory()

                      } else {
                        // Get the download URL for 'images/stars.jpg'

                        let UrlString = URL!.absoluteString
                        print(UrlString)
                        
                        let getuuid = UserDefaults.standard.string(forKey: "UUID")
                        let db = Firestore.firestore()
                            
                        db.collection("users").document("\(getuuid!)").updateData(["profile_image": "\(UrlString)"])
                              { err in
                                  if let err = err {
                                      print("Error updating document: \(err)")
                                      Constant.showInActivityIndicatory()

                                  } else {
                                    
                                      print("Document successfully updated")
                                    
                                      Constant.showInActivityIndicatory()
                                   // self.getInformation()

                                  }
                              }
                      }
                    }
                }
                 
            }
             
        }
    
    func GetOrganization()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let testStatusUrl: String = Constant.sharedinstance.getOrganizationbyuid
        let header: HTTPHeaders = [
            "idtoken": UserDefaults.standard.string(forKey: "idtoken")!, "UID" : UserDefaults.standard.string(forKey: "UUID")!]
//         var param:[String:AnyObject] = [:]
//        param["uid"] = UserDefaults.standard.string(forKey: "UUID") as AnyObject?
//
        AF.request(testStatusUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON{ (response) in
            Constant.showInActivityIndicatory()

            if(!(response.error != nil)){
                switch (response.result)
                {
                case .success(let json):
                   // if let data = response.data{
                    let jsonData = json
                        print(jsonData)
                        let info = jsonData as? NSDictionary
                        let statusCode = info?["status"] as? Bool
                        let message = info?["Message"] as? String

                        if(statusCode == true)
                        {
                            let result = info?["data"] as? NSDictionary
                           // let getPlayer: NSDictionary = result[0] as! NSDictionary
                            self.playerListArray = NSMutableArray()
                            let getPlayer = result?["childrendata"] as? NSArray
                            self.playerListArray = getPlayer?.mutableCopy() as? NSMutableArray
                            self.guardiansListArray = NSMutableArray()
                            let getGuardian = result?["guardianlist"] as? NSArray
                            self.guardiansListArray = getGuardian?.mutableCopy() as? NSMutableArray
                            let organisation = result?["orgdata"] as? NSArray
                            self.organizationListArray = NSMutableArray()
//                            let org = organisation?[0] as? NSDictionary
//                            let getorg = org!["governing_body_info"] as? NSArray
                            self.organizationListArray = organisation?.mutableCopy() as? NSMutableArray
                            
                            if(self.playerListArray.count > 0 && self.playerListArray.count != 0)
                            {
                              self.sections.append(Category(name:"Players", items:self.playerListArray as! [[String : Any]]))
                            }
                             if(self.guardiansListArray.count > 0 && self.guardiansListArray.count != 0)
                            {
                                self.sections.append(Category(name:"Other Guardians", items:self.guardiansListArray as! [[String : Any]]))
                            }
                             if(self.organizationListArray.count > 0 && self.organizationListArray.count != 0)
                            {
                             self.sections.append(Category(name:"Organizations", items:self.organizationListArray as! [[String : Any]]))
                            }
                            let height: Int = self.playerListArray.count + self.guardiansListArray.count + self.organizationListArray.count + self.sections.count
                            self.player_tbl_height.constant = (height>2) ? CGFloat(height * 70) :CGFloat(height * 70)
                            self.player_tbl.reloadData()

                            self.profile_scroll.contentSize = CGSize(width: self.view.frame.size.width, height:  self.player_tbl_height.constant)
                           Constant.showInActivityIndicatory()

                        }
                        else
                        {
                            if(message == "unauthorized user")
                            {
                                if #available(iOS 13.0, *) {
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.timerAction()
                                    self.GetOrganization()
                                } else {
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.timerAction()
                                    self.GetOrganization()
                                }
                                
                            }
                            else
                            {
                                Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "\(message!)")
                            }
                           
                        }
                        
                       // Constant.showInActivityIndicatory()
                   // }
                    break

                case .failure(_):
                    Constant.showInActivityIndicatory()

                    break
                }
            }
            else
            {
                self.player_tbl_height.constant = 0
                Constant.showInActivityIndicatory()

            }
        }
    
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
              guard let tableView = view as? UITableViewHeaderFooterView else { return }
        tableView.backgroundColor = UIColor.lightGray
        //tableView.textLabel?.textColor = UIColor.black
        view.tintColor = Constant.getUIColor(hex: "#EEEEEE")
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 8, width:
        tableView.bounds.size.width-5, height: 30))
        headerLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
        headerLabel.textColor = Constant.getUIColor(hex: "#333333")
        headerLabel.text = self.sections[section].name
        headerLabel.sizeToFit()
        
        view.addSubview(headerLabel)
        if(self.guardiansListArray.count > 0 && section == 1 && self.guardiansListArray.count != 0)
       {
        let invite: UIButton = UIButton.init(frame: CGRect(x: tableView.bounds.size.width - 150, y: 10, width: 130, height: 30))
        invite.setTitle("Invite Guardian", for: .normal)
        invite.setTitleColor(UIColor.blue, for: .normal)
        invite.addTarget(self, action: #selector(inviteGuardian), for: .touchUpInside)
        view.addSubview(invite)
        }
         
        
        let sepFrame: CGRect = CGRect(x: 0, y: view.frame.size.height-1, width: self.view.frame.size.width, height: 1);
        let seperatorView = UIView.init(frame: sepFrame)
        seperatorView.backgroundColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
            view.addSubview(seperatorView)

          }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return self.sections[section].name
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
     }
    

     func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
         return 45.0
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            let items = self.sections[section].items
            return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Playercell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! Playercell
            let items = self.sections[indexPath.section].items
            let item = items[indexPath.row]
        cell.selectionStyle = .none
        cell.invite_btn.tag = indexPath.section
        cell.invite_btn.addTarget(self, action: #selector(reinvite), for: .touchUpInside)
        if(self.playerListArray.count>0 || self.guardiansListArray.count>0)
        {
            if(indexPath.section == 0  || indexPath.section == 1)
        {
           
            if(indexPath.section == 0)
            {
             cell.username_lbl?.text = "\(item["first_name"] as! String)" + " " + "\(item["middle_initial"] as! String)" + " " + "\(item["last_name"] as! String)"
            cell.gender_lbl.text =  item["gender"] as? String
               
            }
            else
            {
                cell.username_lbl?.text = (item["first_name"] as! String == "" && item["last_name"] as! String == "") ? "\(item["email_address"] as! String)" : "\(item["first_name"] as! String)" + " " + "\(item["middle_initial"] as! String)" + " " + "\(item["last_name"] as! String)" //item["email_address"] as? String
                let playDIC : NSDictionary  =  self.playerListArray?[0] as! NSDictionary
                //print(playerguardian)
                let playerGuardianArray: NSArray = playDIC.value(forKey: "parent_user_id") as! NSArray
                let contained = playerGuardianArray.contains("\(item["user_id"]!)")
                cell.gender_lbl.text = (contained) ? "Guardian of \(playDIC["first_name"] as! String)" + " " + "\(playDIC["middle_initial"] as! String)" + " " + "\(playDIC["last_name"] as! String)" : "\(item["first_name"] as! String)" + " " + "\(item["middle_initial"] as! String)" + " " + "\(item["last_name"] as! String)"
                
            }
            
        
        if(item["is_signup_completed"] as! Bool == true)
        {
            cell.active_user_imag.image = UIImage(named: "activeuser")
            cell.active_user_imag.tintColor = UIColor.green
            cell.invite_btn.tintColor = UIColor.blue
            cell.invite_btn.isUserInteractionEnabled = true
            cell.accessoryType = .disclosureIndicator
           
        }
        else if(item["is_signup_completed"] as! Bool == false && item["is_invited"] as! Bool == true && item["email_address"] as? String != nil)
        {
            cell.invite_btn.setTitle("Re-invite", for: .normal)
            cell.invite_btn.tintColor = UIColor.blue
            cell.invite_btn.isUserInteractionEnabled = true

            cell.active_user_imag.image = UIImage(named: "inactiveUser")
            cell.active_user_imag.tintColor = UIColor.gray
        }
        else if(item["is_signup_completed"] as! Bool == false && item["is_invited"] as! Bool == false && item["email_address"] as? String != nil)
        {
            //Pending
            cell.invite_btn.setTitle("Re-invite", for: .normal)
            cell.invite_btn.tintColor = UIColor.gray
            cell.invite_btn.isUserInteractionEnabled = false

            cell.active_user_imag.image = UIImage(named: "inactiveUser")
            cell.active_user_imag.tintColor = UIColor.gray
        }
        else if(item["is_signup_completed"] as! Bool == false && item["is_invited"] as! Bool == false && item["email_address"] as? String == nil)
        {
            cell.invite_btn.setTitle("Invite", for: .normal)
            cell.active_user_imag.image = UIImage(named: "inactiveUser")
            cell.active_user_imag.tintColor = UIColor.gray
        }
        }
            else
        {
           
            let dic: NSArray = item["governing_body_info"] as! NSArray
            if(dic.count > 0)
            {
            let sportsname: NSDictionary = dic[0] as! NSDictionary
            let national: NSDictionary = dic[1] as! NSDictionary
            cell.username_lbl.text = item["abbrev"] as? String
            cell.gender_lbl.text = "\(item["name"]!)" + "\n" + "\(sportsname.value(forKey: "sport_name") as! String)" + "," + "\(national.value(forKey: "sport_name") as! String)"
//            if(indexPath.sections == 2)
//            {
//                cell.accessoryType = .none
//            }
//            else
//            {
            cell.accessoryType = .disclosureIndicator
           // }
            }
            }
        }
       else
        {
            let dic: NSArray = (item["governing_body_info"] as? NSArray ?? nil)!
            if(dic.count > 0)
            {
                let sportsname: NSDictionary = dic[0] as! NSDictionary
                if(dic.count > 1)
            {
                let national: NSDictionary = dic[1] as! NSDictionary
                cell.gender_lbl.text = "\(item["name"]!)" + "\n" + "\(sportsname.value(forKey: "sport_name")!)" + "," + "\(national.value(forKey: "sport_name") as! String)"
            }
            cell.username_lbl.text = item["abbrev"] as? String ?? ""
            cell.gender_lbl.text = "\(item["name"] ?? "")" + "\n" + "\(sportsname.value(forKey: "sport_name") ?? "")"
            cell.accessoryType = .disclosureIndicator


        }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

      
        let items = self.sections[indexPath.section].items
        let item = items[indexPath.row]
        if(self.playerListArray.count>0 || self.guardiansListArray.count>0)
        {
        if(indexPath.section == 0)
        {
           if(item["is_signup_completed"] as! Bool == true)
          {
            let vc = storyboard?.instantiateViewController(withIdentifier: "playerProfile") as! PlayerProfileVC
            vc.playerDetails = item as NSDictionary
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(indexPath.section == 1)
        {
//            let vc = storyboard?.instantiateViewController(withIdentifier: "updatename") as! PlayerProfileVC
//            vc.userDetailDic = alldoc
//            vc.delegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(indexPath.section == 2)
            {
                let vc = storyboard?.instantiateViewController(withIdentifier: "Organizationprofile") as! OrganizationVC
                vc.organizationDetails = organizationListArray
                //vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Organizationprofile") as! OrganizationVC
            //let dic = item["governing_body_info"] as? NSArray
            //let sportsname: NSDictionary = dic?[0] as! NSDictionary
            //let organization = item
            vc.organizationDetails = organizationListArray
            //vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    @objc func reinvite(_ sender: UIButton)
    {
        print("tag:\(sender.tag)")
        
        let button = sender
        let cell = button.superview?.superview as? Playercell
        let indexPaths = player_tbl.indexPath(for: cell!)
        let dicvalu = sections[indexPaths!.section]
        print(dicvalu)
        let getvalue: NSDictionary!
        if(dicvalu.name == "Players")
        {
          getvalue = dicvalu.items[sender.tag] as NSDictionary
        }
        else
        {
            getvalue = dicvalu.items[sender.tag - playerListArray.count] as NSDictionary
        }
        let invite: Bool = getvalue.value(forKey: "is_invited")! as! Bool
        let signup: Bool = getvalue.value(forKey: "is_signup_completed")! as! Bool
        if(invite == true && signup == false)
        {
         Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
//                 let getuuid = UserDefaults.standard.string(forKey: "UUID")
                  let db = Firestore.firestore()
            db.collection("users").document(getvalue["user_id"] as! String).updateData(["is_invited": false])
            { err in
                Constant.showInActivityIndicatory()

                if let err = err {
                    print("Error updating document: \(err)")
                    Constant.showInActivityIndicatory()

                } else {
                    print("Document successfully updated")
                    Constant.showInActivityIndicatory()
                    Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Re-Invite Successfully")
                }
            }
        }
        
    }
    
    @objc func inviteGuardian(_ sender: UIButton)
    {
       // let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        if #available(iOS 13.0, *) {
            let vc: InviteGuardianVC = (self.storyboard?.instantiateViewController(identifier: "guardian"))!
            
            vc.player_list_Array = self.playerListArray
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "guardian") as? InviteGuardianVC
            vc?.player_list_Array = self.playerListArray
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
    @IBAction func usernameEdit(_ sender: UIButton)
    {
        //Crashlytics.sharedInstance().crash()
        let vc = storyboard?.instantiateViewController(withIdentifier: "updatename") as! UsernameEditVC
        vc.userDetailDic = alldoc
        vc.delegate = self
        vc.isUpdateName = true
       self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func passwordEdit(_ sender: UIButton)
    {
       // Crashlytics.sharedInstance().crash()
        let vc = storyboard?.instantiateViewController(withIdentifier: "updatePW") as! PasswordEditVC
        vc.getAllDic = alldoc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func mobileEdit(_ sender: UIButton)
    {
        //Crashlytics.sharedInstance().crash()
        let vc = storyboard?.instantiateViewController(withIdentifier: "UpdateMobile") as! MobileEditVC
        vc.getAllDic = alldoc
        vc.delegate = self
        vc.isUpdatePage = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func genderEdit(_ sender: UIButton)
    {
        //Crashlytics.sharedInstance().crash()
       let vc = storyboard?.instantiateViewController(withIdentifier: "updateGender") as! GenderEditVC
        vc.getalldoc = alldoc
        vc.delegate = self
        vc.isUpdateGender = true

       self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func addressEdit(_ sender: UIButton)
    {
        //Crashlytics.sharedInstance().crash()
        let vc = storyboard?.instantiateViewController(withIdentifier: "Update_address") as! AddressEditVC
        vc.addressDetailDic = alldoc
        vc.delegate = self
        vc.isUpdate = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func organisationEdit(_ sender: UIButton)
    {
        //Crashlytics.sharedInstance().crash()
       let vc = storyboard?.instantiateViewController(withIdentifier: "Organizationprofile") as! OrganizationVC
       self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func logout_btnaction(_ sender: UIButton)
       {
       // Crashlytics.sharedInstance().crash()
            try! Auth.auth().signOut()
           if let storyboard = self.storyboard {
               
               let vc = storyboard.instantiateViewController(withIdentifier: "Signin_page") as! SigninVC
               self.navigationController?.pushViewController(vc, animated: true)
               UserDefaults.standard.removeObject(forKey: "UUID")
               UserDefaults.standard.removeObject(forKey: "idtoken")
           }
       }
       
    @IBAction func cancelbtn(_ sender: UIButton)
    {
        //Crashlytics.sharedInstance().crash()
       self.navigationController?.popViewController(animated: true)
    }

}
