//
//  TermAndConditionVC.swift
//  SportsGravy
//
//  Created by CSS on 11/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Alamofire

class TermAndConditionVC: UIViewController {

    var parentdetails: NSDictionary!
    var useruid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        let getplayerlist = UserDefaults.standard.array(forKey: "playerList")
        Constant.internetconnection(vc: self)
                   Constant.showActivityIndicatory(uiView: self.view)
                   let testStatusUrl: String = Constant.sharedinstance.signupUrl
                    var param:[String:AnyObject] = [:]
        param["children"] = getplayerlist as AnyObject
        param["city"] = "" as AnyObject
        param["confirm_password"] = parentdetails.value(forKey: "confirm_password") as AnyObject?
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
        param["uid"] = useruid as AnyObject?
                   
        Alamofire.request(testStatusUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response:DataResponse<Any>) in
                       if(!(response.error != nil)){
                           switch (response.result)
                           {
                           case .success(_):
                               if let data = response.result.value{
                                   let info = data as? NSDictionary
                                   let statusCode = info?["status"] as? Bool
                                   if(statusCode == true)
                                   {
                                       let result = info?["data"] as! NSDictionary

                                      Constant.showInActivityIndicatory()
                                    let objcongz: ConguralutionVC = (self.storyboard?.instantiateViewController(identifier: "congz"))!
                                    self.navigationController?.pushViewController(objcongz, animated: true)
                                   }
                                   Constant.showInActivityIndicatory()
                               }
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
