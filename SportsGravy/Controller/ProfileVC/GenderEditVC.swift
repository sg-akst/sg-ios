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
    }
    

    @IBOutlet weak var gender_txt: UITextField!
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
        bottomLine.frame = CGRect(x: 0.0, y: selecttext.frame.height - 1, width: self.view.frame.width-40, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
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
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please select Gender")

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
            if let err = err {
                print("Error updating document: \(err)")
                Constant.showInActivityIndicatory()

            } else {
                print("Document successfully updated")
                Constant.showInActivityIndicatory()
                self.alertermsg(msg: "Gender successfully updated")
            }
        }
        }
    }
    func alertermsg(msg: String)
        {
            let alert = UIAlertController(title: "SportsGravy", message: msg, preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
            self.delegate?.genderupdateSuccess()
            self.navigationController?.popViewController(animated: true)

                   }))
    //        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { _ in
    //         }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    
        
    @IBAction func EditGendercancelbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }

}
