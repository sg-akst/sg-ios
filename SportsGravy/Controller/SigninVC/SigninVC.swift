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
    }
    func bordermethod(setborder: UITextField)
    {
        let thickness: CGFloat = 1.0

        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: setborder.frame.size.height - thickness, width: self.view.frame.size.width - 30, height:thickness)
        bottomBorder.backgroundColor =  UIColor.lightGray.cgColor
        setborder.layer.addSublayer(bottomBorder)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         print("textFieldShouldReturn")
         textField.resignFirstResponder()
         return true
     }

//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//         return true
//     }

    func textFieldDidBeginEditing(_ textField: UITextField) {
         
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
           
            Constant.internetconnection(vc: self)
            Constant.showActivityIndicatory(uiView: self.view)
            Auth.auth().signIn(withEmail: email_txt.text!, password: password_txt.text!) {
                [weak self] user, error in
                guard self != nil else { return }
                               // let user = Auth.auth().currentUser
                let userUUID = Auth.auth().currentUser?.uid
                print(userUUID!)
                
                UserDefaults.standard.set(userUUID, forKey: "UUID")
                                    Constant.showInActivityIndicatory()


                                    let swrvc: SWRevealViewController = (self?.storyboard?.instantiateViewController(identifier: "revealvc"))!
                                    self?.navigationController?.pushViewController(swrvc, animated: true)


                               // }

            }
        }
        
    }
    @IBAction func gotoforgot(_ sender: UIButton)
       {
           let objSigninvc: ForgotVC = (self.storyboard?.instantiateViewController(identifier: "forgot"))!
              self.navigationController?.pushViewController(objSigninvc, animated: true)
       }
    
    
   
}
