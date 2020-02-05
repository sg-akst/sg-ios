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
         let dic = userdetails
        chidArray = NSMutableArray()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
                   return self.chidArray.count
            
                   }
            func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

              
                  return 50.0
            
            }

                   // create a cell for each table view row
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
                   let cell: ChildernCell = self.children_tbl.dequeueReusableCell(withIdentifier: "tagcell") as! ChildernCell
                   let dic: NSDictionary = chidArray?[indexPath.row] as! NSDictionary
                   let count : Int = dic.value(forKey: "count") as! Int
                   //cell.delete_enable_img.tag = indexPath.row
                  // cell.delete_enable_img.addTarget(self, action: #selector(deleteGroup_Method), for: .touchUpInside)
                   cell.username_lbl?.text = dic.value(forKey: "tag_id") as? String
                   //cell.delete_enable_img.tintColor = (count > 0) ? UIColor.gray : UIColor.red
                   cell.selectionStyle = .none
                   cell.accessoryType = .none

                       return cell
            
           }
           
           
           func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
              
           }
   

}
