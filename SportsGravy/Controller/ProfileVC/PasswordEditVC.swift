//
//  PasswordEditVC.swift
//  SportsGravy
//
//  Created by CSS on 22/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class PasswordEditVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var oldpw_txt: UITextField!
    @IBOutlet weak var newpw_txt: UITextField!
    @IBOutlet weak var confirmpw_txt: UITextField!
    @IBOutlet weak var pwdupdate_Btn: UIButton!

    
    var getAllDic: NSDictionary!


    override func viewDidLoad() {
        super.viewDidLoad()
        oldpw_txt.delegate = self
        newpw_txt.delegate = self
        confirmpw_txt.delegate = self
        bottomlineMethod(selecttext: oldpw_txt)
        bottomlineMethod(selecttext: newpw_txt)
        bottomlineMethod(selecttext: confirmpw_txt)
        
    }
    func bottomlineMethod(selecttext: UITextField)
    {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -10.0, y: selecttext.frame.height - 1, width: self.view.frame.width, height: 1.0)
        bottomLine.backgroundColor = Constant.getUIColor(hex: "#EEEEEE")?.cgColor
        selecttext.borderStyle = UITextBorderStyle.none
        selecttext.layer.addSublayer(bottomLine)
    }
    // Textfiled delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        // return NO to disallow editing.
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        // became first responder
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason)
    {
        // if implemented, called in place of textFieldDidEndEditing:
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        // called when clear button pressed. return NO to ignore (no notifications)
        return true
    }
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       if let text = textField.text {
           let str = (text as NSString).replacingCharacters(in: range, with: string).replacingOccurrences(of: "(0)", with: "")
           if !str.isEmpty {
               textField.text = "" + str
           } else {
               textField.text = nil
           }
       }
    if(oldpw_txt.text != "" || newpw_txt.text != "" || confirmpw_txt.text != "")
    {
        pwdupdate_Btn.isUserInteractionEnabled = true
        pwdupdate_Btn.setTitleColor(UIColor.blue, for: .normal)
    }
    else
    {
        pwdupdate_Btn.isUserInteractionEnabled = false
        pwdupdate_Btn.setTitleColor(UIColor.darkGray, for: .normal)
    }
    
       return false
   }

    @IBAction func passwordUpdate(_ sender: UIButton)
    {
        
        if(self.oldpw_txt.text == nil || self.oldpw_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Old Password ")

        }
            
        else if(self.newpw_txt.text == nil || self.newpw_txt.text?.isEmpty == true || self.newpw_txt.text!.count < 5)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter New Password ")

        }
        else if(self.oldpw_txt.text == self.newpw_txt.text)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Old Password And New Password Should Not Be Same")
        }
        else if(self.confirmpw_txt.text == nil || self.confirmpw_txt.text?.isEmpty == true)
        {
                  Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Confirm Password")
        }
            
        else if(self.newpw_txt.text != self.confirmpw_txt.text)
        {
              Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Password And Confirm Password Doesn’t Match")
        }
        else
        {
            //Crashlytics.sharedInstance().crash()
             Constant.internetconnection(vc: self)
            Constant.showActivityIndicatory(uiView: self.view)
            let credential = EmailAuthProvider.credential(withEmail: self.getAllDic.value(forKey: "email_address") as! String, password: self.oldpw_txt.text!)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                Constant.showInActivityIndicatory()

                if error != nil {
                    //completion(error)
                    print(error!)
                     Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Vaild Old Password")

                }
                else {
                    Auth.auth().currentUser?.updatePassword(to: self.newpw_txt.text!, completion: { (error) in
                        //completion(error)
                        Constant.showInActivityIndicatory()
                        //Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Password successfully updated")
                       // self.navigationController?.popViewController(animated: true)
                        self.alertermsg(msg: "Password Updated Successfully")
                    })
                }
            })
        }

    }
    
    func alertermsg(msg: String)
    {
        let alert = UIAlertController(title: "SportsGravy", message: msg.capitalized, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
//        self.delegate?.usernameupdateSuccess()
        self.navigationController?.popViewController(animated: true)

               }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
   
    @IBAction func EditPasswordcancelbtn(_ sender: UIButton)
    {
        //Crashlytics.sharedInstance().crash()
       self.navigationController?.popViewController(animated: true)
    }

}
