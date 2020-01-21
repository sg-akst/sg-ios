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

class AccountProfileVC: UIViewController {
    
    @IBOutlet weak var role_lbl: UILabel!
    @IBOutlet weak var email_lbl: UILabel!
    @IBOutlet weak var password_lbl: UILabel!
    @IBOutlet weak var mobile_no_lbl: UILabel!
    @IBOutlet weak var dob_lbl: UILabel!
    @IBOutlet weak var gender_lbl: UILabel!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var organization_lbl: UILabel!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var porfile_img: UIButton!
    @IBOutlet weak var profile_imag: UIImageView!
    @IBOutlet weak var profile_scroll: UIScrollView!


    override func viewDidLoad() {
        super.viewDidLoad()
       // profile_scroll.contentSize = CGSize.init(width: self.profile_scroll.frame.size.width, height: self.profile_scroll.frame.size.height + 100)
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
                           let doc: NSDictionary = document.data()! as NSDictionary
                            self.username_lbl.text = "\(doc.value(forKey: "first_name")!)" + " " + "\(doc.value(forKey: "middle_initial")!)" + " " + "\(doc.value(forKey: "last_name")!)"
                            
                           let timestamp: Timestamp = doc.value(forKey: "created_datetime") as! Timestamp
                            let datees: Date = timestamp.dateValue()
                            print(datees)
                            let dateFormatterGet = DateFormatter()
                            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

                            let dateFormatterPrint = DateFormatter()
                            dateFormatterPrint.dateFormat = "MMM dd,yyyy"
                            print(dateFormatterPrint.string(from: datees as Date))

                            self.date_lbl.text = "Joined \(dateFormatterPrint.string(from: datees as Date))"
                            let url = URL(string: "\(doc.value(forKey: "profile_image")!)")
                            if(url != nil)
                            {
                            
                              self.profile_imag.kf.setImage(with: url)
                                self.profile_imag.layer.cornerRadius = self.profile_imag.frame.size.width/2
                                self.profile_imag.layer.backgroundColor = UIColor.lightGray.cgColor
                            }
                            self.email_lbl.text = doc.value(forKey: "email_address") as? String
                            self.gender_lbl.text = doc.value(forKey: "gender") as? String
                            self.mobile_no_lbl.text = doc.value(forKey: "mobile_phone") as? String
                            let timestamps: String = doc.value(forKey: "date_of_birth") as! String
                            //let datee: Date = timestamps.dateValue()
                            //print(datee)
                            let dateFormatterGets = DateFormatter()
                            dateFormatterGets.dateFormat = "yyyy-MM-dd HH:mm:ss"

                            let dateFormatterPrints = DateFormatter()
                            dateFormatterPrints.dateFormat = "MMM dd,yyyy"
                            print(dateFormatterPrint.string(from: datees as Date))

                            self.dob_lbl.text = "\(dateFormatterPrint.string(from: datees as Date))"
                            
                           
                          } else {
                              print("Document does not exist")
                          }
                        Constant.showInActivityIndicatory()
                        
                      }

    }


}
