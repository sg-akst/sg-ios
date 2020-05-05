//
//  PopVC.swift
//  SportsGravy
//
//  Created by CSS on 23/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

protocol PopViewDelegate: AnyObject {
    func selectoptionString(selectSuffix: String)

}

class PopVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var suffixArray = [String] ()
      @IBOutlet weak var popTbl: UITableView!
    @IBOutlet weak var title_lbl: UILabel!
    var Title: String!

      weak var delegate:PopViewDelegate?


      override func viewDidLoad() {
          super.viewDidLoad()
        title_lbl.text = Title
        popTbl.tableFooterView = UIView()
        popTbl.sizeToFit()

        
      }
      
      func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
      
      public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.suffixArray.count
      }
      public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 50.0
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popcell", for: indexPath)
        //let dic: NSDictionary = self.suffixArray?[indexPath.row] as! NSDictionary
        cell.textLabel?.text = (self.suffixArray[indexPath.row] )
          return cell
      }
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectoptionString(selectSuffix: self.suffixArray[indexPath.row] )
        popupController?.dismiss()
         
      }
   
       @IBAction func didclickcancel(_ sender: UIButton)
       {
       // Crashlytics.sharedInstance().crash()
          popupController?.dismiss()
      }

}
