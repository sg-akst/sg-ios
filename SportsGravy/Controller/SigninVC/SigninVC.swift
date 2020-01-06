//
//  SigninVC.swift
//  SportsGravy
//
//  Created by CSS on 03/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SigninVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoview: UIView!
    @IBOutlet weak var email_txt: UITextField!
    @IBOutlet weak var password_txt: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

       let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.logoview.frame.size.height - 0.5, width: self.logoview.frame.size.width, height: 0.5)
          bottomBorder.backgroundColor = UIColor.gray.cgColor
        logoview.layer.addSublayer(bottomBorder)
        self.bordermethod(setborder: email_txt)
        self.bordermethod(setborder: password_txt)
        self.email_txt.delegate = self
        self.password_txt.delegate = self
        
        
    }
    func bordermethod(setborder: UITextField)
    {
        let thickness: CGFloat = 1.0

        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: setborder.frame.size.height - thickness, width: setborder.frame.size.width, height:thickness)
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
    
    @IBAction func signin_btnAction(_ sender: UIButton)
    {
        if Constant.isValidEmail(testStr: email_txt.text!) == false{
            print("Validate EmailID")
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter valide EmailID")
        }
        else if(password_txt.text!.isEmpty)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter valide Password")
        }
        else
        {
            Auth.auth().signIn(withEmail: email_txt.text!, password: password_txt.text!) {
                [weak self] user, error in
                guard self != nil else { return }
                                let user = Auth.auth().currentUser
                                                print(user!)
                                user?.getIDTokenForcingRefresh(true) { idToken, error in
                                    if error != nil {
                                    // Handle error
                                    return;
                                  }
                print(idToken!)
                                    UserDefaults.standard.set(idToken, forKey: "idtoken")
//                                  // Send token to your backend via HTTPS
//                                  // ...
//                                    self?.JsonParsing()

                                }
//                                                let uid = user?.uid
//                                                print(uid!)
//                                UserDefaults.standard.set(uid, forKey: "uid")
            }
        }
        
    }
    @IBAction func gotoforgot(_ sender: UIButton)
       {
           let objSigninvc: ForgotVC = (self.storyboard?.instantiateViewController(identifier: "forgot"))!
              self.navigationController?.pushViewController(objSigninvc, animated: true)
       }
}
