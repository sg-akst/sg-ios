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
import SWRevealViewController

class SigninVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoview: UIView!
    @IBOutlet weak var email_txt: UITextField!
    @IBOutlet weak var password_txt: UITextField!
    var revealController: SWRevealViewController!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.bordermethod(setborder: email_txt)
        self.bordermethod(setborder: password_txt)
        self.email_txt.delegate = self
        self.password_txt.delegate = self
        revealController = SWRevealViewController()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        logoHeight.constant = self.view.frame.size.height/2
       
    }
    func bordermethod(setborder: UITextField)
    {
        let thickness: CGFloat = 0.5

        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: setborder.frame.size.height - thickness, width: self.view.frame.size.width - 30, height:thickness)
        bottomBorder.backgroundColor =  Constant.getUIColor(hex: "#C0CCDA")?.cgColor
        setborder.layer.addSublayer(bottomBorder)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         print("textFieldShouldReturn")
         textField.resignFirstResponder()
         return true
     }

    func textFieldDidBeginEditing(_ textField: UITextField) {
         
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
          return false
      }
    
    @IBAction func signin_btnAction(_ sender: UIButton)
    {
        if(email_txt.text!.isEmpty)
        {
          Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter valid email address")
        }
      else if Constant.isValidEmail(testStr: email_txt.text!) == false{
            print("Validate EmailID")
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter valid email address")
        }
        else if(password_txt.text!.isEmpty)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter Password")
        }
        else if(password_txt.text!.count < 5)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Invalid username or Password please try again")

        }
            
        else
        {
           
            Constant.internetconnection(vc: self)
            Constant.showActivityIndicatory(uiView: self.view)
            Auth.auth().signIn(withEmail: email_txt.text!, password: password_txt.text!) {
                [weak self] user, error in
                guard self != nil else { return }
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    Constant.showInActivityIndicatory()

                    if error != nil {
                                    // Handle error
                                    return;
                                  }
                                    print("Token=>\(idToken!)")
                                    UserDefaults.standard.set(idToken, forKey: "idtoken")
                                }
                
                UserDefaults.standard.removeObject(forKey: "UUID")
                let userUUID = Auth.auth().currentUser?.uid
                if(userUUID != nil)
                {
                    print(userUUID!)

                UserDefaults.standard.set(userUUID, forKey: "UUID")
                Constant.showInActivityIndicatory()
                let swrvc: SWRevealViewController = (self?.storyboard?.instantiateViewController(identifier: "revealvc"))!
                self?.navigationController?.pushViewController(swrvc, animated: true)
                    Constant.showInActivityIndicatory()
            }
            else
            {
                Constant.showAlertMessage(vc: self!, titleStr: "SportsGravy", messageStr: "Invalid username or Password please try again")
                Constant.showInActivityIndicatory()

            }
                 

            }
        }
        
    }
    @IBAction func gotoforgot(_ sender: UIButton)
       {
           let objSigninvc: ForgotVC = (self.storyboard?.instantiateViewController(identifier: "forgot"))!
              self.navigationController?.pushViewController(objSigninvc, animated: true)
       }
    
    
   
}
