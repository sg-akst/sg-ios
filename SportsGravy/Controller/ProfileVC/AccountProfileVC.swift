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

class AccountProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var role_lbl: UILabel!
    @IBOutlet weak var email_lbl: UILabel!
    @IBOutlet weak var password_lbl: UILabel!
    @IBOutlet weak var mobile_no_lbl: UILabel!
    @IBOutlet weak var dob_lbl: UILabel!
    @IBOutlet weak var gender_lbl: UILabel!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var organization_abbv_lbl: UILabel!
    @IBOutlet weak var organization_lbl: UILabel!

    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var usernameEdit_btn: UIButton!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var porfile_img: UIButton!
    @IBOutlet weak var profile_imag: UIImageView!
    @IBOutlet weak var profile_scroll: UIScrollView!
    var getAllrole: NSMutableArray!
    var alldoc: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
       var filteredEvents: [String] = self.getAllrole.value(forKeyPath: "@distinctUnionOfObjects.role") as! [String]
       filteredEvents.sort(){$0 < $1}
       print(filteredEvents)
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
       
        var organizationabbv = self.getAllrole.value(forKeyPath: "@distinctUnionOfObjects.organization_abbrev") as! [String]
        organizationabbv.sort(){$0 < $1}
        print(organizationabbv)
        var filteredabbravation = String ()
        filteredabbravation.append(organizationabbv[0])
        organization_abbv_lbl.text = "\(filteredabbravation)"
        
        var organisationname = self.getAllrole.value(forKeyPath: "@distinctUnionOfObjects.organization_name") as! [String]
         organisationname.sort(){$0 < $1}
        var filterorganizationname = String ()
        filterorganizationname.append(organisationname[0])
        organization_lbl.text = "\(filterorganizationname)"
        
        role_lbl.text = filtered
        
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
                          
                          if let document = document, document.exists {
                            self.alldoc = document.data()! as NSDictionary
                            self.username_lbl.text = "\(self.alldoc.value(forKey: "first_name")!)" + " " + "\(self.alldoc.value(forKey: "middle_initial")!)" + " " + "\(self.alldoc.value(forKey: "last_name")!)"
                            
                            let timestamp: Timestamp = self.alldoc.value(forKey: "created_datetime") as! Timestamp
                            let datees: Date = timestamp.dateValue()
                            print(datees)
                            let dateFormatterGet = DateFormatter()
                            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

                            let dateFormatterPrint = DateFormatter()
                            dateFormatterPrint.dateFormat = "MMM dd,yyyy"
                            print(dateFormatterPrint.string(from: datees as Date))

                            self.date_lbl.text = "Joined \(dateFormatterPrint.string(from: datees as Date))"
                            let url = URL(string: "\(self.alldoc.value(forKey: "profile_image")!)")
                            if(url != nil)
                            {
                            
                              self.profile_imag.kf.setImage(with: url)
                                self.profile_imag.layer.cornerRadius = self.profile_imag.frame.size.width/2
                                self.profile_imag.layer.backgroundColor = UIColor.lightGray.cgColor
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
                            let dobDate = dateFormatter.string(from: date!)
                            self.dob_lbl.text = "\(dobDate)"
                            let getaddress: NSDictionary = self.alldoc.value(forKey: "address") as! NSDictionary
                            self.address_lbl.text = "\(getaddress.value(forKey: "street1")!)" + "\(getaddress.value(forKey: "street2")!)" + "\n" + "\(getaddress.value(forKey: "city")!)" + "\(getaddress.value(forKey: "postal_code")!)" + "\n" + "\(getaddress.value(forKey: "state")!)" + "\(getaddress.value(forKey: "country_code")!)"
                
                            
                          } else {
                              print("Document does not exist")
                          }
                        Constant.showInActivityIndicatory()
                        
                      }

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
    
    @IBAction func usernameEdit(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "updatename") as! UsernameEditVC
        vc.userDetailDic = alldoc
       self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func passwordEdit(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "updatePW") as! PasswordEditVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func mobileEdit(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UpdateMobile") as! MobileEditVC
        vc.getAllDic = alldoc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func genderEdit(_ sender: UIButton)
    {
       let vc = storyboard?.instantiateViewController(withIdentifier: "updateGender") as! GenderEditVC
        vc.getalldoc = alldoc
       self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func addressEdit(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Update_address") as! AddressEditVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func organisationEdit(_ sender: UIButton)
    {
       let vc = storyboard?.instantiateViewController(withIdentifier: "Organizationprofile") as! OrganizationVC
       self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func cancelbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }

}
