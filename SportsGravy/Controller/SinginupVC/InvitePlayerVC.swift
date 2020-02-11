//
//  InvitePlayerVC.swift
//  SportsGravy
//
//  Created by CSS on 30/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class InvitePlayerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var children_tbl: UITableView!
    
    var userdetails: NSDictionary!
    var chidArray: NSMutableArray!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.children_tbl.delegate = self
        self.children_tbl.dataSource = self
        self.children_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

         let dic = userdetails
        children_tbl.sizeToFit()
        
        let playerlist: NSArray = dic?.value(forKey: "children") as! NSArray
        chidArray = NSMutableArray()
        self.chidArray = playerlist.mutableCopy() as? NSMutableArray
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.chidArray.count
            
    }
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return 70.0
            }
// create a cell for each table view row
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

let cell: ChildernCell = self.children_tbl.dequeueReusableCell(withIdentifier: "InviteFriend_cell") as! ChildernCell
let dic: NSDictionary = chidArray?[indexPath.row] as! NSDictionary
    cell.username_lbl.text = "\(dic.value(forKey: "first_name")!)" + " " + "\(dic.value(forKey: "last_name")!)"
    cell.emailid_txt.text = dic.value(forKey: "email_address") as? String
    cell.age_lbl.text = "Age: \(dic.value(forKey: "age")!)"
    cell.selectionStyle = .none
    cell.accessoryType = .none

                       return cell
            
           }
           
           
           func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
              
           }
   

}
