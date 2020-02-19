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


class AddressEditVC: UIViewController,PopViewDelegate {
    func selectoptionString(selectSuffix: String) {
        if(isSlectState == true)
        {
            self.state_txt.text = selectSuffix
            isSlectState = false
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
        }
    }
    
    
    @IBOutlet weak var street1_txt: UITextField!
    @IBOutlet weak var street2_txt: UITextField!
    @IBOutlet weak var city_txt: UITextField!
    @IBOutlet weak var state_txt: UITextField!
    @IBOutlet weak var potel_txt: UITextField!
    @IBOutlet weak var country_txt: UITextField!

    var addressDetailDic: NSDictionary!
    var getCountryArray: NSMutableArray!
    var getStateArray: NSMutableArray!
    var isSlectState: Bool!
    var updateAddress: NSDictionary!
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
        updateAddress = self.addressDetailDic.value(forKey: "address") as? NSDictionary
        self.street1_txt.text = updateAddress.value(forKey: "street1") as? String
        self.street2_txt.text = updateAddress.value(forKey: "street2") as? String
        self.city_txt.text    = updateAddress.value(forKey: "city") as? String
        self.state_txt.text = updateAddress.value(forKey: "state") as? String
        self.potel_txt.text = updateAddress.value(forKey: "postal_code") as? String
        self.country_txt.text = updateAddress.value(forKey: "country_code") as? String
        getstateDetails()
       
    }
    func bottomlineMethod(selecttext: UITextField)
    {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -10.0, y: selecttext.frame.height - 1, width: self.view.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
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
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
                self.getCountryArray = NSMutableArray()

                for document in querySnapshot!.documents {
                let data: NSDictionary = document.data() as NSDictionary
                self.getCountryArray.add(data)
               }
            Constant.showInActivityIndicatory()

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
    
    @IBAction func updateAddress(_ sender: UIButton)
    {
        if(self.street1_txt.text == nil || self.street1_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter address")

        }
//        else if(self.street2_txt.text == nil || self.street2_txt.text?.isEmpty == true)
//        {
//            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter address")
//
//        }
        else if(self.city_txt.text == nil || self.city_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter city")

        }
        else if(self.potel_txt.text == nil || self.potel_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter potelcode")

        }
        else if(self.state_txt.text == nil || self.state_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please select state")

        }
        else if(self.country_txt.text == nil || self.country_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please select country")

        }
        else
        {
            Constant.internetconnection(vc: self)
            Constant.showActivityIndicatory(uiView: self.view)
            
            
            
            let getuuid = UserDefaults.standard.string(forKey: "UUID")
            
            let db = Firestore.firestore()
            self.updateAddress.setValue(self.street1_txt.text!, forKey: "street1")
            self.updateAddress.setValue(self.street2_txt.text!, forKey: "street2")
            updateAddress.setValue(self.city_txt.text!, forKey: "city")
            updateAddress.setValue(self.potel_txt.text!, forKey: "postal_code")
            updateAddress.setValue(self.state_txt.text!, forKey: "state")
            updateAddress.setValue(self.country_txt.text!, forKey: "country_code")
           
            let updatePage = (isUpdate == true) ? getuuid : self.addressDetailDic.value(forKey: "user_id") as? String
            db.collection("users").document("\(updatePage!)").updateData(["street1":"\(self.street1_txt.text!)","street2": "\(self.street2_txt.text!)","city": "\(self.city_txt.text!)","postal_code": "\(self.potel_txt.text!)","state": "\(self.state_txt.text!)","country_code": "\(self.country_txt.text!)","address": self.updateAddress, "updated_datetime" : Date()])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    Constant.showInActivityIndicatory()

                } else {
                    print("Document successfully updated")
                    Constant.showInActivityIndicatory()
                    self.alertermsg(msg: "Address updated successfully")

                    
                }
            }
        }
    }
    func alertermsg(msg: String)
    {
        let alert = UIAlertController(title: "SportsGravy", message: msg, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
            self.delegate?.addressupdateSuccess()
        self.navigationController?.popViewController(animated: true)

        }))
       //        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { _ in
       //         }))
               
               self.present(alert, animated: true, completion: nil)
               
           }
       
    
    @IBAction func EditAddresscancelbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }
}
