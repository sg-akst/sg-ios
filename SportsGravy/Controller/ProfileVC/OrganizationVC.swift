//
//  OrganizationVC.swift
//  SportsGravy
//
//  Created by CSS on 22/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class OrganizationVC: UIViewController {

    var organizationDetails: NSMutableArray!
    
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
        let organization = self.organizationDetails[0] as? NSDictionary
        //self.profile_imag.isHidden = true
        self.username_lbl.text = "\(organization?.value(forKey: "abbrev") ?? "")"
        self.username_lbl.textColor = UIColor.blue
        let createdate = organization?.value(forKey: "created_datetime") as? NSDictionary
        let getcreatedate = createdate?.value(forKey: "$date") as! Int
        
        
        
        let string : String = "\(getcreatedate)" // (Put your string here)

        let timeinterval : TimeInterval = (string as NSString).doubleValue // convert it in to NSTimeInteral

        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here

        print(dateFromServer) // for My Example it will print : 2014-08-22 12:11:26 +0000


        // Here i create a simple date formatter and print the string from DATE object. you can do it vise-versa.

        let dateFormater : DateFormatter = DateFormatter()
        dateFormater.dateFormat = "yyyy-MMM-dd"
        print(dateFormater.string(from: dateFromServer as Date))
        
        
        self.date_lbl.text = "Joined \(dateFormater.string(from: dateFromServer as Date))"
        
       // let timeInterval = Double(getcreatedate)

        // create NSDate from Double (NSTimeInterval)
       // let myNSDate = Date(timeIntervalSince1970: timeInterval)
        //let date = NSDate(timeIntervalSince1970: TimeInterval(getcreatedate))

        //let joinDatestr: String = myNSDate
//       let dateFormatters = DateFormatter()
//        dateFormatters.locale = Locale(identifier: "en_US_POSIX")
//                                                            dateFormatters.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//                                                            let dates = dateFormatters.date(from: "\(date)")
//                                                            dateFormatters.dateFormat = "MMM-dd-yyyy"
//                                                            let dobDate = dateFormatters.string(from: dates!)
//
//            self.date_lbl.text = "Joined \(dobDate)"
                                       
        self.porfile_img.setTitle(organization?.value(forKey: "abbrev") as? String, for: .normal)
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
         //self.porfile_img.layer.cornerRadius = self.porfile_img.frame.size.width/2
        
        self.email_lbl.text = organization?.value(forKey: "email_address") as? String
        let dic: NSArray = organization?["governing_body_info"] as! NSArray
        if(dic.count>0)
        {
            let sportsname: NSDictionary = dic[0] as! NSDictionary
            self.sports_lbl.text = sportsname.value(forKey: "name") as? String
            state_lbl.text = sportsname.value(forKey: "state_governing_organization_name") as? String
            national_lbl.text = sportsname.value(forKey: "national_governing_organization_name") as? String

        }

        self.mobile_no_lbl.text = organization?.value(forKey: "mobile_phone") as? String
       // let getaddress: NSDictionary = self.organizationDetails.value(forKey: "address") as! NSDictionary
        self.address_lbl.text = "\(organization?.value(forKey: "street1")! ?? "")" + ", " + "\(organization?.value(forKey: "street2")! ?? "")" + "\n" + "\(organization?.value(forKey: "city")! ?? "")" + "-" + "\(organization?.value(forKey: "postal_code")! ?? "")" + "\n" + "\(organization?.value(forKey: "state")! ?? "")" + "," + "\(organization?.value(forKey: "country_code")! ?? "")"
        name_lbl.text = organization?.value(forKey: "name") as? String
        fax_lbl.text = organization?.value(forKey: "fax") as? String
        website_lbl.text = organization?.value(forKey: "website") as? String
        self.profile_scroll.contentSize = CGSize(width: self.view.frame.size.width, height: 300)
        
    }
    

   @IBAction func organizationcancelbtn(_ sender: UIButton)
   {
    
      self.navigationController?.popViewController(animated: true)
   }

}
