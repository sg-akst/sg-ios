//
//  InviteGuardianVC.swift
//  SportsGravy
//
//  Created by CSS on 10/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Alamofire

class InviteGuardianVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var guardianemail_txt: UITextField!
    @IBOutlet weak var guardianmobil_txt: UITextField!
    @IBOutlet weak var playerlist_tbl: UITableView!
    var player_list_Array: NSMutableArray!
    var selectpersonArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerlist_tbl.delegate = self
        self.playerlist_tbl.dataSource = self
        guardianmobil_txt.delegate = self
        guardianemail_txt.delegate = self
        
        bottomlineMethod(selecttext: guardianmobil_txt)
        bottomlineMethod(selecttext: guardianemail_txt)
        playerlist_tbl.sizeToFit()
        
        
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
       
            return self.player_list_Array.count
        
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
           return 50.0
        
     }
            // create a cell for each table view row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: InviteCell = self.playerlist_tbl.dequeueReusableCell(withIdentifier: "invite") as! InviteCell
            let dic: NSDictionary = player_list_Array?[indexPath.row] as! NSDictionary
           cell.playername.text = "\(dic.value(forKey: "first_name")!)" + "" + "\(dic.value(forKey: "last_name")!)"
            cell.checkbox.layer.cornerRadius = cell.checkbox.frame.size.width/2
            cell.checkbox.layer.masksToBounds = true
            cell.checkbox.layer.borderWidth = 3
            cell.checkbox.layer.borderColor = Constant.getUIColor(hex: "#C0CCDA")?.cgColor
            cell.checkbox.backgroundColor =  UIColor.clear
            cell.checkbox.tag = indexPath.section
            cell.checkbox.addTarget(self, action: #selector(selectplayer), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.accessoryType = .none
                return cell
    }
    @objc func selectplayer(_ sender: UIButton)
    {
        print(sender.tag)
        let button = sender
        let cell = button.superview?.superview as? InviteCell
        let indexPaths = playerlist_tbl.indexPath(for: cell!)
        let dicvalu: NSDictionary = player_list_Array?[sender.tag] as! NSDictionary
        print(dicvalu)
        
       if cell?.checkbox.backgroundColor == UIColor.green
        {
            cell?.checkbox.backgroundColor = UIColor.clear
            self.selectpersonArray.remove(at: button.tag)
        }
        else
       {
        cell?.checkbox.backgroundColor = UIColor.green
        //let getvalue: NSMutableDictionary = self.player_list_Array[sender.tag] as! NSMutableDictionary
        let userid = dicvalu.value(forKey: "user_id")
        selectpersonArray.append(userid as! String)
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
    }
    
    @IBAction func updateinviteGuardian(_ sender: UIButton)
    {
        if(guardianemail_txt.text!.isEmpty)
          {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter email address")
          }
        else if Constant.isValidEmail(testStr: guardianemail_txt.text!) == false{
              print("Validate EmailID")
              Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter valid email address")
          }
       else if(guardianmobil_txt.text == nil || guardianmobil_txt.text?.isEmpty == true
            || isValidMobile(testStr: guardianmobil_txt.text!) == false)
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter mobile number")
        }
        else
        {
            Constant.internetconnection(vc: self)
            Constant.showActivityIndicatory(uiView: self.view)
            Constant.internetconnection(vc: self)
            let getuuid = UserDefaults.standard.string(forKey: "UUID")

            let testStatusUrl: String = Constant.sharedinstance.inviteGuardianUrl
            let header: HTTPHeaders  = [
                "idtoken": UserDefaults.standard.string(forKey: "idtoken")!]
            let parameter: [String: Any] = [
                "uid" : getuuid!,
                "email_address" : guardianemail_txt.text!,
                "mobile_phone" : guardianmobil_txt.text!,
                 "players" : selectpersonArray]
            
            let urlString = "\(testStatusUrl)"
            let url = URL.init(string: urlString)
            print("parameter=>\(parameter)")
        
            AF.request(url!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { response in
                 switch response.result
                {
                case .success(let json):
                 let jsonData = json
                    print(jsonData)
                 let dic: NSDictionary = jsonData as! NSDictionary
                 Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "\(dic.value(forKey: "message")!)")
                    Constant.showInActivityIndicatory()

                    
                 case .failure(let error): break
                 print(error)
                   // self.errorFailer(error: error)
                    Constant.showInActivityIndicatory()

                }
                Constant.showInActivityIndicatory()
            }
        }
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
     @IBAction func cancelbtn(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
