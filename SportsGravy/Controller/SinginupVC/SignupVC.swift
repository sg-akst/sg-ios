//
//  SignupVC.swift
//  SportsGravy
//
//  Created by CSS on 03/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Alamofire

class SignupVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var logoview: UIView!
    @IBOutlet weak var email_txt: UITextField!
    
    
    var uidString: String!
    var userdetails: NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoview.layer.borderColor = UIColor.lightGray.cgColor
        self.logoview.layer.borderWidth = 0.5
        self.logoview.layer.masksToBounds = true
        self.bordermethod(setborder: email_txt)
        self.email_txt.delegate = self
        getuserInfoDetails()
    }
    func bordermethod(setborder: UITextField)
    {
        let thickness: CGFloat = 1.0

        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: setborder.frame.size.height - thickness, width: setborder.frame.size.width, height:thickness-1)
          bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        setborder.layer.addSublayer(bottomBorder)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         print("textFieldShouldReturn")
         textField.resignFirstResponder()
         return true
     }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
         print("textFieldShouldBeginEditing")
         return true
     }

    func textFieldDidBeginEditing(_ textField: UITextField) {
         print("textFieldDidBeginEditing")
         print("Leaving textFieldDidBeginEditing")
     }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         print("textField")
         print("Leaving textField")
         return true
     }

    func textFieldDidEndEditing(_ textField: UITextField) {
         print("textFieldDidEndEditing")
        print("textField = \(textField.text ?? "")")
         print("Leaving textFieldDidEndEditing")
     }
    func getuserInfoDetails()
    {
            Constant.internetconnection(vc: self)
            Constant.showActivityIndicatory(uiView: self.view)
            let testStatusUrl: String = Constant.sharedinstance.signupString
        let header: HTTPHeaders = [
            "idtoken": UserDefaults.standard.string(forKey: "idtoken")! , "UID" : "7XrpgTtJOwGctldTcqse"]
            AF.request(testStatusUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON{ (response:AFDataResponse<Any>) in
                if(!(response.error != nil)){
                    switch (response.result)
                    {
                    case .success(let json):
                        let jsonData = json

                       // if let data = response.data{
                            let info = jsonData as? NSDictionary
                            let statusCode = info?["Status"] as? Bool
                            if(statusCode == true)
                            {
                                let result = info?["Data"] as! NSDictionary
                                self.email_txt.text = result.value(forKey: "email_address") as? String
                                self.userdetails = result
                               Constant.showInActivityIndicatory()

                            }
                            //Constant.showInActivityIndicatory()
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
    
    @IBAction func signupnext_btnAction(_ sender: UIButton)
    {
        if Constant.isValidEmail(testStr: email_txt.text!) == false{
            print("Validate EmailID")
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Valid EmailID")
        }
        else
        {
            let objpersonalVC: PersonalInfoVC = (self.storyboard?.instantiateViewController(identifier: "personinfo"))!
            objpersonalVC.userdetails = userdetails
            self.navigationController?.pushViewController(objpersonalVC, animated: true)
        }
        
    }
    
}
