//
//  PersonalInfoVC.swift
//  SportsGravy
//
//  Created by CSS on 30/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import STPopup
import Firebase

class PersonalInfoVC: UIViewController,PopViewDelegate, UITextFieldDelegate {
    func selectoptionString(selectSuffix: String) {
        if(isCountry == true)
        {
            for i in 0..<getCountryArray.count
            {
                let getdetail: NSDictionary = self.getCountryArray?[i] as! NSDictionary
                if(getdetail.value(forKey: "name") as? String == selectSuffix)
                {
                    dialCode = getdetail.value(forKey: "dial_code") as? String
                }
            }
            self.country_txt.text = selectSuffix
        }
        else
        {
        self.suffix_lbl.text = selectSuffix
        }
    }
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var firstname_lbl: UITextField!
    @IBOutlet weak var middlename_lbl: UITextField!
    @IBOutlet weak var lastname_lbl: UITextField!
    @IBOutlet weak var dob_lbl: UITextField!
    @IBOutlet weak var mobile_lbl: UITextField!
    @IBOutlet weak var email_lbl: UITextField!
    @IBOutlet weak var password_lbl: UITextField!
    @IBOutlet weak var confirm_lbl: UITextField!
    @IBOutlet weak var suffix_lbl: UITextField!
    @IBOutlet weak var date_picker_view: UIView!
    @IBOutlet weak var date_done_btn: UIButton!
    @IBOutlet weak var date_picker: UIDatePicker!
    @IBOutlet weak var country_txt: UITextField!
    @IBOutlet weak var scrollview_height: NSLayoutConstraint!
    
    var selectdate: String!
    
    var userdetails: NSDictionary!
    var getCountryArray: NSMutableArray!
    var isCountry: Bool!
    var dialCode: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        firstname_lbl.delegate = self
        lastname_lbl.delegate = self
        middlename_lbl.delegate = self
        dob_lbl.delegate = self
        mobile_lbl.delegate = self
        email_lbl.delegate = self
        password_lbl.delegate = self
        suffix_lbl.delegate = self
        confirm_lbl.delegate = self
        country_txt.delegate = self
        date_picker_view.isHidden = true
        bordermethod(setborder: firstname_lbl)
        bordermethod(setborder: lastname_lbl)
        bordermethod(setborder: middlename_lbl)
        bordermethod(setborder: dob_lbl)
        bordermethod(setborder: mobile_lbl)
        bordermethod(setborder: email_lbl)
        bordermethod(setborder: password_lbl)
        bordermethod(setborder: suffix_lbl)
        bordermethod(setborder: confirm_lbl)
        bordermethod(setborder: country_txt)
        
        self.firstname_lbl.text = self.userdetails.value(forKey: "first_name") as? String
        self.middlename_lbl.text = self.userdetails.value(forKey: "middle_initial") as? String
        self.lastname_lbl.text = self.userdetails.value(forKey: "last_name") as? String
        self.dob_lbl.text = self.userdetails.value(forKey: "date_of_birth") as? String
        self.email_lbl.text = self.userdetails.value(forKey: "email_address") as? String
        self.mobile_lbl.text = self.userdetails.value(forKey: "mobile_number") as? String
        self.password_lbl.text = self.userdetails.value(forKey: "") as? String
        self.suffix_lbl.text = self.userdetails.value(forKey: "suffix") as? String
        self.country_txt.text = self.userdetails.value(forKey: "") as? String
       // scrollview_height.constant = 2000
        getcountryDetails()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }

    func bordermethod(setborder: UITextField)
       {
           let thickness: CGFloat = 1.0

           let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: setborder.frame.size.height - thickness, width: setborder.frame.size.width, height:thickness)
             bottomBorder.backgroundColor = UIColor.lightGray.cgColor
           setborder.layer.addSublayer(bottomBorder)
       }
    @IBAction func CountryCode(_ sender: UIButton)
       {
           isCountry = true
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
    @IBAction func selectprofilesuffix(_ sender: UIButton)
       {
        isCountry = false
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "pop") as! PopVC
           vc.Title = "Select Suffix"
           vc.suffixArray = ["Jr","Sr","II","III","IV","V"]
           vc.delegate = self
        vc.contentSizeInPopup = CGSize(width: self.view.frame.size.width - 20, height: 345.0)
           let popup = STPopupController(rootViewController: vc)
           popup.containerView.layer.cornerRadius = 4;
           popup.navigationBarHidden = true
        popup.style = .bottomSheet
           popup.present(in: self)
       }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
if(textField == self.mobile_lbl)
{
    let newString = (text as NSString).replacingCharacters(in: range, with: string)

    if(country_txt.text != "" && country_txt.text != nil)
    {
        textField.text = formattedNumber(number: newString)
    }
    else
    {
        Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Select Country")
    }
           return false
      }
        else
{
    return true
        }
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text != "" && text != "(XXX) XXX-XXXX" {
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
        let cijfers = "\(number)"
        print("\(cijfers.count)")
        if(cijfers.count == 1)
        {
        let start = cijfers.startIndex;
        let end = cijfers.index(cijfers.startIndex, offsetBy: 1);
           // let countrycode = (self.userdetails.value(forKey: "country_code") as? String == "US") ? "+1" : ""
        result = cijfers.replacingCharacters(in: start..<end, with: "\(dialCode!)")
        print(result)
        }
        return result
    }
    
    @IBAction func nextbtn(_ sender: UIButton)
    {
        if(self.firstname_lbl.text == "" || self.firstname_lbl.text?.isEmpty == true)
        {
        Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Firstname ")

        }
        if(self.lastname_lbl.text == "" || self.lastname_lbl.text?.isEmpty == true)
        {
        Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Lastname ")

        }
        if(self.suffix_lbl.text == "" || self.suffix_lbl.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Select Suffix ")

        }
        
        if(self.dob_lbl.text == "" || self.dob_lbl.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Choose Date Of Birth ")

        }
        if(self.email_lbl.text == "" || self.email_lbl.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Email Address ")

        }
       
        if(isValidEmail(self.email_lbl.text!) == false)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Check Email Id ")

        }
        if(self.country_txt.text == "" || self.country_txt.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Select Country")

        }
        if(self.mobile_lbl.text == "" || self.mobile_lbl.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Mobile Number ")

        }
        if(isValidMobile(testStr: self.mobile_lbl.text!) == false)
        {
           Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Check Mobile Number ")

        }
        if(self.password_lbl.text == "" || self.password_lbl.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Password ")

        }
        if(self.confirm_lbl.text == "" || self.confirm_lbl.text?.isEmpty == true)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Confirm Password ")

        }
        if(self.password_lbl.text != self.confirm_lbl.text)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Password And Confirm Password Doesn’t Match")

        }
       
        else{
            
            let getparentdetails: NSMutableDictionary = NSMutableDictionary()
            getparentdetails.setValue(firstname_lbl.text!, forKey: "first_name")
            getparentdetails.setValue(middlename_lbl.text!, forKey: "middle_name")
            getparentdetails.setValue(lastname_lbl.text!, forKey: "last_name")
            getparentdetails.setValue(email_lbl.text!, forKey: "email_address")
            getparentdetails.setValue(dob_lbl.text!, forKey: "dob")
            getparentdetails.setValue(mobile_lbl.text!, forKey: "mobile_number")
            getparentdetails.setValue(suffix_lbl.text!, forKey: "suffix")
            getparentdetails.setValue(confirm_lbl.text!, forKey: "confirm_password")
            getparentdetails.setValue(password_lbl.text!, forKey: "password")
            
            let children: NSArray = userdetails.value(forKey: "children") as! NSArray
            if(children.count > 0)
            {
                if #available(iOS 13.0, *) {
                    let objpersonalVC: InvitePlayerVC = (self.storyboard?.instantiateViewController(identifier: "inviteplayer"))!
                    objpersonalVC.userdetails = userdetails
                    objpersonalVC.parententerdetails = getparentdetails
                    self.navigationController?.pushViewController(objpersonalVC, animated: true)
                } else {
                    let objpersonalVC: InvitePlayerVC = (self.storyboard?.instantiateViewController(withIdentifier: "inviteplayer"))! as! InvitePlayerVC
                    objpersonalVC.userdetails = userdetails
                    objpersonalVC.parententerdetails = getparentdetails
                    self.navigationController?.pushViewController(objpersonalVC, animated: true)
                }
           
            }
            else
            {
                if #available(iOS 13.0, *) {
                    let objcoppaparentVC: TermAndConditionVC = (self.storyboard?.instantiateViewController(identifier: "termandcon"))!
                    objcoppaparentVC.parentdetails = getparentdetails
                    objcoppaparentVC.signuserDetail = userdetails
                    self.navigationController?.pushViewController(objcoppaparentVC, animated: true)
                } else {
                    let objcoppaparentVC: TermAndConditionVC = (self.storyboard?.instantiateViewController(withIdentifier: "termandcon"))! as! TermAndConditionVC
                                       objcoppaparentVC.parentdetails = getparentdetails
                                       objcoppaparentVC.signuserDetail = userdetails
                                       self.navigationController?.pushViewController(objcoppaparentVC, animated: true)
                }
                
            }
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
                    Constant.showInActivityIndicatory()

                  }
              // Constant.showInActivityIndicatory()

                   }
               }
           
       }
    @IBAction func UpdateDOBClick(_ sender: UIButton) {
        date_picker_view.isHidden = false
        //let picker : UIDatePicker = UIDatePicker()
        date_picker.datePickerMode = .date
        let currentDate = NSDate()
        date_picker.maximumDate = currentDate as Date
        date_picker.date = currentDate as Date
        date_picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControlEvents.valueChanged)
        let pickerSize : CGSize = date_picker.sizeThatFits(CGSize.zero)
        date_picker.frame = CGRect(x:0.0, y:250, width:pickerSize.width, height:300)
        date_picker.backgroundColor = UIColor.lightText

    }
    @objc func dueDateChanged(sender:UIDatePicker){
        date_done_btn.setTitleColor(UIColor.blue, for: .normal)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
       let formatter = DateFormatter()
       formatter.dateFormat = "dd/MM/yyyy"

        selectdate = formatter.string(from: sender.date)
       
   // dobButton.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    }
    @IBAction func cancel_btn(_ sender: UIButton)
    {
        date_picker_view.isHidden = true
    }
    
    @IBAction func done(_ sender: UIButton)
    {
        date_picker_view.isHidden = true
         dob_lbl.text = selectdate
    }
}
