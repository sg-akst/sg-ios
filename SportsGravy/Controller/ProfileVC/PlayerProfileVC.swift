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
    
    var isPlayerDelegate: Bool!
    var playerInfo: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerprofile_tbl.delegate = self
        playerprofile_tbl.dataSource = self
        guardiansListArray = NSMutableArray()
        organizationListArray = NSMutableArray()
        isPlayerDelegate = false
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
                            self.playerInfo = document.data()! as NSDictionary
                            print("Player=>\(self.playerInfo)")
                            self.username_lbl.text = "\(self.playerInfo.value(forKey: "first_name")!)" + " " + "\(self.playerInfo.value(forKey: "middle_initial")!)" + " " + "\( self.playerInfo.value(forKey: "last_name")!)"
                            self.player_id = self.playerInfo.value(forKey: "user_id") as? String
                            let timestamp: Timestamp = self.playerInfo.value(forKey: "created_datetime") as! Timestamp
                            let datees: Date = timestamp.dateValue()
                                                             
                                                              let dateFormatterGet = DateFormatter()
                                                              dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

                                                              let dateFormatterPrint = DateFormatter()
                                                              dateFormatterPrint.dateFormat = "MMM dd,yyyy"
                                                              

                                                              self.date_lbl.text = "Joined \(dateFormatterPrint.string(from: datees as Date))"
                                   self.profile_imag.layer.cornerRadius = self.profile_imag.frame.size.width/2
                                   self.profile_imag.layer.backgroundColor = UIColor.lightGray.cgColor
                            let url = URL(string: "\(self.playerInfo.value(forKey: "profile_image")!)")
                                               if(url != nil)
                                               {
                                               
                                                   self.profile_imag.kf.setImage(with: url)

                                               }
                            else
                                {
                                            let name =  self.username_lbl.text
                                                           let nameFormatter = PersonNameComponentsFormatter()
                                                           if let nameComps  = nameFormatter.personNameComponents(from: name!), let firstLetter = nameComps.givenName?.first, let lastName = nameComps.familyName?.first {

                                                                let sortName = "\(firstLetter)\(lastName)"  // J. Singh
                                                               self.porfile_img.setTitle(sortName, for: .normal)
                                                            }
                                                       }
                            self.email_lbl.text = self.playerInfo.value(forKey: "email_address") as? String
                            self.gender_lbl.text = self.playerInfo.value(forKey: "gender") as? String
                            self.mobile_no_lbl.text = self.playerInfo.value(forKey: "mobile_phone") as? String
                            
                            let dob: Timestamp = self.playerInfo.value(forKey: "date_of_birth") as! Timestamp
                              let dobdate: Date = dob.dateValue()
                            
                              let dobdateFormatterGet = DateFormatter()
                              dobdateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

                              let dobdateFormatterPrint = DateFormatter()
                              dobdateFormatterPrint.dateFormat = "MM-dd-yyyy"
                              print(dateFormatterPrint.string(from: datees as Date))

                              self.dob_lbl.text = "\(dateFormatterPrint.string(from: dobdate as Date))"
                            
                            
                            
//                                               let dobstr: String = playerInfo.value(forKey: "date_of_birth") as! String
//                                               let dateFormatter = DateFormatter()
//                                               dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//                                               dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//                                               let date = dateFormatter.date(from: "\(dobstr)")
//                                               dateFormatter.dateFormat = "MM-dd-yyyy"
//                                               let dobDate = dateFormatter.string(from: date!)
                                              // self.dob_lbl.text = "\(dobDate)"
                                               //let getaddress: NSDictionary = playerInfo.value(forKey: "address") as! NSDictionary
                            self.address_lbl.text = "\(self.playerInfo.value(forKey: "street1")!)" + ", " + "\(self.playerInfo.value(forKey: "street2")!)" + "\n" + "\(self.playerInfo.value(forKey: "city")!)" + "-" + "\(self.playerInfo.value(forKey: "postal_code")!)" + "\n" + "\(self.playerInfo.value(forKey: "state_name")!)" + "," + "\(self.playerInfo.value(forKey: "country_name")!)"
                            if(self.isPlayerDelegate == false)
                            {
                            self.GetOrganization()
                            }
                        }
                        else {
                            print("Document does not exist")
                        }
        }
    }
        
        func GetOrganization()
        {
            sections = [ProfileCategory]()
            Constant.internetconnection(vc: self)
            Constant.showActivityIndicatory(uiView: self.view)
            let testStatusUrl: String = Constant.sharedinstance.getOrganizationbyuid
            let header: HTTPHeaders = [
                "idtoken": UserDefaults.standard.string(forKey: "idtoken")!, "UID" : UserDefaults.standard.string(forKey: "UUID")!]
//             var param:[String:AnyObject] = [:]
//            param["uid"] = UserDefaults.standard.string(forKey: "UUID") as AnyObject?
            
            AF.request(testStatusUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON{ (response:AFDataResponse<Any>) in
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
                                let result = info?["data"] as? NSDictionary
                                self.guardiansListArray = NSMutableArray()
                                let getGuardian = result?["guardianlist"] as? NSArray
                                self.guardiansListArray = getGuardian?.mutableCopy() as? NSMutableArray
                                let organisation = result?["orgdata"] as? NSArray
                                self.organizationListArray = NSMutableArray()
                               self.organizationListArray = organisation?.mutableCopy() as? NSMutableArray
                            
                                  if(self.guardiansListArray.count > 0 && self.guardiansListArray.count != 0)
                                 {
                                     self.sections.append(ProfileCategory(name:"Other Guardians", items:self.guardiansListArray as! [[String : Any]]))
                                 }
                                  if(self.organizationListArray.count > 0 && self.organizationListArray.count != 0)
                                 {
                                  self.sections.append(ProfileCategory(name:"Organizations", items:self.organizationListArray as! [[String : Any]]))
                                 }
                                 let height: Int =  self.guardiansListArray.count + self.organizationListArray.count + self.sections.count
                                 self.playerprofile_tbl_height.constant = (height>2) ? CGFloat(height * 65) :CGFloat(height * 65)
                                 self.playerprofile_tbl.reloadData()

                                 self.profile_scroll.contentSize = CGSize(width: self.view.frame.size.width, height: self.playerprofile_tbl.frame.origin.y + self.playerprofile_tbl_height.constant)
                        //        Constant.showInActivityIndicatory()
                                

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
            let sepFrame: CGRect = CGRect(x: 0, y: view.frame.size.height-1, width: self.view.frame.size.width, height: 1);
                   let seperatorView = UIView.init(frame: sepFrame)
                   seperatorView.backgroundColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
                       view.addSubview(seperatorView)
              }
       
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return self.sections.count
        }
        
//        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//           
//            return self.sections[section].name
//        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 90.0
        }
         func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 45.0
         }

         func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
             return 45.0
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
                cell.username_lbl?.text = (item["first_name"] as! String == "" && item["last_name"] as! String == "") ? "\(item["email_address"] as! String)" : "\(item["first_name"] as! String)" + " " + "\(item["middle_initial"] as! String)" + " " + "\(item["last_name"] as! String)" //"\(item["first_name"] as! String)" + " " + "\(item["middle_initial"] as! String)" + " " + "\(item["last_name"] as! String)"
                cell.gender_lbl.text = "Guardian" //item["gender"] as? String
            }
            else
            {
                let dic: NSArray = (item["governing_body_info"] as? NSArray)!
                let sportsname: NSDictionary = dic[0] as! NSDictionary
                let national: NSDictionary = dic[1] as! NSDictionary

                cell.username_lbl.text = item["abbrev"] as? String
                cell.gender_lbl.text = "\(item["name"]!)" + "\n" + "\(sportsname.value(forKey: "sport_name")!)" + "," + "\(national.value(forKey: "sport_name") as! String)"
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
                let organitiondetailadd: NSMutableArray = NSMutableArray()
                organitiondetailadd.add(item)
                vc.organizationDetails = organitiondetailadd
                //vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
    
    func addressupdateSuccess() {
        isPlayerDelegate = true
           getplayerDetail()

       }
       
       func genderupdateSuccess() {
        isPlayerDelegate = true
           getplayerDetail()

       }
       
       func mobileupdateSuccess() {
        isPlayerDelegate = true
          getplayerDetail()

       }
       
       func usernameupdateSuccess() {
        isPlayerDelegate = true
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
        //Crashlytics.sharedInstance().crash()
        RemovePlayerconnection()
    }
    
    @IBAction func usernameEdit(_ sender: UIButton)
       {
           let vc = storyboard?.instantiateViewController(withIdentifier: "updatename") as! UsernameEditVC
           vc.userDetailDic = playerInfo
          vc.delegate = self
        vc.isUpdateName = false

          self.navigationController?.pushViewController(vc, animated: true)
       }
    @IBAction func mobileEdit(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UpdateMobile") as! MobileEditVC
        vc.getAllDic = playerInfo
        vc.delegate = self
        vc.isUpdatePage = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func genderEdit(_ sender: UIButton)
    {
       let vc = storyboard?.instantiateViewController(withIdentifier: "updateGender") as! GenderEditVC
        vc.getalldoc = playerInfo
        vc.delegate = self
        vc.isUpdateGender = false

       self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func addressEdit(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Update_address") as! AddressEditVC
        vc.addressDetailDic = self.playerInfo
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
        //Crashlytics.sharedInstance().crash()
        
               let profileImageFromPicker = info[UIImagePickerControllerOriginalImage] as! UIImage
                
               let metadata = StorageMetadata()
               metadata.contentType = "image/jpeg"
                
               let imageData: Data = UIImageJPEGRepresentation(profileImageFromPicker, 0.5)!
                 self.profile_imag.image = profileImageFromPicker
               let store = Storage.storage()
               let user = Auth.auth().currentUser
               if let user = user{
                   let storeRef = store.reference().child("profileavatar/\(user.uid).jpg")
                   let _ = storeRef.putData(imageData, metadata: metadata) { (metadata, error) in
                       guard let _ = metadata else {
                           print("error occurred: \(error.debugDescription)")
                           return
                       }
        
                      
                   }
                    
               }
                
           }
}
