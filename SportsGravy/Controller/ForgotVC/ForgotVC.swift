//
//  ForgotVC.swift
//  SportsGravy
//
//  Created by CSS on 03/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class ForgotVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var logoview: UIView!
    @IBOutlet weak var email_txt: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomBorder = CALayer()
               bottomBorder.frame = CGRect(x:0, y: self.logoview.frame.size.height - 0.5, width: self.logoview.frame.size.width, height: 0.5)
                 bottomBorder.backgroundColor = UIColor.gray.cgColor
               logoview.layer.addSublayer(bottomBorder)
        self.bordermethod(setborder: email_txt)
        self.email_txt.delegate = self
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
    @IBAction func gotologin(_ sender: UIButton)
    {
        let objSigninvc: SigninVC = (self.storyboard?.instantiateViewController(identifier: "Signin_page"))!
           self.navigationController?.pushViewController(objSigninvc, animated: true)
    }
    @IBAction func forgotbtn_Action(sender: UIButton)
    {
        if Constant.isValidEmail(testStr: email_txt.text!) == false{
            print("Validate EmailID")
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter valide EmailID")
        }
        else
        {
            
        }
    }
   

}
