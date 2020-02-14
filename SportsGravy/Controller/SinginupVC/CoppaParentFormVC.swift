//
//  CoppaParentFormVC.swift
//  SportsGravy
//
//  Created by CSS on 12/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

protocol ParentconsentDelegate: AnyObject {
    func parentconsentform()

}


class CoppaParentFormVC: UIViewController {
    
    weak var delegate:ParentconsentDelegate?

    @IBOutlet weak var  parent_scroll: UIScrollView!
    @IBOutlet weak var childname_lbl: UILabel!
    @IBOutlet weak var childemail_lbl: UILabel!
    @IBOutlet weak var child_dob_lbl: UILabel!
    @IBOutlet weak var child_mailing_lbl: UILabel!
    @IBOutlet weak var sport_organization_lbl: UILabel!
    @IBOutlet weak var sport_lbl: UILabel!
    @IBOutlet weak var season_lbl: UILabel!
    @IBOutlet weak var level_lbl: UILabel!
    @IBOutlet weak var parents_lbl: UILabel!
    @IBOutlet weak var relationship_lbl: UILabel!
    @IBOutlet weak var parent_email_lbl: UILabel!
    @IBOutlet weak var parent_phone_lbl: UILabel!
    @IBOutlet weak var childname_title_lbl: UILabel!
    @IBOutlet weak var childemail_title_lbl: UILabel!
    @IBOutlet weak var child_dob_title_lbl: UILabel!
    @IBOutlet weak var child_mailing_title_lbl: UILabel!
    @IBOutlet weak var sport_organization_title_lbl: UILabel!
    @IBOutlet weak var sport_title_lbl: UILabel!
    @IBOutlet weak var season_title_lbl: UILabel!
    @IBOutlet weak var level_title_lbl: UILabel!
    @IBOutlet weak var parents_title_lbl: UILabel!
    @IBOutlet weak var relationship_title_lbl: UILabel!
    @IBOutlet weak var parent_email_title_lbl: UILabel!
    @IBOutlet weak var parent_phone_title_lbl: UILabel!
    @IBOutlet weak var accept_btn: UIButton!
    @IBOutlet weak var userdetailview: UIView!
    var details: NSMutableArray!
    var parentDetails: NSMutableDictionary!
    var playerdetails: NSDictionary!
    var isAccept: Bool!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textborder(selecttext: child_dob_lbl)
        textborder(selecttext: childname_lbl)
        textborder(selecttext: childemail_lbl)
        textborder(selecttext: parents_lbl)
        textborder(selecttext: parent_email_lbl)
        textborder(selecttext: parent_phone_lbl)
        textborder(selecttext: sport_organization_lbl)
        textborder(selecttext: season_lbl)
        textborder(selecttext: level_lbl)
        textborder(selecttext: relationship_lbl)
        textborder(selecttext: sport_lbl)
        textborder(selecttext: child_mailing_lbl)
        textborder(selecttext: childname_title_lbl)
        textborder(selecttext: child_dob_title_lbl)
        textborder(selecttext: childemail_title_lbl)
        textborder(selecttext: child_mailing_lbl)
        textborder(selecttext: sport_title_lbl)
        textborder(selecttext: sport_organization_title_lbl)
        textborder(selecttext: level_title_lbl)
        textborder(selecttext: season_title_lbl)
        textborder(selecttext: parents_title_lbl)
        textborder(selecttext: parent_email_title_lbl)
        textborder(selecttext: parent_phone_title_lbl)
        textborder(selecttext: child_mailing_lbl)
        textborder(selecttext: relationship_title_lbl)
        textborder(selecttext: child_mailing_title_lbl)
        
        accept_btn.layer.cornerRadius = accept_btn.frame.size.width/2
        accept_btn.layer.borderWidth = 1
        accept_btn.layer.borderColor = UIColor.black.cgColor
        accept_btn.layer.masksToBounds = true
        
        userdetailview.layer.cornerRadius = 0
        userdetailview.layer.borderWidth = 2
        userdetailview.layer.borderColor = UIColor.black.cgColor
        userdetailview.layer.masksToBounds = true
        
        parent_scroll.contentSize = CGSize(width: self.parent_scroll.frame.size.width, height: 1500)
       
        isAccept = false
        
    }
    func textborder( selecttext: UILabel)
    {
        selecttext.layer.cornerRadius = 0
        selecttext.layer.borderColor = UIColor.black.cgColor
        selecttext.layer.borderWidth = 1
        selecttext.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        playerdetails = self.details?[0] as? NSDictionary
               self.childname_lbl.text = "" + "\(playerdetails.value(forKey: "first_name")!)" + " " + "\(playerdetails.value(forKey: "last_name")!)"
               self.childemail_lbl.text = " " + "\(playerdetails.value(forKey: "email_address")!)"
               self.child_dob_lbl.text = " " + "\(playerdetails.value(forKey: "date_of_birth")!)"
               let getaddtress: NSDictionary = playerdetails.value(forKey: "address") as! NSDictionary
               self.child_mailing_lbl.text = " " + "\(getaddtress.value(forKey: "street1")!)" + " " + "\(getaddtress.value(forKey: "street2")!)" + "\n" + "\(getaddtress.value(forKey: "city")!)" + " " + "\(getaddtress.value(forKey: "country_code")!)" + "\n" + "\(getaddtress.value(forKey: "postal_code")!)"
               let getroleinfo: NSDictionary = playerdetails.value(forKey: "roleInfo") as! NSDictionary
               self.sport_lbl.text = " " + "\(getroleinfo.value(forKey: "sport_name")!)"
               self.season_lbl.text = " " + "\(getroleinfo.value(forKey: "season_label")!)"
               self.level_lbl.text = " " + "\(getroleinfo.value(forKey: "level_name")!)"
               let getorgzationAddress: NSDictionary = getroleinfo.value(forKey: "organization_Address") as! NSDictionary
               self.sport_organization_lbl.text = " " + "\(getroleinfo.value(forKey: "organization_abbrev")!)" + "\n"
                   + "\(getorgzationAddress.value(forKey: "street1")!)" + "\(getorgzationAddress.value(forKey: "street2")!)" + "\n" + "\(getorgzationAddress.value(forKey: "city")!)" + "\(getorgzationAddress.value(forKey: "state")!)" + "\n" + "\(getorgzationAddress.value(forKey: "country_code")!)" + "\(getorgzationAddress.value(forKey: "postal_code")!)"
        self.parents_lbl.text = " " + "\(parentDetails.value(forKey: "first_name")!)" + "" + "\(parentDetails.value(forKey: "middle_name")!)" + "" + "\(parentDetails.value(forKey: "last_name")!)"
        self.relationship_lbl.text = " Guardian"
        self.parent_email_lbl.text = " " + "\(parentDetails.value(forKey: "email_address")!)"
        self.parent_phone_lbl.text = " " + "\(parentDetails.value(forKey: "mobile_number")!)"
     }

    @IBAction func acceptbtn(_ sender: UIButton)
    {
        if(isAccept == false)
        {
            accept_btn.backgroundColor =  UIColor.green
            isAccept = true
            let count = UserDefaults.standard.integer(forKey: "13belowagecount")
            UserDefaults.standard.removeObject(forKey: "13belowagecount")
            UserDefaults.standard.set(count-1, forKey: "13belowagecount")
            
        }
        else
        {
            accept_btn.backgroundColor =  UIColor.white
            isAccept = false
            let count = UserDefaults.standard.integer(forKey: "13belowagecount")
            UserDefaults.standard.removeObject(forKey: "13belowagecount")
            UserDefaults.standard.set(count+1, forKey: "13belowagecount")
        }
    }
    @IBAction func nextbtnaction(_ sender: UIButton)
    {
        if(accept_btn.backgroundColor == UIColor.green)
        {
             let count = UserDefaults.standard.integer(forKey: "13belowagecount")
            let playerdetailDic: NSMutableDictionary = NSMutableDictionary()
            playerdetailDic.setValue(playerdetails.value(forKey: "age"), forKey: "age")
            playerdetailDic.setValue(child_mailing_lbl.text, forKey: "childern_address")
            playerdetailDic.setValue(child_dob_lbl.text, forKey: "dob")
            playerdetailDic.setValue(childemail_lbl.text, forKey: "email")
            playerdetailDic.setValue(playerdetails.value(forKey: "first_name"), forKey: "first_name")
            playerdetailDic.setValue(true, forKey: "isParentConsentCompleted")
            playerdetailDic.setValue(playerdetails.value(forKey: "last_name"), forKey: "last_name")
            playerdetailDic.setValue(level_lbl.text, forKey: "level_name")
            playerdetailDic.setValue(playerdetails.value(forKey: "middle_initial"), forKey: "middle_name")
            playerdetailDic.setValue(sport_organization_lbl.text, forKey: "org_address")
            playerdetailDic.setValue(parent_email_lbl.text, forKey: "parent_emaild")
            playerdetailDic.setValue(parents_lbl.text, forKey: "parent_name")
            playerdetailDic.setValue(parent_phone_lbl.text, forKey: "parent_phone")
            let getparentuserid: NSArray = playerdetails.value(forKey: "parent_user_id") as! NSArray
            playerdetailDic.setValue(getparentuserid, forKey: "parent_user_id")
            playerdetailDic.setValue(relationship_lbl.text, forKey: "relation")
            playerdetailDic.setValue(season_lbl.text, forKey: "season_name")
            playerdetailDic.setValue(sport_lbl.text, forKey: "sport_name")
            playerdetailDic.setValue(parentDetails.value(forKey: "suffix"), forKey: "suffix")
            playerdetailDic.setValue(playerdetails.value(forKey: "user_id"), forKey: "user_id")
            let addPlayer: NSMutableArray = NSMutableArray()
            addPlayer.add(playerdetailDic.copy())
            UserDefaults.standard.set(addPlayer.copy(), forKey: "playerList")
            
            
            if(count == 0)
            {
                let objterm: TermAndConditionVC = (self.storyboard?.instantiateViewController(identifier: "termandcon"))!
                objterm.parentdetails = (parentDetails.copy() as! NSDictionary)
                objterm.useruid = playerdetails.value(forKey: "user_id") as? String
                
                self.navigationController?.pushViewController(objterm, animated: true)
            }
            else
            {
                
                self.delegate?.parentconsentform()
                self.navigationController?.popViewController(animated: true)
            }
        }
        else
        {
            Constant.showAlertMessage(vc: self, titleStr: "Sport Gravy", messageStr: "Please accept the parent consent form")
        }
    }
    
}
