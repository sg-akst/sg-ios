//
//  UsernameEditVC.swift
//  SportsGravy
//
//  Created by CSS on 22/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import STPopup
import Crashlytics

protocol UsernameEditDelegate: AnyObject {
    func usernameupdateSuccess()

}

class UsernameEditVC: UIViewController, UITextFieldDelegate,PopViewDelegate {
    func selectoptionString(selectSuffix: String) {
        self.suffix_name_txt.text = selectSuffix
        if(self.suffix_name_txt.text == userDetailDic.value(forKey: "suffix") as? String)
               {
                   update_btn.isUserInteractionEnabled = false
                   update_btn.setTitleColor(UIColor.darkGray, for: .normal)
               }
               else
               {
                   update_btn.isUserInteractionEnabled = true
                   update_btn.setTitleColor(UIColor.blue, for: .normal)
               }
    }
    
    @IBOutlet weak var first_name_txt: UITextField!
    @IBOutlet weak var middle_name_txt: UITextField!
    @IBOutlet weak var last_name_txt: UITextField!
    @IBOutlet weak var suffix_name_txt: UITextField!
    @IBOutlet weak var update_btn: UIButton!
    weak var delegate:UsernameEditDelegate?
    var userDetailDic: NSDictionary!
    var isUpdateName: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        first_name_txt.delegate = self
        middle_name_txt.delegate = self
        last_name_txt.delegate = self
        suffix_name_txt.delegate = self
        
        bottomlineMethod(selecttext: first_name_txt)
        bottomlineMethod(selecttext: middle_name_txt)
        bottomlineMethod(selecttext: last_name_txt)
        bottomlineMethod(selecttext: suffix_name_txt)
        self.first_name_txt.text = userDetailDic.value(forKey: "first_name") as? String
        self.middle_name_txt.text = userDetailDic.value(forKey: "middle_initial") as? String
        self.last_name_txt.text = userDetailDic.value(forKey: "last_name") as? String
        self.suffix_name_txt.text = userDetailDic.value(forKey: "suffix") as? String
    
        
        
    }
    func bottomlineMethod(selecttext: UITextField)
    {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -10.0, y: selecttext.frame.height - 1, width: self.view.frame.width, height: 1.0)
        bottomLine.backgroundColor = Constant.getUIColor(hex: "#EEEEEE")?.cgColor //UIColor.lightGray.cgColor
        selecttext.borderStyle = UITextBorderStyle.none
        selecttext.layer.addSublayer(bottomLine)
    }
    
    @IBAction func selectsuffix(_ sender: UIButton)
    {
        //Crashlytics.sharedInstance().crash()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pop") as! PopVC
        vc.Title = "Select Suffix"
        vc.suffixArray = ["Jr","Sr","II","III","IV","V"]
        vc.delegate = self
        vc.contentSizeInPopup = CGSize(width: self.view.frame.size.width, height: 345.0)
        let popup = STPopupController(rootViewController: vc)
        popup.containerView.layer.cornerRadius = 4;
        popup.navigationBarHidden = true
        popup.style = .bottomSheet
        popup.present(in: self)
    }
    @IBAction func usernameUpdate(_ sender: UIButton)
    {
        //Crashlytics.sharedInstance().crash()
        if(self.first_name_txt.text == nil || self.first_name_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Firstname ")
        }
       else if(self.middle_name_txt.text == nil || self.middle_name_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Middlename")
        }
      else if(self.last_name_txt.text == nil || self.last_name_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Lastname")
        }
      else if(self.suffix_name_txt.text == nil || self.suffix_name_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Select Suffix ")
        }
      else
        {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
            let updatePage = (isUpdateName == true) ? getuuid : userDetailDic.value(forKey: "user_id") as? String
        let db = Firestore.firestore()
        db.collection("users").document("\(updatePage!)").updateData(["first_name": "\(first_name_txt.text!)", "middle_initial" : "\(middle_name_txt.text!)", "last_name" : "\(last_name_txt.text!)", "suffix" : "\(suffix_name_txt.text!)"])
        { err in
            Constant.showInActivityIndicatory()

            if let err = err {
                print("Error updating document: \(err)")
                Constant.showInActivityIndicatory()

            } else {
                print("Document successfully updated")
                Constant.showInActivityIndicatory()
                self.alertermsg(msg: "Suffix Update Successfully")

            }
        }
    }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            print("textFieldShouldBeginEditing")
            return true
        }
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //if(userDetailDic.value(forKey: "first_name") as? String == textField.text || userDetailDic.value(forKey: "middle_initial") as? String == textField.text || userDetailDic.value(forKey: "last_name") as? String == textField.text)
        if(string == "")
           {
              update_btn.isUserInteractionEnabled = false
               update_btn.setTitleColor(UIColor.darkGray, for: .normal)
           }
           else
           {
               update_btn.isUserInteractionEnabled = true
               update_btn.setTitleColor(UIColor.blue, for: .normal)
           }
            
            return true
        }
       
      
       func textFieldDidEndEditing(_ textField: UITextField) {
            print("textFieldDidEndEditing")
           print("textField = \(textField.text ?? "")")
            print("Leaving textFieldDidEndEditing")
        }
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {

           
           return true
       }
       func textFieldDidBeginEditing(_ textField: UITextField) {
          
       }

       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
           return true
       }
       
    
    func alertermsg(msg: String)
    {
        let alert = UIAlertController(title: "SportsGravy", message: msg.capitalized, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
        self.delegate?.usernameupdateSuccess()
        self.navigationController?.popViewController(animated: true)

               }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func Editusercancelbtn(_ sender: UIButton)
    {
        //Crashlytics.sharedInstance().crash()
       self.navigationController?.popViewController(animated: true)
    }
}
