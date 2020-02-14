//
//  PostTagVC.swift
//  SportsGravy
//
//  Created by CSS on 14/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class PostTagVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var posttag_tbl: UITableView!
    
    var taglist: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taglist = NSMutableArray()
        posttag_tbl.tableFooterView = UIView()
        posttag_tbl.sizeToFit()
        
       
    }
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
       public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.taglist.count
       }
       public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50.0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           let dic: NSDictionary = self.taglist[indexPath.row] as! NSDictionary
           cell.textLabel?.text = dic.value(forKey: "reation_title") as? String
           return cell
       }
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
          
       }
    @IBAction func backpostTagbtn(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
