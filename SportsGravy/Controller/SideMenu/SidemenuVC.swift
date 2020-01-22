//
//  SidemenuVC.swift
//  SportsGravy
//
//  Created by CSS on 07/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import Kingfisher
import FirebaseFirestore

class SidemenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileimg: UIImageView!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var role_tbl: UITableView!
    @IBOutlet weak var user_view: UIView!
    @IBOutlet weak var settings_view: UIView!
    @IBOutlet weak var usergroup_btn: UIButton!
    @IBOutlet weak var tag_btn: UIButton!
    @IBOutlet weak var canned_btn: UIButton!
    @IBOutlet weak var setting_btn: UIButton!
    @IBOutlet weak var logout_btn: UIButton!

    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userviewHeightConstraint: NSLayoutConstraint!

    
    var roleArray: [String]!
    var roleby_reasonArray: NSMutableArray!
    var getSameRoleArray: NSMutableArray!
    var isTeamEnable: String!
    var getRole: String!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.roleArray = NSMutableArray() as? [String]
        self.roleby_reasonArray = NSMutableArray()
        self.role_tbl.delegate = self
        self.role_tbl.dataSource = self
        getuserDetail()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    func getuserDetail()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
               
               let db = Firestore.firestore()
              let docRef = db.collection("users").document("\(getuuid!)")

              docRef.getDocument { (document, error) in
                  
                  if let document = document, document.exists {
                   let doc: NSDictionary = document.data()! as NSDictionary
                    self.username_lbl.text = "\(doc.value(forKey: "first_name")!)" + " " + "\(doc.value(forKey: "middle_initial")!)" + " " + "\(doc.value(forKey: "last_name")!)"
                    
                   let timestamp: Timestamp = doc.value(forKey: "created_datetime") as! Timestamp
                    let datees: Date = timestamp.dateValue()
                    print(datees)
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "MMM dd,yyyy"
                    print(dateFormatterPrint.string(from: datees as Date))

                    self.date_lbl.text = "Joined \(dateFormatterPrint.string(from: datees as Date))"
                    let url = URL(string: "\(doc.value(forKey: "profile_image")!)")
                    if(url != nil)
                    {
                      self.profileimg.kf.setImage(with: url)
                        self.profileimg.layer.cornerRadius = self.profileimg.frame.size.width/2
                        self.profileimg.layer.backgroundColor = UIColor.lightGray.cgColor
                    }
                    docRef.collection("roles_by_season").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            self.roleby_reasonArray = NSMutableArray()
                            for document in querySnapshot!.documents {
                                let data: NSDictionary = document.data() as NSDictionary
                                   self.roleby_reasonArray.add(data)
                            }
                            var filteredEvents: [String] = self.roleby_reasonArray.value(forKeyPath: "@distinctUnionOfObjects.role") as! [String]
                            filteredEvents.sort(){$0 < $1}
                            print(filteredEvents)
                            let firstrole = filteredEvents[0]
                            self.roleArray = filteredEvents;
                            self.role_tbl.reloadData()
                            self.rolebaseddisplayviewMethod(SelectRole: firstrole)
                            self.tableViewHeightConstraint.constant = self.role_tbl.contentSize.height + 10

                        }
                    }

                    
                   
                  } else {
                      print("Document does not exist")
                  }
                Constant.showInActivityIndicatory()
                
              }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roleArray.count
           }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 40.0
    }

           // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: SideMenuCell = self.role_tbl.dequeueReusableCell(withIdentifier: "sideMenu") as! SideMenuCell
        //let dic: NSDictionary = roleArray?[indexPath.row] as! NSDictionary
        cell.roletype_lbl.isUserInteractionEnabled = true

        if(indexPath.row == 0)
        {
            cell.roleTitle_lbl?.text = "Role"
            cell.roletype_lbl.isUserInteractionEnabled = false

        }
       
        else
        {
            cell.roletype_lbl.setTitleColor(UIColor.init(red: 0, green: 0, blue: 255, alpha: 1.0), for: .normal)
        }
        cell.roletype_lbl?.setTitle(roleArray?[indexPath.row], for: .normal)
        cell.roletype_lbl.tag = indexPath.row
        cell.roletype_lbl.addTarget(self, action: #selector(roleChangeMethod), for: .touchUpInside)
        cell.roletype_lbl.sizeToFit()
        cell.roletype_lbl.layoutIfNeeded()
    
        return cell
        }

           // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               print("You tapped cell number \(indexPath.row).")
        }
    
    @objc func roleChangeMethod(_ sender: UIButton)
    {
        let buttonRow = sender.tag
        getRole = roleArray[buttonRow] as String
        let element = roleArray.remove(at: buttonRow)
        roleArray.insert(element, at: 0)
        role_tbl.reloadData()
        //self.isTeamEnable = ""
        
        if(getRole == "manager")
        {
            rolebaseddisplayviewMethod(SelectRole: getRole as String)
        }
        else if(getRole == "coach")
        {
            rolebaseddisplayviewMethod(SelectRole: getRole as String)

        }
        else if (getRole == "admin")
        {
            rolebaseddisplayviewMethod(SelectRole: getRole as String)

        }
        else if (getRole == "Guardian")
        {
                   
        }
        
    }
    func rolebaseddisplayviewMethod(SelectRole: String)
    {
        getSameRoleArray = NSMutableArray()
         for i in 0..<roleby_reasonArray.count
                   {
                    let roleDic: NSDictionary = roleby_reasonArray?[i] as! NSDictionary
                       let role: String = roleDic.value(forKey: "role") as! String
                       if(role == SelectRole as String)
                       {
                        self.isTeamEnable = roleDic.value(forKey: "team_id") as? String
                        getSameRoleArray.add(roleDic)
                       }
                   }
                   
                  if(self.isTeamEnable.isEmpty == false)
                   {
                       self.user_view.isHidden = false
                       self.setting_btn.isHidden = false
                    self.userviewHeightConstraint.constant = 175

                   }
                   else{
                       self.user_view.isHidden = true
                       self.setting_btn.isHidden = true
                    self.userviewHeightConstraint.constant = 0
                   }
    }
    
    @IBAction func logout_btnaction(_ sender: UIButton)
    {
         try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            
            let vc = storyboard.instantiateViewController(withIdentifier: "Signin_page") as! SigninVC
            self.navigationController?.pushViewController(vc, animated: true)
            UserDefaults.standard.removeObject(forKey: "UUID")
        }
    }
    
    @IBAction func user_group_Action(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "usergroup") as! UsergroupVC
        vc.getRolebyreasonDetailArray = self.getSameRoleArray
        vc.getSelectRole = (self.getRole == nil) ? roleArray[0] : getRole
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    @IBAction func tag_Action(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tag") as! TagVC
        vc.getRolebyreasonDetailArray = self.getSameRoleArray
        vc.getSelectRole = (self.getRole == nil) ? roleArray[0] : getRole
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    @IBAction func canned_response_Action(_ sender: UIButton)
       {
           let vc = storyboard?.instantiateViewController(withIdentifier: "Can_response") as! CannedResponseVC
           vc.getRolebyreasonDetailArray = self.getSameRoleArray
           vc.getSelectRole = (self.getRole == nil) ? roleArray[0] : getRole
           self.navigationController?.pushViewController(vc, animated: true)
          
       }
    @IBAction func profileBtn(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "acprofile") as! AccountProfileVC
        vc.getAllrole = self.roleby_reasonArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   }
