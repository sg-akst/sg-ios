//
//  InvitePlayerVC.swift
//  SportsGravy
//
//  Created by CSS on 30/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
struct editText {
    let id: Int
    let email : String
}

class InvitePlayerVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ParentconsentDelegate {
    func parentconsentform() {
        
        let checkcount = UserDefaults.standard.integer(forKey: "13belowagecount")
        if(checkcount < emilladdArray.count)
        {
            self.emilladdArray.removeObject(at: 0)
            
        }
        let objcoppaparentVC: CoppaParentFormVC = (self.storyboard?.instantiateViewController(identifier: "coppaform"))!
        objcoppaparentVC.delegate = self
        objcoppaparentVC.details = emilladdArray
        objcoppaparentVC.parentDetails = parententerdetails
        
        self.navigationController?.pushViewController(objcoppaparentVC, animated: true)
        
        
    }
    
    @IBOutlet var children_tbl: UITableView!

    
    var userdetails: NSDictionary!
    var chidArray: NSMutableArray!
    var allCellsText = [editText]()
    var belowAgecount: Int = 0
    var emilladdArray: NSMutableArray!
    var isParentconsent: Bool!
    var parententerdetails: NSMutableDictionary!

    
    override func viewDidLoad() {
        super.viewDidLoad()
         let dic = userdetails
        let playerlist: NSArray = dic?.value(forKey: "children") as! NSArray
        self.chidArray = playerlist.mutableCopy() as? NSMutableArray
        self.children_tbl.delegate = self
        self.children_tbl.dataSource = self
        self.children_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        children_tbl.sizeToFit()
       

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.chidArray.count
            
    }
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return 70.0
            }
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

let cell: ChildernCell = self.children_tbl.dequeueReusableCell(withIdentifier: "InviteFriend_cell") as! ChildernCell
let dic: NSDictionary = chidArray?[indexPath.row] as! NSDictionary
    cell.username_lbl.text = "\(dic.value(forKey: "first_name")!)" + " " + "\(dic.value(forKey: "last_name")!)"
    cell.emailid_txt.text = dic.value(forKey: "email_address") as? String
    cell.emailid_txt.delegate = self
    cell.age_lbl.text = "Age: \(dic.value(forKey: "age")!)"
    cell.emailid_txt.tag = indexPath.row
    cell.emailid_txt.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)


    cell.selectionStyle = .none
    cell.accessoryType = .none
    return cell
            
    }
           
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
              
    }
    @objc func textFieldDidChange(_ sender: UITextField)
    {
        let selectbutton = sender
        let cell = selectbutton.superview?.superview as? ChildernCell
        print(cell)
        print("textFieldDidChange: \(self.children_tbl.indexPathForSelectedRow?.row ?? 0)")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //allCellsText.append(textField.text)
        print("texttag=>\(textField.tag)")
        let oldic: NSDictionary = self.chidArray?[textField.tag] as! NSDictionary
        var replaceDic: NSMutableDictionary = NSMutableDictionary()
        replaceDic = oldic.mutableCopy() as! NSMutableDictionary
        replaceDic.setValue(textField.text, forKey: "email_address")
        let assigndic: NSDictionary = replaceDic.copy() as! NSDictionary
        self.chidArray.replaceObject(at: textField.tag, with: assigndic)
        if(textField.text! != "")
        {
           self.allCellsText.append(editText(id: textField.tag, email: textField.text!))
        }
        print(textField)
    }
    @IBAction func invitplayerBtn(_ sender: UIButton)
    {
        let selectbutton = sender
        let cell = selectbutton.superview as? ChildernCell
        cell?.inviteBtn.sendActions(for: .touchUpInside)
        
        emilladdArray = NSMutableArray()
        for i in 0..<self.allCellsText.count
        {
            //sender.tag = i
            let getdetail = allCellsText[i]
            let getTag = getdetail.id
            let getemail: String = getdetail.email
            let dic: NSDictionary = chidArray?[getTag] as! NSDictionary
            if(getemail.isEmpty == false && (dic.value(forKey: "age") != nil))
            {
                belowAgecount += 1
                emilladdArray.add(dic)
            }
        }
        UserDefaults.standard.set(belowAgecount, forKey: "13belowagecount")

        if(self.emilladdArray.count > 0)
        {
            let objcoppaparentVC: CoppaParentFormVC = (self.storyboard?.instantiateViewController(identifier: "coppaform"))!
            objcoppaparentVC.delegate = self
            objcoppaparentVC.details = emilladdArray
            objcoppaparentVC.parentDetails = parententerdetails
            
            self.navigationController?.pushViewController(objcoppaparentVC, animated: true)
        }
        else
        {
           let objcoppaparentVC: TermAndConditionVC = (self.storyboard?.instantiateViewController(identifier: "termandcon"))!
            objcoppaparentVC.parentdetails = parententerdetails
            objcoppaparentVC.signuserDetail = userdetails
            self.navigationController?.pushViewController(objcoppaparentVC, animated: true)
        }
        
        
    }

}
