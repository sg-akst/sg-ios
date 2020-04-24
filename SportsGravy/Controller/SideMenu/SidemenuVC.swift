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

protocol sidemenuDelegate: AnyObject {
    func sidemenuselectRole(role: String, roleArray: NSMutableArray)

}



class SidemenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileimg: UIButton!
    @IBOutlet weak var profile_image_view: UIImageView!
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
    @IBOutlet weak var logoutypositionConstraint: NSLayoutConstraint!
    weak var delegate:sidemenuDelegate?


    
    var roleArray: [String]!
    var roleby_reasonArray: NSMutableArray!
    var getSameRoleArray: NSMutableArray!
    var isTeamEnable: [String]!

    var getRole: String!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.roleArray = NSMutableArray() as? [String]
        self.roleby_reasonArray = NSMutableArray()
        self.role_tbl.delegate = self
        self.role_tbl.dataSource = self
        role_tbl.sizeToFit()
       self.settings_view.isHidden = true
        self.user_view.isHidden = true
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
      getuserDetail()

    }
    func getuserDetail()
    {
        Constant.internetconnection(vc: self)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
               
               let db = Firestore.firestore()
              let docRef = db.collection("users").document("\(getuuid!)")

              docRef.getDocument { (document, error) in
                Constant.showInActivityIndicatory()
                  if let document = document, document.exists {
                   let doc: NSDictionary = document.data()! as NSDictionary
                    
                    self.username_lbl.text = "\(doc.value(forKey: "first_name")!)" + " " + "\(doc.value(forKey: "middle_initial")!)" + " " + "\(doc.value(forKey: "last_name")!)" +  " " + "\(doc.value(forKey: "suffix")!)"
                    
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
                        self.profileimg.isHidden = true
                        self.profile_image_view.isHidden = false
                        self.profile_image_view.layer.cornerRadius = self.profile_image_view.frame.size.width/2
                        self.profile_image_view.layer.masksToBounds = true
                        self.profile_image_view.kf.setImage(with: url)
                        
                    }
                    else
                    {
                        self.profileimg.layer.cornerRadius = self.profileimg.frame.size.width/2
                        self.profileimg.layer.backgroundColor = UIColor.lightGray.cgColor
                        //self.profileimg.contentMode = .scaleAspectFill
                        let name =  self.username_lbl.text
                        let nameFormatter = PersonNameComponentsFormatter()
                        if let nameComps  = nameFormatter.personNameComponents(from: name!), let firstLetter = nameComps.givenName?.first, let lastName = nameComps.givenName?.last {

                             let sortName = "\(firstLetter)\(lastName)"
                             self.profileimg.isHidden = false
                            self.profile_image_view.isHidden = true
                            self.profileimg.setTitle(sortName, for: .normal)
                           
                         }
                    }

                    docRef.collection("roles_by_season").getDocuments() { (querySnapshot, err) in
                        Constant.showInActivityIndicatory()

                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            self.roleby_reasonArray = NSMutableArray()
                            for document in querySnapshot!.documents {
                                let data: NSDictionary = document.data() as NSDictionary
                                   self.roleby_reasonArray.add(data)
                            }
                            var filteredEvents: [String] = self.roleby_reasonArray.value(forKeyPath: "@distinctUnionOfObjects.role") as! [String]
                            filteredEvents.sort()
                            print(filteredEvents)
                            self.roleArray = filteredEvents;
                            
                                var roleIndex:Int!
                            var firstrole : String!
                            if(UserDefaults.standard.value(forKey: "Role") != nil)
                            {
                            let userRole: String = UserDefaults.standard.value(forKey: "Role") as! String
                                for i in 0..<self.roleArray.count
                                {
                                    let role: String = self.roleArray[i]
                                    if(role == userRole)
                                    {
                                        roleIndex = i
                                    }
                                }
                                if(roleIndex != nil)
                                {
                                let element = self.roleArray.remove(at: roleIndex)
                                self.roleArray.insert(element, at: 0)
                             UserDefaults.standard.set(element, forKey: "Role")
                             firstrole =  filteredEvents[roleIndex]
                                }
                                else{
                                    firstrole = self.roleArray[0]
                                }
                            }
                            else
                            {
                                  firstrole = filteredEvents[0]
                            }
                            self.rolebaseddisplayviewMethod(SelectRole: firstrole)
                            self.role_tbl.reloadData()

                            self.tableViewHeightConstraint.constant = self.role_tbl.contentSize.height
                            Constant.showInActivityIndicatory()
                            self.settings_view.isHidden = false
                            self.user_view.isHidden = false
                        }
                    }

                    
                   
                  } else {
                      print("Document does not exist")
                    Constant.showInActivityIndicatory()

                  }
                //Constant.showInActivityIndicatory()
                
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
     
        cell.roletype_lbl?.setTitle(roleArray?[indexPath.row].capitalized, for: .normal)

        cell.roletype_lbl.tag = indexPath.row
        UserDefaults.standard.set(roleArray[0], forKey: "Role")
        cell.roletype_lbl.addTarget(self, action: #selector(roleChangeMethod), for: .touchUpInside)
        cell.roletype_lbl.sizeToFit()
        cell.roletype_lbl.layoutIfNeeded()
        cell.selectionStyle = .none
    
        return cell
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
//        let role_str = roleArray[indexPath.row]
//        UserDefaults.standard.set(role_str, forKey: "Role")
        }
    
    @objc func roleChangeMethod(_ sender: UIButton)
    {
         if(UserDefaults.standard.value(forKey: "Role") != nil)
        {
            UserDefaults.standard.removeObject(forKey: "Role")
        }
        let buttonRow = sender.tag
        
        getRole = roleArray[buttonRow] as String
        let element = roleArray.remove(at: buttonRow)
        roleArray.insert(element, at: 0)
        UserDefaults.standard.set(element, forKey: "Role")

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
        self.isTeamEnable = NSMutableArray() as? [String]

         for i in 0..<roleby_reasonArray.count
        {
           let roleDic: NSDictionary = roleby_reasonArray?[i] as! NSDictionary
            let role: String = roleDic.value(forKey: "role") as? String ?? ""
            let team: String = (roleDic.value(forKey: "team_id") as? String ?? nil)!

            if(role == SelectRole as String && team != "")
            {
                getSameRoleArray.add(roleDic)
            }
        }
      

        
        if(self.getSameRoleArray.count > 0)
                   {
                    
                    var filteredEvents: [String] = self.getSameRoleArray.value(forKeyPath: "@distinctUnionOfObjects.team_id") as! [String]
                    filteredEvents.removeAll { $0 == "" }
                    if(filteredEvents.count > 0)
                    {
                        self.isTeamEnable.append(contentsOf: filteredEvents)
                    }
                   }

       
        if(self.isTeamEnable.count > 0)
                   {
                    self.user_view.isHidden = false
                       self.setting_btn.isHidden = false
                    self.userviewHeightConstraint.constant = 175
                    self.logoutypositionConstraint.constant = self.setting_btn.frame.size.height-20

                   }
                   else{
                       self.user_view.isHidden = true
                       self.setting_btn.isHidden = true
                    self.userviewHeightConstraint.constant = 0
                    self.logoutypositionConstraint.constant = -(self.setting_btn.frame.size.height)

                   }
        
        self.delegate?.sidemenuselectRole(role: SelectRole, roleArray: getSameRoleArray)
    }
    
    @IBAction func logout_btnaction(_ sender: UIButton)
    {
         try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            
            let vc = storyboard.instantiateViewController(withIdentifier: "Signin_page") as! SigninVC
            self.navigationController?.pushViewController(vc, animated: true)
            UserDefaults.standard.removeObject(forKey: "UUID")
            UserDefaults.standard.removeObject(forKey: "idtoken")
        }
    }
    
    @IBAction func user_group_Action(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "usergroup") as! UsergroupVC
      // vc.getRolebyreasonDetailArray = self.getSameRoleArray
        vc.getSelectRole = (self.getRole == nil) ? roleArray[0] : getRole
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    @IBAction func tag_Action(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tag") as! TagVC
       // vc.getRolebyreasonDetailArray = self.getSameRoleArray
        vc.getSelectRole = (self.getRole == nil) ? roleArray[0] : getRole
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    @IBAction func canned_response_Action(_ sender: UIButton)
       {
           let vc = storyboard?.instantiateViewController(withIdentifier: "Can_response") as! CannedResponseVC
          // vc.getRolebyreasonDetailArray = self.getSameRoleArray
           vc.getSelectRole = (self.getRole == nil) ? roleArray[0] : getRole
           self.navigationController?.pushViewController(vc, animated: true)
          
       }
    @IBAction func profileBtn(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "acprofile") as! AccountProfileVC
        vc.getAllrole = self.roleby_reasonArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func sittingsBtn(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "sittings") as! SittingsVC
        //vc.getAllrole = self.roleby_reasonArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
   }
