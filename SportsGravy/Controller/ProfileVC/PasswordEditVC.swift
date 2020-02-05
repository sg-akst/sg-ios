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
        bottomLine.frame = CGRect(x: 0.0, y: selecttext.frame.height - 1, width: self.view.frame.width-20, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        selecttext.borderStyle = UITextBorderStyle.none
        selecttext.layer.addSublayer(bottomLine)
    }
    @IBAction func passwordUpdate(_ sender: UIButton)
    {
        if(self.oldpw_txt.text == nil || self.oldpw_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter old password ")

        }
        else if(self.newpw_txt.text == nil || self.newpw_txt.text?.isEmpty == true || self.newpw_txt.text!.count < 5)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter new password ")

        }
        else if(self.newpw_txt.text != self.confirmpw_txt.text)
        {
              Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please check new password")
        }
        else
        {
             Constant.internetconnection(vc: self)
            Constant.showActivityIndicatory(uiView: self.view)
            let credential = EmailAuthProvider.credential(withEmail: self.getAllDic.value(forKey: "email_address") as! String, password: self.oldpw_txt.text!)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                if error != nil {
                    //completion(error)
                    print(error!)
                     Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "please enter vaild oldpassword")
                   Constant.showInActivityIndicatory()

                }
                else {
                    Auth.auth().currentUser?.updatePassword(to: self.newpw_txt.text!, completion: { (error) in
                        //completion(error)
                        Constant.showInActivityIndicatory()
                        //Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Password successfully updated")
                       // self.navigationController?.popViewController(animated: true)
                        self.alertermsg(msg: "Password successfully updated")
                    })
                }
            })
        }

    }
    
    func alertermsg(msg: String)
    {
        let alert = UIAlertController(title: "SportsGravy", message: msg, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
//        self.delegate?.usernameupdateSuccess()
        self.navigationController?.popViewController(animated: true)

               }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
   
    @IBAction func EditPasswordcancelbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }

}
