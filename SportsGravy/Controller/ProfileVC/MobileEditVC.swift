//
//  MobileEditVC.swift
//  SportsGravy
//
//  Created by CSS on 22/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase

protocol mobileEditDelegate: AnyObject {
    func mobileupdateSuccess()

}

class MobileEditVC: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var mobile_txt: UITextField!
    var getAllDic: NSDictionary!
    weak var delegate:mobileEditDelegate?
    var isUpdatePage: Bool!


    override func viewDidLoad() {
        super.viewDidLoad()
        mobile_txt.delegate = self
        bottomlineMethod(selecttext: mobile_txt)
        mobile_txt.text = self.getAllDic.value(forKey: "mobile_phone") as? String

    }
    func bottomlineMethod(selecttext: UITextField)
    {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -10.0, y: selecttext.frame.height - 1, width: self.view.frame.width, height: 1.0)
        bottomLine.backgroundColor = Constant.getUIColor(hex: "#EEEEEE")?.cgColor
        selecttext.borderStyle = UITextBorderStyle.none
        selecttext.layer.addSublayer(bottomLine)
    }
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
           let newString = (text as NSString).replacingCharacters(in: range, with: string)
           textField.text = formattedNumber(number: newString)
           return false
      }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text != "" && text != "+1 (XXX) XXX-XXXX" {
            // Do something with your value
        } else {
            textField.text = ""
        }
    }
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+X (XXX) XXX-XXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    @IBAction func mobileUpdate(_ sender: UIButton)
    {
        if(mobile_txt.text == nil || mobile_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter mobile number")
        }
        else if(isValidMobile(testStr: mobile_txt.text!) == false)
        {
           Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter vaild mobile number")
        }
        else
        {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
            
        let UpdateID = (isUpdatePage == true) ? getuuid : self.getAllDic.value(forKey: "user_id") as? String
            
        db.collection("users").document("\(UpdateID!)").updateData(["mobile_phone": "\(mobile_txt.text!)"])
        { err in
            if let err = err {
                print("Error updating document: \(err)")
                Constant.showInActivityIndicatory()

            } else {
                print("Document successfully updated")
                Constant.showInActivityIndicatory()
                self.alertermsg(msg: "Mobile number Updated successfully")

            }
        }
        }
    }
    func isValidMobile(testStr:String) -> Bool {
        
        let range = NSRange(location: 0, length: testStr.count)
        let regex = try! NSRegularExpression(pattern: "(\\([0-9]{3}\\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}")
        if regex.firstMatch(in: testStr, options: [], range: range) != nil{
            print("Phone number is valid")
            return true
        }else{
            return false
        }
        
//        let mobileRegEx = "(\\([0-9]{3}\\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}"
//        let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
//        return mobileTest.evaluate(with: testStr)
    }
    func alertermsg(msg: String)
        {
            let alert = UIAlertController(title: "SportsGravy", message: msg, preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
            self.delegate?.mobileupdateSuccess()
            self.navigationController?.popViewController(animated: true)

                   }))
    //        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { _ in
    //         }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    @IBAction func EditMobilecancelbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }

}
