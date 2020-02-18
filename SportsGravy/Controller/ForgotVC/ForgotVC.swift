//
//  ForgotVC.swift
//  SportsGravy
//
//  Created by CSS on 03/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase

class ForgotVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var logoview: UIView!
    @IBOutlet weak var email_txt: UITextField!
    @IBOutlet weak var logoviewheight:NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.bordermethod(setborder: email_txt)
        self.email_txt.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
        logoviewheight.constant = self.view.frame.size.height/2
       }
    func bordermethod(setborder: UITextField)
    {
        let thickness: CGFloat = 1.0

        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: setborder.frame.size.height - thickness, width: self.view.frame.size.width - 30, height:thickness)
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
        if(email_txt.text!.isEmpty)
        {
            Constant.showAlertMessage(vc: self, titleStr: "Sports Gravy", messageStr: "Please enter valid email address")

        }
        else if Constant.isValidEmail(testStr: email_txt.text!) == false{
            print("Validate EmailID")
            Constant.showAlertMessage(vc: self, titleStr: "Sports Gravy", messageStr: "Please enter valid email address")
        }
        else
        {
            self.sendPasswordReset(withEmail: email_txt.text!)
        }
    }
   
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){

        Constant.showActivityIndicatory(uiView: self.view)
               Auth.auth().sendPasswordReset(withEmail: email) { error in
                   callback?(error)
                
                self.showAlertMessage(titleStr: "Sports Gravy", messageStr: "Please check your Email")
                Constant.showInActivityIndicatory()

               }
           }
    func showAlertMessage(titleStr:String, messageStr:String) -> Void {
           let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
           alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
            let objSigninvc: SigninVC = (self.storyboard?.instantiateViewController(identifier: "Signin_page"))!
                self.navigationController?.pushViewController(objSigninvc, animated: true)
                  }))
           
           self.present(alert, animated: true, completion: nil)
       }
}
