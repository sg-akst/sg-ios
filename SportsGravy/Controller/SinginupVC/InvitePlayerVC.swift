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

class InvitePlayerVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var children_tbl: UITableView!
    
    var userdetails: NSDictionary!
    var chidArray: NSMutableArray!
    var allCellsText = [editText]()


    
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
        
        let emilladdArray = NSMutableArray()
        for i in 0..<chidArray.count
        {
            //sender.tag = i
            
            let dic: NSDictionary = chidArray?[i] as! NSDictionary

            if(cell?.emailid_txt.text != nil)
            {
                emilladdArray.add(dic)
            }
           // print(dic)
            
        }
        
    }

}
