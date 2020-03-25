//
//  SittingsVC.swift
//  SportsGravy
//
//  Created by CSS on 27/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class SittingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    @IBOutlet weak var sitting_tbl: UITableView!

    var sittingslistArray: NSMutableArray!
    var is_user_group_team: Bool!
    var is_user_group_user: Bool!
    var is_user_group_custom: Bool!
    
    var is_tag_team: Bool!
    var is_tag_user: Bool!
    var is_tag_custom: Bool!
    
    var is_canned_team: Bool!
    var is_canned_user: Bool!
    var is_canned_custom: Bool!
    
    @IBOutlet weak var feed_post_switch: UISwitch!
    
    @IBOutlet weak var user_group_team: UIButton!
    @IBOutlet weak var user_group_user: UIButton!
    @IBOutlet weak var user_group_custom: UIButton!
    
    @IBOutlet weak var tag_team: UIButton!
    @IBOutlet weak var tag_user: UIButton!
    @IBOutlet weak var tag_custom: UIButton!
    
    @IBOutlet weak var canned_team: UIButton!
    @IBOutlet weak var canned_user: UIButton!
    @IBOutlet weak var canned_custom: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDefaults.standard.bool(forKey: "user_group_team") == true)
        {
            user_group_team.setImage(UIImage(named: "select"), for: .normal)
        }
        else if(UserDefaults.standard.bool(forKey: "user_group_user") == true)
        {
            user_group_user.setImage(UIImage(named: "select"), for: .normal)
        }
        else  if(UserDefaults.standard.bool(forKey: "user_group_custom") == true)
        {
            user_group_custom.setImage(UIImage(named: "select"), for: .normal)
        }
        
        if(UserDefaults.standard.bool(forKey: "tag_team") == true)
        {
            tag_team.setImage(UIImage(named: "select"), for: .normal)
        }
        else if(UserDefaults.standard.bool(forKey: "tag_user") == true)
        {
            tag_user.setImage(UIImage(named: "select"), for: .normal)
        }
        else  if(UserDefaults.standard.bool(forKey: "tag_custom") == true)
        {
            tag_custom.setImage(UIImage(named: "select"), for: .normal)
        }
        
        if(UserDefaults.standard.bool(forKey: "canned_team") == true)
        {
            canned_team.setImage(UIImage(named: "select"), for: .normal)
        }
        else if(UserDefaults.standard.bool(forKey: "canned_user") == true)
        {
            canned_user.setImage(UIImage(named: "select"), for: .normal)
        }
        else  if(UserDefaults.standard.bool(forKey: "canned_custom") == true)
        {
            canned_custom.setImage(UIImage(named: "select"), for: .normal)
        }
        
        if(UserDefaults.standard.bool(forKey: "feedpost"))
        {
            feed_post_switch.isOn = true
        }
        
        
//        sitting_tbl.delegate = self
//        sitting_tbl.dataSource = self
//        sittingslistArray = NSMutableArray()
//        let titleArray  = ["Feed Post", "User Groups", "Tags", "Canned Responses"]
//        let subTitle   = ["Enable Posting Feed When WIFI is Connected","Enable Custom Sort ordering","Enable Custom Sort ordering","Enable Custom Sort ordering"]
//        for i in 0..<titleArray.count
//        {
//            let createList: NSMutableDictionary = NSMutableDictionary()
//            createList.setValue(titleArray[i], forKey: "title")
//            createList.setValue(subTitle[i], forKey: "subTitle")
//            sittingslistArray.add(createList)
//        }
//        sitting_tbl.tableFooterView = UIView()
//        sitting_tbl.sizeToFit()


    }
    
    @IBAction func user_group_teams_btn(_ sender: UIButton)
    {
        if(UserDefaults.standard.bool(forKey: "user_group_team") == true)
        {
            UserDefaults.standard.set(false, forKey: "user_group_team")
            UserDefaults.standard.set(false, forKey: "user_group_user")
            UserDefaults.standard.set(false, forKey: "user_group_custom")
            user_group_team.setImage(UIImage(named: "unselect"), for: .normal)
            user_group_team.setTitleColor(UIColor.clear, for: .normal)
            user_group_user.setImage(UIImage(named: "unselect"), for: .normal)
            user_group_custom.setImage(UIImage(named: "unselect"), for: .normal)
            is_user_group_team = false
        }
        else
        {
        UserDefaults.standard.set(true, forKey: "user_group_team")
        UserDefaults.standard.set(false, forKey: "user_group_user")
        UserDefaults.standard.set(false, forKey: "user_group_custom")
        user_group_team.setImage(UIImage(named: "select"), for: .normal)
        user_group_team.setTitleColor(UIColor.green, for: .normal)
        user_group_user.setImage(UIImage(named: "unselect"), for: .normal)
        user_group_custom.setImage(UIImage(named: "unselect"), for: .normal)
            is_user_group_team = true
        }
    }
    
    @IBAction func user_group_user_btn(_ sender: UIButton)
    {
       if(UserDefaults.standard.bool(forKey: "user_group_user") == true)
        {
            UserDefaults.standard.set(false, forKey: "user_group_team")
            UserDefaults.standard.set(false, forKey: "user_group_user")
            UserDefaults.standard.set(false, forKey: "user_group_custom")
            user_group_team.setImage(UIImage(named: "unselect"), for: .normal)
            user_group_team.setTitleColor(UIColor.clear, for: .normal)
            user_group_user.setImage(UIImage(named: "unselect"), for: .normal)
            user_group_custom.setImage(UIImage(named: "unselect"), for: .normal)
            is_user_group_user = false
        }
        else
        {
        UserDefaults.standard.set(false, forKey: "user_group_team")
        UserDefaults.standard.set(true, forKey: "user_group_user")
        UserDefaults.standard.set(false, forKey: "user_group_custom")
        user_group_user.setImage(UIImage(named: "select"), for: .normal)
        user_group_user.setTitleColor(UIColor.green, for: .normal)
        user_group_team.setImage(UIImage(named: "unselect"), for: .normal)
        user_group_custom.setImage(UIImage(named: "unselect"), for: .normal)
            is_user_group_user = true
        }
    }
    @IBAction func user_group_custom_btn(_ sender: UIButton)
    {
       if(UserDefaults.standard.bool(forKey: "user_group_custom") == true)
        {
            UserDefaults.standard.set(false, forKey: "user_group_team")
            UserDefaults.standard.set(false, forKey: "user_group_user")
            UserDefaults.standard.set(false, forKey: "user_group_custom")
            user_group_custom.setImage(UIImage(named: "unselect"), for: .normal)
            user_group_custom.setTitleColor(UIColor.clear, for: .normal)
            user_group_user.setImage(UIImage(named: "unselect"), for: .normal)
            user_group_team.setImage(UIImage(named: "unselect"), for: .normal)
            is_user_group_custom = false
        }
        else
        {
        UserDefaults.standard.set(false, forKey: "user_group_team")
        UserDefaults.standard.set(false, forKey: "user_group_user")
        UserDefaults.standard.set(true, forKey: "user_group_custom")
        user_group_custom.setImage(UIImage(named: "select"), for: .normal)
        user_group_custom.setTitleColor(UIColor.green, for: .normal)
        user_group_team.setImage(UIImage(named: "unselect"), for: .normal)
        user_group_user.setImage(UIImage(named: "unselect"), for: .normal)
            is_user_group_custom = true
        }
    }
    
    @IBAction func tag_team_btn(_ sender: UIButton)
    {
        if(UserDefaults.standard.bool(forKey: "tag_team") == true)
        {
           UserDefaults.standard.set(false, forKey: "tag_team")
           UserDefaults.standard.set(false, forKey: "tag_user")
           UserDefaults.standard.set(false, forKey: "tag_custom")
           tag_team.setImage(UIImage(named: "unselect"), for: .normal)
           tag_user.setImage(UIImage(named: "unselect"), for: .normal)
           tag_custom.setImage(UIImage(named: "unselect"), for: .normal)
           is_tag_team = false
        }
        else
        {
           UserDefaults.standard.set(true, forKey: "tag_team")
           UserDefaults.standard.set(false, forKey: "tag_user")
           UserDefaults.standard.set(false, forKey: "tag_custom")
           tag_team.setImage(UIImage(named: "select"), for: .normal)
           tag_user.setImage(UIImage(named: "unselect"), for: .normal)
           tag_custom.setImage(UIImage(named: "unselect"), for: .normal)
            is_tag_team = true
        }
    }
    
    @IBAction func tag_user_btn(_ sender: UIButton)
    {
     if(UserDefaults.standard.bool(forKey: "tag_user") == true)
        {
            UserDefaults.standard.set(false, forKey: "tag_team")
            UserDefaults.standard.set(false, forKey: "tag_user")
            UserDefaults.standard.set(false, forKey: "tag_custom")
            tag_team.setImage(UIImage(named: "unselect"), for: .normal)
            tag_user.setImage(UIImage(named: "unselect"), for: .normal)
            tag_custom.setImage(UIImage(named: "unselect"), for: .normal)
            is_tag_user = false
        }
        else
        {
        UserDefaults.standard.set(false, forKey: "tag_team")
        UserDefaults.standard.set(true, forKey: "tag_user")
        UserDefaults.standard.set(false, forKey: "tag_custom")
        tag_user.setImage(UIImage(named: "select"), for: .normal)
        tag_team.setImage(UIImage(named: "unselect"), for: .normal)
        tag_custom.setImage(UIImage(named: "unselect"), for: .normal)
        is_tag_user = true
        }
    }
    
    @IBAction func tag_custom_btn(_ sender: UIButton)
    {
        if(UserDefaults.standard.bool(forKey: "tag_custom") == true)
         {
             UserDefaults.standard.set(false, forKey: "tag_team")
             UserDefaults.standard.set(false, forKey: "tag_user")
             UserDefaults.standard.set(false, forKey: "tag_custom")
             tag_custom.setImage(UIImage(named: "unselect"), for: .normal)
             tag_user.setImage(UIImage(named: "unselect"), for: .normal)
             tag_team.setImage(UIImage(named: "unselect"), for: .normal)
             is_tag_custom = false
         }
         else
         {
         UserDefaults.standard.set(false, forKey: "tag_team")
         UserDefaults.standard.set(false, forKey: "tag_user")
         UserDefaults.standard.set(true, forKey: "tag_custom")
         tag_custom.setImage(UIImage(named: "select"), for: .normal)
         tag_custom.setTitleColor(UIColor.green, for: .normal)
         tag_team.setImage(UIImage(named: "unselect"), for: .normal)
         tag_user.setImage(UIImage(named: "unselect"), for: .normal)
         is_tag_custom = true
         }
    }
    
    @IBAction func canned_team_btn(_ sender: UIButton)
    {
        if(UserDefaults.standard.bool(forKey: "canned_team") == true)
        {
           UserDefaults.standard.set(false, forKey: "canned_team")
           UserDefaults.standard.set(false, forKey: "canned_user")
           UserDefaults.standard.set(false, forKey: "canned_custom")
           canned_team.setImage(UIImage(named: "unselect"), for: .normal)
           canned_user.setImage(UIImage(named: "unselect"), for: .normal)
           canned_custom.setImage(UIImage(named: "unselect"), for: .normal)
           is_canned_team = false
        }
        else
        {
           UserDefaults.standard.set(true, forKey: "canned_team")
           UserDefaults.standard.set(false, forKey: "canned_user")
           UserDefaults.standard.set(false, forKey: "canned_custom")
           canned_team.setImage(UIImage(named: "select"), for: .normal)
           canned_user.setImage(UIImage(named: "unselect"), for: .normal)
           canned_custom.setImage(UIImage(named: "unselect"), for: .normal)
            is_canned_team = true
        }
    }
    
    @IBAction func canned_user_btn(_ sender: UIButton)
    {
     if(UserDefaults.standard.bool(forKey: "canned_user") == true)
        {
            UserDefaults.standard.set(false, forKey: "canned_team")
            UserDefaults.standard.set(false, forKey: "canned_user")
            UserDefaults.standard.set(false, forKey: "canned_custom")
            canned_team.setImage(UIImage(named: "unselect"), for: .normal)
            canned_user.setImage(UIImage(named: "unselect"), for: .normal)
            canned_custom.setImage(UIImage(named: "unselect"), for: .normal)
            is_canned_user = false
        }
        else
        {
        UserDefaults.standard.set(false, forKey: "canned_team")
        UserDefaults.standard.set(true, forKey: "canned_user")
        UserDefaults.standard.set(false, forKey: "canned_custom")
        canned_user.setImage(UIImage(named: "select"), for: .normal)
        canned_team.setImage(UIImage(named: "unselect"), for: .normal)
        canned_custom.setImage(UIImage(named: "unselect"), for: .normal)
        is_canned_user = true
        }
    }
    
    @IBAction func canned_custom_btn(_ sender: UIButton)
    {
        if(UserDefaults.standard.bool(forKey: "canned_custom") == true)
         {
             UserDefaults.standard.set(false, forKey: "canned_team")
             UserDefaults.standard.set(false, forKey: "canned_user")
             UserDefaults.standard.set(false, forKey: "canned_custom")
             canned_custom.setImage(UIImage(named: "unselect"), for: .normal)
             canned_user.setImage(UIImage(named: "unselect"), for: .normal)
             canned_team.setImage(UIImage(named: "unselect"), for: .normal)
             is_canned_custom = false
         }
         else
         {
         UserDefaults.standard.set(false, forKey: "canned_team")
         UserDefaults.standard.set(false, forKey: "canned_user")
         UserDefaults.standard.set(true, forKey: "canned_custom")
         canned_custom.setImage(UIImage(named: "select"), for: .normal)
         canned_custom.setTitleColor(UIColor.green, for: .normal)
         canned_team.setImage(UIImage(named: "unselect"), for: .normal)
         canned_user.setImage(UIImage(named: "unselect"), for: .normal)
         is_canned_custom = true
         }
    }
    
 @IBAction func switchIsChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            UserDefaults.standard.set(true, forKey: "feedpost")

        } else {
            UserDefaults.standard.set(false, forKey: "feedpost")

        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.sittingslistArray.count
    
            }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    
           return 69.0

     }

            // create a cell for each table view row
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell: SittingCell = self.sitting_tbl.dequeueReusableCell(withIdentifier: "sittingCell") as! SittingCell
    let dic: NSDictionary = sittingslistArray?[indexPath.row] as! NSDictionary
    cell.segment_btn.tag = indexPath.row
    cell.title_lbl?.text = dic.value(forKey: "title") as? String
    cell.subtitle_lbl.text = dic.value(forKey: "subTitle") as? String
   // cell.segment_btn.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
    cell.segment_btn.tag = indexPath.row
    if(UserDefaults.standard.integer(forKey: ("\(indexPath.row)")) == indexPath.row)
    {
        print("check bool \(UserDefaults.standard.integer(forKey: ("\(indexPath.row)")))")
        if((UserDefaults.standard.integer(forKey: ("\(indexPath.row)"))) == 1)
        {
            cell.segment_btn.isOn = true
        }
        else
        {
            cell.segment_btn.isOn = false
        }
        
    }
    else{
        print("check bool \(UserDefaults.standard.integer(forKey: ("\(indexPath.row)")))")
        if((UserDefaults.standard.integer(forKey: ("\(indexPath.row)"))) == 1)
               {
                   cell.segment_btn.isOn = true

               }
               else
               {
                   cell.segment_btn.isOn = false

               }

    }
    return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You tapped cell number \(indexPath.row).")
       
        
    }
//   @IBAction func switchValueDidChange(_ sender: UISwitch){
//       let button = sender
//    let cell = button.superview?.superview as? SittingCell
//        if sender.isOn {
//           cell?.segment_btn.isOn =  true
//            if(sender.tag == 0)
//            {
//                UserDefaults.standard.set(true, forKey: "\(button.tag)")
//
//                    Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Feed Post Only when wifi is connected")
//            }
//            if(button.tag == 1)
//            {
//                UserDefaults.standard.set(true, forKey: "\(button.tag)")
//                    Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "User group based on custom sort order")
//
//            }
//            if(button.tag == 2)
//            {
//                UserDefaults.standard.set(true, forKey: "\(button.tag)")
//
//                    Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Custom tag based on custom sort order")
//            }
//            if(button.tag == 3)
//            {
//                UserDefaults.standard.set(true, forKey: "\(button.tag)")
//
//                    Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Canned Response based on custom sort order")
//            }
//          } else {
//
//              cell?.segment_btn.isOn =  false
//           if(button.tag == 0)
//           {
//               UserDefaults.standard.set(false, forKey: "\(button.tag)")
//            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Feed Post with both wifi and mobile network")
//           }
//           if(button.tag == 1)
//           {
//               UserDefaults.standard.set(false, forKey: "\(button.tag)")
//             Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "User group based on frequently used order ")
//           }
//           if(button.tag == 2)
//           {
//               UserDefaults.standard.set(false, forKey: "\(button.tag)")
//            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Custom Tag based on frequently used order")
//           }
//           if(button.tag == 3)
//           {
//               UserDefaults.standard.set(false, forKey: "\(button.tag)")
//             Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Canned Response based on frequently used order")
//           }
//          }
//
//      }
@IBAction func settingcancelbtn(_ sender: UIButton)
{
    self.navigationController?.popViewController(animated: true)
}
}
