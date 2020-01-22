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

class GenderEditVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var gender_txt: UITextField!
    var getalldoc: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        gender_txt.delegate = self
        bottomlineMethod(selecttext: gender_txt)
        gender_txt.text = getalldoc.value(forKey: "gender") as! String
        
    }
    func bottomlineMethod(selecttext: UITextField)
    {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: selecttext.frame.height - 1, width: self.view.frame.width-40, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        selecttext.borderStyle = UITextBorderStyle.none
        selecttext.layer.addSublayer(bottomLine)
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
        db.collection("users").document("\(getuuid!)").updateData(["gender": "\(gender_txt.text!)"])
        { err in
            if let err = err {
                print("Error updating document: \(err)")
                Constant.showInActivityIndicatory()

            } else {
                print("Document successfully updated")
            }
        }
        }
    }
    @IBAction func EditGendercancelbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }

}
