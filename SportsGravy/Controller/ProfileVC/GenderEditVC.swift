//
//  GenderEditVC.swift
//  SportsGravy
//
//  Created by CSS on 22/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase
import STPopup

protocol genderEditDelegate: AnyObject {
    func genderupdateSuccess()

}


class GenderEditVC: UIViewController,UITextFieldDelegate,PopViewDelegate {
    func selectoptionString(selectSuffix: String) {
        self.gender_txt.text = selectSuffix
        if(self.gender_txt.text == getalldoc.value(forKey: "gender") as? String)
        {
            update_gender_btn.isUserInteractionEnabled = false
            update_gender_btn.setTitleColor(UIColor.darkGray, for: .normal)
        }
        else
        {
            update_gender_btn.isUserInteractionEnabled = true
            update_gender_btn.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    

    @IBOutlet weak var gender_txt: UITextField!
    @IBOutlet weak var update_gender_btn: UIButton!

    var getalldoc: NSDictionary!
    weak var delegate:genderEditDelegate?
    var isUpdateGender: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        gender_txt.delegate = self
        bottomlineMethod(selecttext: gender_txt)
        gender_txt.text = getalldoc.value(forKey: "gender") as? String
        
    }
    func bottomlineMethod(selecttext: UITextField)
    {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -10.0, y: selecttext.frame.height - 1, width: self.view.frame.width, height: 1.0)
        bottomLine.backgroundColor = Constant.getUIColor(hex: "#EEEEEE")?.cgColor
        selecttext.borderStyle = UITextBorderStyle.none
        selecttext.layer.addSublayer(bottomLine)
    }
    
    
    @IBAction func selectGender(_ sender: UIButton)
       {
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "pop") as! PopVC
           vc.Title = "Select Gender"
           vc.suffixArray = ["Male","Female","Other"]
           vc.delegate = self
        vc.contentSizeInPopup = CGSize(width: self.view.frame.size.width, height: 195.0)
           let popup = STPopupController(rootViewController: vc)
           popup.containerView.layer.cornerRadius = 4;
           popup.navigationBarHidden = true
           popup.style = .bottomSheet
           popup.present(in: self)
       }
    
    @IBAction func genderUpdate(_ sender: UIButton)
    {
        if(gender_txt.text == nil || gender_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Select Gender")

        }
        else
        {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
        let updatePage = (isUpdateGender == true) ? getuuid : self.getalldoc.value(forKey: "user_id") as? String
        db.collection("users").document("\(updatePage!)").updateData(["gender": "\(gender_txt.text!)"])
        { err in
            Constant.showInActivityIndicatory()

            if let err = err {
                print("Error updating document: \(err)")
               // Constant.showInActivityIndicatory()

            } else {
                print("Document successfully updated")
               // Constant.showInActivityIndicatory()
                self.alertermsg(msg: "Gender Updated Successfully")
            }
        }
        }
    }
    func alertermsg(msg: String)
        {
            let alert = UIAlertController(title: "SportsGravy", message: msg.capitalized, preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
            self.delegate?.genderupdateSuccess()
            self.navigationController?.popViewController(animated: true)
                   }))
            self.present(alert, animated: true, completion: nil)
        }
    @IBAction func EditGendercancelbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }

}
