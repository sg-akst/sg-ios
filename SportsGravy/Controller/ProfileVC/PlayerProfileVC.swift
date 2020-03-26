//
//  PlayerProfileVC.swift
//  SportsGravy
//
//  Created by CSS on 24/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import Alamofire
import Kingfisher
import FirebaseStorage

struct ProfileCategory {
    let name : String
    var items : [[String:Any]]
}

class PlayerProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, addressEditDelegate,mobileEditDelegate,genderEditDelegate,UsernameEditDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var porfile_img: UIButton!
    @IBOutlet weak var profile_imag: UIImageView!
    @IBOutlet weak var profile_scroll: UIScrollView!
    @IBOutlet weak var email_lbl: UILabel!
    @IBOutlet weak var mobile_no_lbl: UILabel!
    @IBOutlet weak var dob_lbl: UILabel!
    @IBOutlet weak var gender_lbl: UILabel!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var playerprofile_tbl: UITableView!
    @IBOutlet weak var playerprofile_tbl_height: NSLayoutConstraint!
    
    var playerDetails: NSDictionary!
    var guardiansListArray: NSMutableArray!
    var organizationListArray: NSMutableArray!
    
     var sections = [ProfileCategory]()
    var player_id : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerprofile_tbl.delegate = self
        playerprofile_tbl.dataSource = self
        guardiansListArray = NSMutableArray()
        organizationListArray = NSMutableArray()
        getplayerDetail()
    }
    func getplayerDetail()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
                       
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(self.playerDetails.value(forKey: "user_id")!)")

                      docRef.getDocument { (document, error) in
                          Constant.showInActivityIndicatory()

                          if let document = document, document.exists {
                            let playerInfo = document.data()! as NSDictionary
                            print("Player=>\(playerInfo)")
                            self.username_lbl.text = "\(playerInfo.value(forKey: "first_name")!)" + " " + "\(playerInfo.value(forKey: "middle_initial")!)" + " " + "\( playerInfo.value(forKey: "last_name")!)"
                            self.player_id = playerInfo.value(forKey: "user_id") as! String
                            let timestamp: Timestamp = playerInfo.value(forKey: "created_datetime") as! Timestamp
                            let datees: Date = timestamp.dateValue()
                                                             
                                                              let dateFormatterGet = DateFormatter()
                                                              dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

                                                              let dateFormatterPrint = DateFormatter()
                                                              dateFormatterPrint.dateFormat = "MMM dd,yyyy"
                                                              

                                                              self.date_lbl.text = "Joined \(dateFormatterPrint.string(from: datees as Date))"
                                   self.profile_imag.layer.cornerRadius = self.profile_imag.frame.size.width/2
                                   self.profile_imag.layer.backgroundColor = UIColor.lightGray.cgColor
                                   let url = URL(string: "\(playerInfo.value(forKey: "profile_image")!)")
                                               if(url != nil)
                                               {
                                               
                                                   self.profile_imag.kf.setImage(with: url)
//                                                   self.profile_imag.layer.cornerRadius = self.profile_imag.frame.size.width/2
//                                                   self.profile_imag.layer.backgroundColor = UIColor.lightGray.cgColor
                                               }
                            else
                                {
                                            let name =  self.username_lbl.text
                                                           let nameFormatter = PersonNameComponentsFormatter()
                                                           if let nameComps  = nameFormatter.personNameComponents(from: name!), let firstLetter = nameComps.givenName?.first, let lastName = nameComps.givenName?.first {

                                                                let sortName = "\(firstLetter)\(lastName)"  // J. Singh
                                                               self.porfile_img.setTitle(sortName, for: .normal)
                                                            }
                                                       }
                                               self.email_lbl.text = playerInfo.value(forKey: "email_address") as? String
                                               self.gender_lbl.text = playerInfo.value(forKey: "gender") as? String
                                               self.mobile_no_lbl.text = playerInfo.value(forKey: "mobile_phone") as? String
                                               let dobstr: String = playerInfo.value(forKey: "date_of_birth") as! String
                                               let dateFormatter = DateFormatter()
                                               dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                               dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                               let date = dateFormatter.date(from: "\(dobstr)")
                                               dateFormatter.dateFormat = "MM-dd-yyyy"
                                               let dobDate = dateFormatter.string(from: date!)
                                               self.dob_lbl.text = "\(dobDate)"
                                               //let getaddress: NSDictionary = playerInfo.value(forKey: "address") as! NSDictionary
                                               self.address_lbl.text = "\(playerInfo.value(forKey: "street1")!)" + ", " + "\(playerInfo.value(forKey: "street2")!)" + "\n" + "\(playerInfo.value(forKey: "city")!)" + "-" + "\(playerInfo.value(forKey: "postal_code")!)" + "\n" + "\(playerInfo.value(forKey: "state_name")!)" + "," + "\(playerInfo.value(forKey: "country_name")!)"
                            self.getGuardians()
                        }
                        else {
                            print("Document does not exist")
                        }
        }
    }
        func getGuardians()
        {
                Constant.internetconnection(vc: self)
                Constant.showActivityIndicatory(uiView: self.view)
                let testStatusUrl: String = Constant.sharedinstance.getGuardiansbyuid
            let header: HTTPHeaders = [
                    "idtoken": UserDefaults.standard.string(forKey: "idtoken")!]
                 var param:[String:AnyObject] = [:]
                param["uid"] = UserDefaults.standard.string(forKey: "UUID") as AnyObject?
                
                AF.request(testStatusUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON{ (response) in
                    Constant.showInActivityIndicatory()

                    if(!(response.error != nil)){
                        switch (response.result)
                        {
                        case .success( let json):
                            let jsonData = json
                                                   print(jsonData)
                           // if let data = response.data{
                                let info = jsonData as? NSDictionary
                                let statusCode = info?["status"] as? Bool
                                //let message = info?["message"] as? String

                                if(statusCode == true)
                                {
                                    let result = info?["data"] as! NSArray
                                   
                                    self.guardiansListArray = NSMutableArray()
                                    self.guardiansListArray = result.mutableCopy() as? NSMutableArray
                                    self.GetOrganization()

                                }
                                else
                                {
                                   // Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: message ?? response.result.error as! String)
                                }
                                
                           // }
                            break

                        case .failure(_):
                           // Constant.showInActivityIndicatory()

                            break
                        }
                    }
                    else
                    {
                        //Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: "\(Constant.sharedinstance.errormsgDetail)")
                       // Constant.showInActivityIndicatory()

                    }
                }
            
            }
        
        func GetOrganization()
        {
            Constant.internetconnection(vc: self)
            Constant.showActivityIndicatory(uiView: self.view)
            let testStatusUrl: String = Constant.sharedinstance.getOrganizationbyuid
            let header: HTTPHeaders = [
                "idtoken": UserDefaults.standard.string(forKey: "idtoken")!]
             var param:[String:AnyObject] = [:]
            param["uid"] = UserDefaults.standard.string(forKey: "UUID") as AnyObject?
            
            AF.request(testStatusUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON{ (response:AFDataResponse<Any>) in
                Constant.showInActivityIndicatory()

                if(!(response.error != nil)){
                    switch (response.result)
                    {
                    case .success(let json):
                        let jsonData = json

                        //if let data = response.data{
                            let info = jsonData as? NSDictionary
                            let statusCode = info?["status"] as? Bool
                            //let message = info?["message"] as? String

                            if(statusCode == true)
                            {
                                let result = info?["data"] as! NSArray
                                
                                self.organizationListArray = NSMutableArray()
                                 self.organizationListArray = result.mutableCopy() as? NSMutableArray
//                                 if(self.playerListArray.count > 0 && self.playerListArray.count != 0)
//                                 {
//                                   self.sections.append(Category(name:"Players", items:self.playerListArray as! [[String : Any]]))
//                                 }
                                  if(self.guardiansListArray.count > 0 && self.guardiansListArray.count != 0)
                                 {
                                     self.sections.append(ProfileCategory(name:"Other Guardians", items:self.guardiansListArray as! [[String : Any]]))
                                 }
                                  if(self.organizationListArray.count > 0 && self.organizationListArray.count != 0)
                                 {
                                  self.sections.append(ProfileCategory(name:"Organizations", items:self.organizationListArray as! [[String : Any]]))
                                 }
                                 let height: Int =  self.guardiansListArray.count + self.organizationListArray.count + self.sections.count
                                 self.playerprofile_tbl_height.constant = (height>2) ? CGFloat(height * 60) :CGFloat(height * 60)
                                 self.playerprofile_tbl.reloadData()

                                 self.profile_scroll.contentSize = CGSize(width: self.view.frame.size.width, height: self.playerprofile_tbl.frame.origin.y + self.playerprofile_tbl_height.constant)
                        //        Constant.showInActivityIndicatory()
                                
                                
                                
                                
//                                self.organizationListArray = NSMutableArray()
//                                self.organizationListArray = result.mutableCopy() as? NSMutableArray
//                                self.sections = [ProfileCategory(name:"Guardians", items:self.guardiansListArray as! [[String : Any]]), ProfileCategory(name:"Organizations", items:self.organizationListArray as! [[String : Any]])
//                                ]
//                                let height: Int = self.guardiansListArray.count + self.organizationListArray.count
//                                self.playerprofile_tbl_height.constant = CGFloat(height * 75)
//                                self.playerprofile_tbl.reloadData()
//
//                                self.profile_scroll.contentSize = CGSize(width: self.view.frame.size.width, height: self.playerprofile_tbl.frame.origin.y + self.playerprofile_tbl_height.constant)
//                               Constant.showInActivityIndicatory()

                            }
                            else
                            {
                               // Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: message ?? response.result.error as! String)
                            }
                           // Constant.showInActivityIndicatory()
                        //}
                        break

                    case .failure(_):
                      //  Constant.showInActivityIndicatory()

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
        
        func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
                  guard let tableView = view as? UITableViewHeaderFooterView else { return }
                  // tableView.backgroundView?.backgroundColor = UIColor.black
                 tableView.backgroundColor = UIColor.white

                  tableView.textLabel?.textColor = UIColor.black
              }
       
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return self.sections.count
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           
            return self.sections[section].name
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80.0
        }
         func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
             return UITableViewAutomaticDimension
         }

         func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
             return 44.0
         }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
                let items = self.sections[section].items
                return items.count
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: Playercell = tableView.dequeueReusableCell(withIdentifier: "playerprofile", for: indexPath) as! Playercell
            //  var dict = itemsA[indexPath.section]
            
            
                let items = self.sections[indexPath.section].items
                let item = items[indexPath.row]
            
           
            cell.selectionStyle = .none
            if(indexPath.section == 0)
            {
                cell.username_lbl?.text = "\(item["first_name"] as! String)" + " " + "\(item["middle_initial"] as! String)" + " " + "\(item["last_name"] as! String)"
                cell.gender_lbl.text = "Guardian" //item["gender"] as? String
            }
            else
            {
                let dic: NSArray = item["sports"] as! NSArray
                let sportsname: NSDictionary = dic[0] as! NSDictionary
                cell.username_lbl.text = item["abbrev"] as? String
                cell.gender_lbl.text = "\(item["name"]!)" + "\n" + "\(sportsname.value(forKey: "name") as! String)"
                cell.accessoryType = .disclosureIndicator
            }
            
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let items = self.sections[indexPath.section].items
            let item = items[indexPath.row]
            if(indexPath.section == 1)
            {
                let vc = storyboard?.instantiateViewController(withIdentifier: "Organizationprofile") as! OrganizationVC
                vc.organizationDetails = item as NSDictionary
                //vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
    
    func addressupdateSuccess() {
           getplayerDetail()

       }
       
       func genderupdateSuccess() {
           getplayerDetail()

       }
       
       func mobileupdateSuccess() {
          getplayerDetail()

       }
       
       func usernameupdateSuccess() {
           getplayerDetail()
       }
       
    func RemovePlayerconnection()
    {
            Constant.internetconnection(vc: self)
            Constant.showActivityIndicatory(uiView: self.view)
            let testStatusUrl: String = Constant.sharedinstance.signupString
             var param:[String:AnyObject] = [:]
       // param["uid"] = "zHhMZCuvhtrd87Q0vN65" as AnyObject
         param["uid"] = UserDefaults.standard.string(forKey: "UUID") as AnyObject?
        param["player_id"] = player_id as AnyObject?
            AF.request(testStatusUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response:AFDataResponse<Any>) in
                Constant.showInActivityIndicatory()

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
                                let result = info?["data"] as! NSDictionary
                                
                               //Constant.showInActivityIndicatory()

                            }
                           // Constant.showInActivityIndicatory()
                       // }
                        break

                    case .failure(_):
                      //  Constant.showInActivityIndicatory()

                        break
                    }
                }
                else
                {
                   // Constant.showInActivityIndicatory()

                }
            }
        
        }
    
    @IBAction func removeconnection(_ sender: UIButton)
    {
        RemovePlayerconnection()
    }
    
    @IBAction func usernameEdit(_ sender: UIButton)
       {
           let vc = storyboard?.instantiateViewController(withIdentifier: "updatename") as! UsernameEditVC
           vc.userDetailDic = playerDetails
          vc.delegate = self
        vc.isUpdateName = false

          self.navigationController?.pushViewController(vc, animated: true)
       }
    @IBAction func mobileEdit(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UpdateMobile") as! MobileEditVC
        vc.getAllDic = playerDetails
        vc.delegate = self
        vc.isUpdatePage = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func genderEdit(_ sender: UIButton)
    {
       let vc = storyboard?.instantiateViewController(withIdentifier: "updateGender") as! GenderEditVC
        vc.getalldoc = playerDetails
        vc.delegate = self
        vc.isUpdateGender = false

       self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func addressEdit(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Update_address") as! AddressEditVC
        vc.addressDetailDic = self.playerDetails
        vc.delegate = self
        vc.isUpdate = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func cancelbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func updateprofileImage(_ sender: UIButton)
       {
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
        
               let profileImageFromPicker = info[UIImagePickerControllerOriginalImage] as! UIImage
                
               let metadata = StorageMetadata()
               metadata.contentType = "image/jpeg"
                
               let imageData: Data = UIImageJPEGRepresentation(profileImageFromPicker, 0.5)!
                
               let store = Storage.storage()
               let user = Auth.auth().currentUser
               if let user = user{
                   let storeRef = store.reference().child("profileavatar/\(user.uid).jpg")
                   let _ = storeRef.putData(imageData, metadata: metadata) { (metadata, error) in
                       guard let _ = metadata else {
                           print("error occurred: \(error.debugDescription)")
                           return
                       }
        
                       self.profile_imag.image = profileImageFromPicker
                   }
                    
               }
                
           }
}
