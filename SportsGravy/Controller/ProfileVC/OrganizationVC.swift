//
//  OrganizationVC.swift
//  SportsGravy
//
//  Created by CSS on 22/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class OrganizationVC: UIViewController {

    var organizationDetails: NSDictionary!
    
    @IBOutlet weak var username_lbl: UILabel!
       @IBOutlet weak var date_lbl: UILabel!
       @IBOutlet weak var porfile_img: UIButton!
       @IBOutlet weak var profile_imag: UIImageView!
       @IBOutlet weak var profile_scroll: UIScrollView!
       @IBOutlet weak var email_lbl: UILabel!
       @IBOutlet weak var mobile_no_lbl: UILabel!
       @IBOutlet weak var name_lbl: UILabel!
       @IBOutlet weak var sports_lbl: UILabel!
       @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var fax_lbl: UILabel!
    @IBOutlet weak var website_lbl: UILabel!
    @IBOutlet weak var state_lbl: UILabel!
    @IBOutlet weak var national_lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.username_lbl.text = "\(self.organizationDetails.value(forKey: "abbrev")!)"
         let joinDatestr: String = organizationDetails.value(forKey: "created_datetime") as! String
       let dateFormatters = DateFormatter()
        dateFormatters.locale = Locale(identifier: "en_US_POSIX")
                                                            dateFormatters.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                                            let dates = dateFormatters.date(from: "\(joinDatestr)")
                                                            dateFormatters.dateFormat = "MMM-dd-yyyy"
                                                            let dobDate = dateFormatters.string(from: dates!)
//        let datees: Date = timestamp.dateValue()
//
//        let dateFormatterPrint = DateFormatter()
//        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
//        print(dateFormatterPrint.string(from: datees as Date))
                                                           
            self.date_lbl.text = "Joined \(dobDate)"
                                       
        self.porfile_img.setTitle(organizationDetails.value(forKey: "abbrev") as? String, for: .normal)
         //self.porfile_img.layer.cornerRadius = self.porfile_img.frame.size.width/2
        
        self.email_lbl.text = organizationDetails.value(forKey: "email_address") as? String
        let dic: NSArray = organizationDetails["sports"] as! NSArray
        let sportsname: NSDictionary = dic[0] as! NSDictionary

        self.sports_lbl.text = sportsname.value(forKey: "name") as? String
                                                      self.mobile_no_lbl.text = organizationDetails.value(forKey: "phone") as? String
       // let getaddress: NSDictionary = self.organizationDetails.value(forKey: "address") as! NSDictionary
                                                      self.address_lbl.text = "\(organizationDetails.value(forKey: "street1")!)" + ", " + "\(organizationDetails.value(forKey: "street2")!)" + "\n" + "\(organizationDetails.value(forKey: "city")!)" + "-" + "\(organizationDetails.value(forKey: "postal_code")!)" + "\n" + "\(organizationDetails.value(forKey: "state")!)" + "," + "\(organizationDetails.value(forKey: "country_code")!)"
        name_lbl.text = organizationDetails.value(forKey: "name") as? String
        fax_lbl.text = organizationDetails.value(forKey: "fax") as? String
        website_lbl.text = organizationDetails.value(forKey: "website") as? String
        state_lbl.text = organizationDetails.value(forKey: "state_governing_organization_name") as? String
        national_lbl.text = organizationDetails.value(forKey: "national_governing_organization_name") as? String
        self.profile_scroll.contentSize = CGSize(width: self.view.frame.size.width, height: 300)
        
    }
    

   @IBAction func organizationcancelbtn(_ sender: UIButton)
   {
      self.navigationController?.popViewController(animated: true)
   }

}
