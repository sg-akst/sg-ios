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

class UsernameEditVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var first_name_txt: UITextField!
    @IBOutlet weak var middle_name_txt: UITextField!
    @IBOutlet weak var last_name_txt: UITextField!
    @IBOutlet weak var suffix_name_txt: UITextField!
    @IBOutlet weak var suffix_tbl: UITableView!
    @IBOutlet weak var suffix_view: UIView!


    var userDetailDic: NSDictionary!
    var isSuffix: Bool!
    var suffixArray: [String] = ["Jr","Sr","II","III","IV","V"]

    override func viewDidLoad() {
        super.viewDidLoad()
        first_name_txt.delegate = self
        middle_name_txt.delegate = self
        last_name_txt.delegate = self
        suffix_name_txt.delegate = self
        suffix_tbl.delegate = self
        suffix_tbl.dataSource = self
        bottomlineMethod(selecttext: first_name_txt)
        bottomlineMethod(selecttext: middle_name_txt)
        bottomlineMethod(selecttext: last_name_txt)
        bottomlineMethod(selecttext: suffix_name_txt)
        self.first_name_txt.text = userDetailDic.value(forKey: "first_name") as? String
        self.middle_name_txt.text = userDetailDic.value(forKey: "middle_initial") as? String
        self.last_name_txt.text = userDetailDic.value(forKey: "last_name") as? String
        self.suffix_name_txt.text = userDetailDic.value(forKey: "suffix") as? String
        suffix_view.layer.cornerRadius = 5
        suffix_view.layer.borderColor = UIColor.lightGray.cgColor
        suffix_view.layer.borderWidth = 1
        suffix_view.layer.masksToBounds = true
        suffix_view.isHidden = true
        isSuffix = false
        
        
    }
    func bottomlineMethod(selecttext: UITextField)
    {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: selecttext.frame.height - 1, width: self.view.frame.width-40, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        selecttext.borderStyle = UITextBorderStyle.none
        selecttext.layer.addSublayer(bottomLine)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.suffixArray.count
              }
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

           return 40.0
       }

              // create a cell for each table view row
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.suffix_tbl.dequeueReusableCell(withIdentifier: "usercell")!
        cell.textLabel?.text = self.suffixArray[indexPath.row]
           return cell
           }

              // method to run when table view cell is tapped
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                  print("You tapped cell number \(indexPath.row).")
        self.suffix_name_txt.text = self.suffixArray[indexPath.row]
        suffix_view.isHidden = true
        isSuffix = false
           }
    
    
    @IBAction func selectsuffix(_ sender: UIButton)
    {
        if(isSuffix == false)
        {
            self.suffix_view.isHidden = false
            isSuffix = true
        }
        else
        {
            self.suffix_view.isHidden = true
            isSuffix = false
        }
    }
    @IBAction func cancel(_ sender: UIButton)
    {
        self.suffix_view.isHidden = true
        isSuffix = false
    }
    @IBAction func usernameUpdate(_ sender: UIButton)
    {
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
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter lastname")
        }
      else if(self.suffix_name_txt.text == nil || self.suffix_name_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please select suffix ")
        }
      else
        {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
        db.collection("users").document("\(getuuid!)").updateData(["first_name": "\(first_name_txt.text!)", "middle_initial" : "\(middle_name_txt.text!)", "last_name" : "\(last_name_txt.text!)", "suffix" : "\(suffix_name_txt.text!)"])
        { err in
            if let err = err {
                print("Error updating document: \(err)")
                Constant.showInActivityIndicatory()

            } else {
                print("Document successfully updated")
                Constant.showInActivityIndicatory()
                Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Suffix Update Successfully")
            }
        }
    }
    }
    
    @IBAction func Editusercancelbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }
}
