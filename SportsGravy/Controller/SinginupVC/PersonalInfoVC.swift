//
//  PersonalInfoVC.swift
//  SportsGravy
//
//  Created by CSS on 30/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import STPopup

class PersonalInfoVC: UIViewController,PopViewDelegate, UITextFieldDelegate {
    func selectoptionString(selectSuffix: String) {
        self.suffix_lbl.text = selectSuffix
    }
    
    
    @IBOutlet weak var firstname_lbl: UITextField!
    @IBOutlet weak var middlename_lbl: UITextField!
    @IBOutlet weak var lastname_lbl: UITextField!
    @IBOutlet weak var dob_lbl: UITextField!
    @IBOutlet weak var mobile_lbl: UITextField!
    @IBOutlet weak var email_lbl: UITextField!
    @IBOutlet weak var password_lbl: UITextField!
    @IBOutlet weak var confirm_lbl: UITextField!
    @IBOutlet weak var suffix_lbl: UITextField!
    
    var userdetails: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        firstname_lbl.delegate = self
        lastname_lbl.delegate = self
        middlename_lbl.delegate = self
        dob_lbl.delegate = self
        mobile_lbl.delegate = self
        email_lbl.delegate = self
        password_lbl.delegate = self
        suffix_lbl.delegate = self
        confirm_lbl.delegate = self
        bordermethod(setborder: firstname_lbl)
        bordermethod(setborder: lastname_lbl)
        bordermethod(setborder: middlename_lbl)
        bordermethod(setborder: dob_lbl)
        bordermethod(setborder: mobile_lbl)
        bordermethod(setborder: email_lbl)
        bordermethod(setborder: password_lbl)
        bordermethod(setborder: suffix_lbl)
        bordermethod(setborder: confirm_lbl)
        
        self.firstname_lbl.text = self.userdetails.value(forKey: "first_name") as? String
        self.middlename_lbl.text = self.userdetails.value(forKey: "middle_initial") as? String
        self.lastname_lbl.text = self.userdetails.value(forKey: "last_name") as? String
        self.dob_lbl.text = self.userdetails.value(forKey: "date_of_birth") as? String
        self.email_lbl.text = self.userdetails.value(forKey: "email_address") as? String
        self.mobile_lbl.text = self.userdetails.value(forKey: "mobile_number") as? String
        self.password_lbl.text = self.userdetails.value(forKey: "") as? String
        self.suffix_lbl.text = self.userdetails.value(forKey: "suffix") as? String
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }

    func bordermethod(setborder: UITextField)
       {
           let thickness: CGFloat = 1.0

           let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: setborder.frame.size.height - thickness, width: setborder.frame.size.width, height:thickness)
             bottomBorder.backgroundColor = UIColor.lightGray.cgColor
           setborder.layer.addSublayer(bottomBorder)
       }
    @IBAction func selectprofilesuffix(_ sender: UIButton)
       {
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "pop") as! PopVC
           vc.Title = "Select Suffix"
           vc.suffixArray = ["Jr","Sr","II","III","IV","V"]
           vc.delegate = self
        vc.contentSizeInPopup = CGSize(width: self.view.frame.size.width - 20, height: 345.0)
           let popup = STPopupController(rootViewController: vc)
           popup.containerView.layer.cornerRadius = 4;
           popup.navigationBarHidden = true
        popup.style = .bottomSheet
           popup.present(in: self)
       }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == self.mobile_lbl)
        {
          return textField.text!.count < 17 || string == ""
        }
        else
        {
           return true
        }
    }
    @IBAction func nextbtn(_ sender: UIButton)
    {
        if(self.suffix_lbl.text == "" || self.suffix_lbl.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Select Suffix ")

        }
        
        if(self.dob_lbl.text == "" || self.dob_lbl.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Choose Date Of Birth ")

        }
        if(self.email_lbl.text == "" || self.email_lbl.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Email Address ")

        }
       
        if(isValidEmail(self.email_lbl.text!) == false)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Check Email Id ")

        }
        if(self.mobile_lbl.text == "" || self.mobile_lbl.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Mobile Number ")

        }
        if(isValidMobile(testStr: self.mobile_lbl.text!) == false)
        {
           Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Check Mobile Number ")

        }
        if(self.password_lbl.text == "" || self.password_lbl.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Password ")

        }
        if(self.confirm_lbl.text == "" || self.confirm_lbl.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Confirm Password ")

        }
        if(self.password_lbl.text != self.confirm_lbl.text)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Password And Confirm Password Doesn’t Match")

        }
       
        else{
            
            let getparentdetails: NSMutableDictionary = NSMutableDictionary()
            getparentdetails.setValue(firstname_lbl.text, forKey: "first_name")
            getparentdetails.setValue(middlename_lbl.text, forKey: "middle_name")
            getparentdetails.setValue(lastname_lbl.text, forKey: "last_name")
            getparentdetails.setValue(email_lbl.text, forKey: "email_address")
            getparentdetails.setValue(dob_lbl.text, forKey: "dob")
            getparentdetails.setValue(mobile_lbl.text, forKey: "mobile_number")
            getparentdetails.setValue(suffix_lbl.text, forKey: "suffix")
            getparentdetails.setValue(confirm_lbl.text, forKey: "confirm_password")
            getparentdetails.setValue(password_lbl.text, forKey: "password")
            
            let objpersonalVC: InvitePlayerVC = (self.storyboard?.instantiateViewController(identifier: "inviteplayer"))!
            objpersonalVC.userdetails = userdetails
            objpersonalVC.parententerdetails = getparentdetails
            self.navigationController?.pushViewController(objpersonalVC, animated: true)
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func isValidMobile(testStr:String) -> Bool {
        let range = NSRange(location: 0, length: testStr.count)
        let regex = try! NSRegularExpression(pattern: "(\\([0-9]{3}\\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}")
        if regex.firstMatch(in: testStr, options: [], range: range) != nil{
            print("Phone number is valid")
            return true
        }else{
            return false
        }
        
    }
}
