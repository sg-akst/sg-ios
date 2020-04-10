//
//  AddressEditVC.swift
//  SportsGravy
//
//  Created by CSS on 22/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import STPopup

protocol addressEditDelegate: AnyObject {
    func addressupdateSuccess()

}


class AddressEditVC: UIViewController,PopViewDelegate, UITextFieldDelegate {
    func selectoptionString(selectSuffix: String) {
        if(isSlectState == true)
        {
            self.state_txt.text = selectSuffix
            isSlectState = false
            if(self.state_txt.text == self.addressDetailDic.value(forKey: "state") as? String)
            {
                update_address_btn.isUserInteractionEnabled = false
                update_address_btn.setTitleColor(UIColor.darkGray, for: .normal)
            }
            else
            {
                update_address_btn.isUserInteractionEnabled = true
                update_address_btn.setTitleColor(UIColor.blue, for: .normal)
            }
        }
        else
        {
            for i in 0..<self.getCountryArray.count
            {
                let dic: NSDictionary = self.getCountryArray?[i] as! NSDictionary
                if(dic.value(forKey: "name") as! String == selectSuffix)
                {
                    self.country_txt.text = dic.value(forKey: "country_code") as? String

                }
            }
            if(self.country_txt.text == addressDetailDic.value(forKey: "country_code") as? String)
            {
                update_address_btn.isUserInteractionEnabled = false
                update_address_btn.setTitleColor(UIColor.darkGray, for: .normal)
            }
            else
            {
                update_address_btn.isUserInteractionEnabled = true
                update_address_btn.setTitleColor(UIColor.blue, for: .normal)
            }
        }
    }
    
    
    @IBOutlet weak var street1_txt: UITextField!
    @IBOutlet weak var street2_txt: UITextField!
    @IBOutlet weak var city_txt: UITextField!
    @IBOutlet weak var state_txt: UITextField!
    @IBOutlet weak var potel_txt: UITextField!
    @IBOutlet weak var country_txt: UITextField!
    @IBOutlet weak var update_address_btn: UIButton!


    var addressDetailDic: NSDictionary!
    var getCountryArray: NSMutableArray!
    var getStateArray: NSMutableArray!
    var isSlectState: Bool!
    //var updateAddress: NSDictionary!
    weak var delegate:addressEditDelegate?
    var isUpdate: Bool!


    override func viewDidLoad() {
        super.viewDidLoad()
        bottomlineMethod(selecttext: street1_txt)
        bottomlineMethod(selecttext: street2_txt)
        bottomlineMethod(selecttext: city_txt)
        bottomlineMethod(selecttext: state_txt)
        bottomlineMethod(selecttext: potel_txt)
        bottomlineMethod(selecttext: country_txt)
        self.state_txt.delegate = self
        self.street1_txt.delegate = self
        self.street2_txt.delegate = self
        self.city_txt.delegate = self
        self.country_txt.delegate = self
        self.potel_txt.delegate = self
       // updateAddress = self.addressDetailDic.value(forKey: "address") as? NSDictionary
        self.street1_txt.text = self.addressDetailDic.value(forKey: "street1") as? String
        self.street2_txt.text = self.addressDetailDic.value(forKey: "street2") as? String
        self.city_txt.text    = self.addressDetailDic.value(forKey: "city") as? String
        self.state_txt.text = self.addressDetailDic.value(forKey: "state") as? String
        self.potel_txt.text = self.addressDetailDic.value(forKey: "postal_code") as? String
        self.country_txt.text = self.addressDetailDic.value(forKey: "country_code") as? String
        getstateDetails()
       
    }
    func bottomlineMethod(selecttext: UITextField)
    {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -10.0, y: selecttext.frame.height - 1, width: self.view.frame.width, height: 1.0)
        bottomLine.backgroundColor = Constant.getUIColor(hex: "#EEEEEE")?.cgColor
        selecttext.borderStyle = UITextBorderStyle.none
        selecttext.layer.addSublayer(bottomLine)
    }
    func getcountryDetails()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let db = Firestore.firestore()
        //let docRef = db.collection("countries").document()
        db.collection("countries").getDocuments() { (querySnapshot, err) in
            Constant.showInActivityIndicatory()

        if let err = err {
            print("Error getting documents: \(err)")
        } else {
                self.getCountryArray = NSMutableArray()

                for document in querySnapshot!.documents {
                let data: NSDictionary = document.data() as NSDictionary
                self.getCountryArray.add(data)
               }
           // Constant.showInActivityIndicatory()

                }
            }
        
    }
    func getstateDetails()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let db = Firestore.firestore()
       // let docRef = db.collection("states").document()
        db.collection("states").getDocuments() { (querySnapshot, err) in
            Constant.showInActivityIndicatory()

        if let err = err {
            print("Error getting documents: \(err)")
        } else {
                self.getStateArray = NSMutableArray()

                for document in querySnapshot!.documents {
                let data: NSDictionary = document.data() as NSDictionary
                self.getStateArray.add(data)
                Constant.showInActivityIndicatory()
                self.getcountryDetails()

               }
            //Constant.showInActivityIndicatory()

                }
            }
    }
    @IBAction func selectState(_ sender: UIButton)
    {
        isSlectState = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pop") as! PopVC
        vc.Title = "Select State"
        let filteredEvents: [String] = self.getStateArray.value(forKeyPath: "@distinctUnionOfObjects.name") as! [String]
        
        let popviewheight : Float = Float(self.getStateArray.count * 45) + 60
        vc.suffixArray = filteredEvents
        vc.delegate = self
        vc.contentSizeInPopup = CGSize(width: self.view.frame.size.width, height: CGFloat(popviewheight))
        let popup = STPopupController(rootViewController: vc)
        popup.containerView.layer.cornerRadius = 4;
        popup.navigationBarHidden = true
        popup.style = .bottomSheet
        popup.present(in: self)
    }
    @IBAction func selectCountryCode(_ sender: UIButton)
    {
        isSlectState = false
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pop") as! PopVC
        vc.Title = "Select Country"
        let filteredEvents: [String] = self.getCountryArray.value(forKeyPath: "@distinctUnionOfObjects.name") as! [String]
        let popviewheight : Float = Float(self.getCountryArray.count * 45) + 60

        vc.suffixArray = filteredEvents
        vc.delegate = self
        vc.contentSizeInPopup = CGSize(width: self.view.frame.size.width, height: CGFloat(popviewheight))
        let popup = STPopupController(rootViewController: vc)
        popup.containerView.layer.cornerRadius = 4;
        popup.navigationBarHidden = true
        popup.style = .bottomSheet
        popup.present(in: self)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
          print("textFieldShouldBeginEditing")
          return true
      }
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       //let newString = (string as NSString).replacingCharacters(in: range, with: string)
        //textField.text = string


       // if(textField.text == addressDetailDic.value(forKey: "street1") as? String || textField.text == addressDetailDic.value(forKey: "street2") as? String || textField.text == addressDetailDic.value(forKey: "city")as? String || textField.text == addressDetailDic.value(forKey: "postal_code")as? String)
          if (string == "")
         {
            update_address_btn.isUserInteractionEnabled = false
            update_address_btn.setTitleColor(UIColor.darkGray, for: .normal)
         }
         else
         {
             update_address_btn.isUserInteractionEnabled = true
             update_address_btn.setTitleColor(UIColor.blue, for: .normal)
         }
       
          return true
      }
     
    
     func textFieldDidEndEditing(_ textField: UITextField) {
          print("textFieldDidEndEditing")
         print("textField = \(textField.text ?? "")")
          print("Leaving textFieldDidEndEditing")
      }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

         return true
     }
     func textFieldDidBeginEditing(_ textField: UITextField) {
        
     }

     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //delegate method
        textField.resignFirstResponder()
         return true
     }
    @IBAction func updateAddress(_ sender: UIButton)
    {
         
        if(self.street1_txt.text == nil || self.street1_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Address")

        }
        else if(self.city_txt.text == nil || self.city_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter City")

        }
        else if(self.potel_txt.text == nil || self.potel_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Potelcode")

        }
        else if(self.state_txt.text == nil || self.state_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Select State")

        }
        else if(self.country_txt.text == nil || self.country_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Select Country")

        }
        else
        {
            Constant.internetconnection(vc: self)
            Constant.showActivityIndicatory(uiView: self.view)
            let getuuid = UserDefaults.standard.string(forKey: "UUID")
            let db = Firestore.firestore()
            let updateAdd: NSMutableDictionary = NSMutableDictionary()
            
            updateAdd.setValue(self.street1_txt.text!, forKey: "street1")
            updateAdd.setValue(self.street2_txt.text!, forKey: "street2")
            updateAdd.setValue(self.city_txt.text!, forKey: "city")
            updateAdd.setValue(self.potel_txt.text!, forKey: "postal_code")
            updateAdd.setValue(self.state_txt.text!, forKey: "state")
            updateAdd.setValue(self.country_txt.text!, forKey: "country_code")
           
            let updatePage = (isUpdate == true) ? getuuid : self.addressDetailDic.value(forKey: "user_id") as? String
            db.collection("users").document("\(updatePage!)").updateData(["street1":"\(self.street1_txt.text!)","street2": "\(self.street2_txt.text!)","city": "\(self.city_txt.text!)","postal_code": "\(self.potel_txt.text!)","state": "\(self.state_txt.text!)","country_code": "\(self.country_txt.text!)","address": updateAdd.copy(), "updated_datetime" : Date()])
            { err in
                Constant.showInActivityIndicatory()

                if let err = err {
                    print("Error updating document: \(err)")
                   // Constant.showInActivityIndicatory()

                } else {
                    print("Document successfully updated")
                   // Constant.showInActivityIndicatory()
                    self.alertermsg(msg: "Address Updated Successfully")

                    
                }
            }
        }
    }
    func alertermsg(msg: String)
    {
        let alert = UIAlertController(title: "SportsGravy", message: msg.capitalized, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
            self.delegate?.addressupdateSuccess()
        self.navigationController?.popViewController(animated: true)

        }))
               self.present(alert, animated: true, completion: nil)
               
           }
       
    
    @IBAction func EditAddresscancelbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }
}
