//
//  PostCannedVC.swift
//  SportsGravy
//
//  Created by CSS on 14/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class PostCannedVC: UIViewController {

    @IBOutlet weak var postcanned_tbl: UITableView!
    var tagCannedArray: NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        tagCannedArray = NSMutableArray()
        postcanned_tbl.tableFooterView = UIView()
        postcanned_tbl.sizeToFit()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
              return 1
          }
          
          public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return self.tagCannedArray.count
          }
          public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              return 50.0
          }
          
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "postcancell", for: indexPath)
              let dic: NSDictionary = self.tagCannedArray[indexPath.row] as! NSDictionary
              cell.textLabel?.text = dic.value(forKey: "reation_title") as? String
              return cell
          }
          func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
             
          }
    @IBAction func backpostCannedbtn(_ sender: UIButton)
       {
           self.navigationController?.popViewController(animated: true)
       }

}
