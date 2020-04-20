//
//  TermAndConditionVC.swift
//  SportsGravy
//
//  Created by CSS on 11/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Alamofire

class TermAndConditionVC: UIViewController, UITextViewDelegate {

    var parentdetails: NSDictionary!
    var signuserDetail: NSDictionary!
    var useruid: String!
    @IBOutlet weak var term_txv: UITextView!
    
    let term = "Terms of Service"
    let policy = "Private Policy"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        term_txv.tintColor = UIColor.blue
        let linkedText = NSMutableAttributedString(attributedString: term_txv.attributedText)
        let hyperlinked = linkedText.setAsLink(textToFind: "[Privacy Notice]", linkURL: "http://www.sportsgravy.com/legal/privacy-notice")
                      
              if hyperlinked {
                    term_txv.attributedText = NSAttributedString(attributedString: linkedText)
              }
        
        let childrenhyperlinked = linkedText.setAsLink(textToFind: "[Children’s Privacy Notice]", linkURL: "http://www.sportsgravy.com/legal/childrens-privacy-notice")
                
        if childrenhyperlinked {
              term_txv.attributedText = NSAttributedString(attributedString: linkedText)
        }
   
        
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {

        //Code to the respective action

        return false
    }
    @IBAction func acceptbtn(_ sender: UIButton)
    {
        getsignupwebservice()
    }
    @IBAction func cancelbtn(_ sender: UIButton)
    {
        
    }

    func getsignupwebservice()
    {
        let childrenArray: NSMutableArray = NSMutableArray()
        if(self.signuserDetail.value(forKey: "children") as? NSArray != nil)
        {
            let childrendetail: NSArray = signuserDetail.value(forKey: "children") as! NSArray
            let childrenmutable: NSMutableArray = childrendetail.mutableCopy() as! NSMutableArray
            let childrenDic: NSDictionary = childrenmutable[0] as! NSDictionary
            let roleDic: NSDictionary = childrenDic.value(forKey: "roleInfo") as! NSDictionary

            let partentname: String = "\(signuserDetail.value(forKey: "first_name")!)" + "," + "\(signuserDetail.value(forKey: "last_name")!)"
            let childrenAdress: String = "\(childrenDic.value(forKey: "street1")!)" + "," + "\(childrenDic.value(forKey: "street2")!)" + "," + "\(childrenDic.value(forKey: "city")!)" + "," + "\(childrenDic.value(forKey: "state_name")!)" + "," + "\(childrenDic.value(forKey: "country_name")!)" + "," + "\(childrenDic.value(forKey: "postal_code")!)"
            let childrenorg : NSDictionary = childrenDic.value(forKey: "organization_Address") as! NSDictionary
            let childrenorgAdress: String = "\(childrenorg.value(forKey: "street1")!)" + "," + "\(childrenorg.value(forKey: "street2")!)" + "," + "\(childrenorg.value(forKey: "city")!)" + "," + "\(childrenorg.value(forKey: "state")!)" + "," + "\(childrenorg.value(forKey: "country_code")!)" + "," + "\(childrenorg.value(forKey: "postal_code")!)"
            
            
            let dicMutable = NSMutableDictionary()
            dicMutable.setValue(signuserDetail.value(forKey: "age") ?? "", forKey: "age")
            dicMutable.setValue(childrenAdress, forKey: "childern_address")
            dicMutable.setValue(signuserDetail.value(forKey: "email_address") ?? "", forKey: "email")
            dicMutable.setValue(signuserDetail.value(forKey: "middle_initial") ?? "", forKey: "first_name")
            dicMutable.setValue(signuserDetail.value(forKey: "last_name") ?? "", forKey: "last_name")
            dicMutable.setValue(roleDic.value(forKey: "level_name") ?? "", forKey: "level_name")
            dicMutable.setValue(signuserDetail.value(forKey: "middle_initial") ?? "", forKey: "middle_name")
            dicMutable.setValue(childrenorgAdress, forKey: "org_address")
            dicMutable.setValue(signuserDetail.value(forKey: "email_address") ?? "", forKey: "parent_emaild")
            dicMutable.setValue(partentname, forKey: "parent_name")
            dicMutable.setValue("Guardian", forKey: "relation")
            dicMutable.setValue(roleDic.value(forKey: "season_label") ?? "" , forKey: "season_name")
            dicMutable.setValue(roleDic.value(forKey: "sport_name") ?? "", forKey: "sport_name")
            dicMutable.setValue(childrenDic.value(forKey: "suffix") ?? "", forKey: "suffix")
            dicMutable.setValue(childrenDic.value(forKey: "user_id") ?? "", forKey: "user_id")
            dicMutable.setValue(childrenDic.value(forKey: "parent_user_id") ?? "", forKey: "parent_user_id")


            childrenArray.add(dicMutable.copy())
        }
        Constant.internetconnection(vc: self)
                   Constant.showActivityIndicatory(uiView: self.view)
                   let testStatusUrl: String = Constant.sharedinstance.signupUrl
                    var param:[String:AnyObject] = [:]
        param["children"] = childrenArray.copy() as AnyObject
        param["city"] = "" as AnyObject
        param["confirm_password"] = self.parentdetails.value(forKey: "confirm_password") as AnyObject?
        param["country_code"] = "" as AnyObject
        param["date_of_birth"] = "\(parentdetails.value(forKey: "dob")!)" as AnyObject
        param["email"] = parentdetails.value(forKey: "email_address") as AnyObject?
        param["first_name"] = parentdetails.value(forKey: "first_name") as AnyObject?
        param["gender"] = "" as AnyObject
        param["is_condition_applied"] = true as AnyObject
        param["last_name"] = parentdetails.value(forKey: "last_name") as AnyObject?
        param["middle_initial"] = parentdetails.value(forKey: "middle_name") as AnyObject?
        param["mobile_phone"] = parentdetails.value(forKey: "mobile_number") as AnyObject?
        param["password"] = parentdetails.value(forKey: "password") as AnyObject?
        param["postal_code"] = "" as AnyObject
        param["state"] = "" as AnyObject
        param["street1"] = "" as AnyObject
        param["street2"] = "" as AnyObject
        param["suffix"] = parentdetails.value(forKey: "suffix") as AnyObject?
        param["uid"] = signuserDetail.value(forKey: "user_id") as AnyObject?
        print("param:\(param)")
                   
        AF.request(testStatusUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response:AFDataResponse<Any>) in
            Constant.showInActivityIndicatory()

                       if(!(response.error != nil)){
                           switch (response.result)
                           {
                           case .success(let json):
                            let jsonData = json

                             //  if let data = response.data{
                                   let info = jsonData as? NSDictionary
                                   let statusCode = info?["status"] as? Bool
                                   if(statusCode == true)
                                   {
                                       let result = info?["data"] as! NSDictionary

                                      Constant.showInActivityIndicatory()
                                    let objcongz: ConguralutionVC = (self.storyboard?.instantiateViewController(identifier: "congz"))!
                                    self.navigationController?.pushViewController(objcongz, animated: true)
                                   }
                            else
                                   {
                                    Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "\(info?["message"]! ?? "")")
                            }
                                   Constant.showInActivityIndicatory()
                              // }
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
extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
           self.addAttribute(.link, value: linkURL, range: foundRange)
            
            return true
        }
        return false
    }
}
